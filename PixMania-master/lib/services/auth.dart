// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pixmania/models/model.dart';
import 'package:pixmania/models/usermodel.dart';

class AuthServices {
  //created ani nstance of firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

//creating a userobject from firebase user
  UserModel? getUserFromfirebase(User? user) {
    return user != null ? UserModel(userId: user.uid) : null;
  }

//detection any change in state of firebaseUser
  Stream<UserModel?> get userLog {
    return _auth
        .authStateChanges()
        .map((User? user) => getUserFromfirebase(user));
  }

// register using email and  password
  Future registerWithEmailAndPAssword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      //userModel is added with data
      UserData userData = UserData(
          uid: user!.uid,
          userName: user.email!.split('@')[0], //to remove the domain part
          bio: 'pixMania User',
          profileImage:
              'https://firebasestorage.googleapis.com/v0/b/pixmania-182c7.appspot.com/o/profilePics%2FcamLogo.png?alt=media&token=6994a6f8-fc44-4dfa-a328-c964db9a19d8',
          followers: [],
          following: [],
          chats: []);

      //function to create data base collection
      await _fireStore.collection('users').doc(user.uid).set(userData.toJson());

      return getUserFromfirebase(user);
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          return 'email-already-in-use';
        }
      }
      return null;
    }
  }

  // login using email and  password
  Future logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return getUserFromfirebase(user!);
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          return 'user-not-found';
        }
      }

      return null;
    }
  }

  //delete account

  Future deleteAccount(String email, String password) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      UserCredential result =
          await user.reauthenticateWithCredential(credentials);
      await deleteUserRecords(result.user!.uid);
      await result.user!.delete();
      return true;
    } catch (e) {
      return null;
    }
  }

  Future deleteUserRecords(String uid) async {
    try {
      await _fireStore.collection('users').doc(uid).delete();
      // Query to get all posts with the provided authorId
      QuerySnapshot querySnapshot = await _fireStore
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .get();

      // Loop through the documents and delete them one by one

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {}
  }

  // signing out
  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

//sign in using google account
  signInWithGoogle() async {
    //begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    //finally, let's sign in
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final String uid = userCredential.user!.uid;

    final userRef = _fireStore.collection('users').doc(uid);
    final userDoc = await userRef.get();

    // Check if the user's document already exists
    if (!userDoc.exists) {
      // UserModel is added with data
      UserData userData = UserData(
          uid: uid,
          userName: gUser.email.split('@')[0], //to remove the domain part
          bio: 'pixMania User',
          profileImage:
              'https://firebasestorage.googleapis.com/v0/b/pixmania-182c7.appspot.com/o/profilePics%2FcamLogo.png?alt=media&token=6994a6f8-fc44-4dfa-a328-c964db9a19d8',
          followers: [],
          following: [],
          chats: []);

      // Create the database collection for the user
      await userRef.set(userData.toJson());
    }
    return userCredential;
  }
}
