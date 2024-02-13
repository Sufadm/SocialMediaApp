// ignore_for_file: use_build_context_synchronously, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pixmania/providers/userprovider.dart';
import 'package:pixmania/services/storage_methods.dart';
import 'package:pixmania/models/post.dart';
import 'package:pixmania/models/usermodel.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FireStore {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DocumentReference userCollectionReference = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);

//get data from firebase
  Future<UserData> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _fireStore.collection('users').doc(currentUser.uid).get();
    return UserData.fromSnap(snap);
  }

//update profile

  Future<void> uploadProfile(String userName, String bio,
      Uint8List profileImage, BuildContext context) async {
    String imagePath = await StorageMethods()
        .uploadImageToStorage('profilePics', profileImage, false);
    try {
      await _fireStore.collection('users').doc(_auth.currentUser!.uid).update(
          {'userName': userName, 'bio': bio, 'profileImage': imagePath});

      Provider.of<UserProvider>(context).refreshUser();
      updatePost(userName, imagePath);
    } catch (e) {}
  }

  //change post details according to change in post

  Future<void> updatePost(String userName, String imagePath) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    QuerySnapshot<Map<String, dynamic>> posts = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: _auth.currentUser!.uid)
        .get();

    final data = posts.docs;

    for (var docs in data) {
      batch.update(docs.reference, {
        'userName': userName,
        'profileImage': imagePath,
      });
    }

    await batch.commit();
  }

  //method to add a post
  Future<String> uploadPost(String description, Uint8List postFile, String uid,
      String userName, String profileImage) async {
    String res = "Some errror occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', postFile, true);
      //created a uniqe id for each post
      String postId = const Uuid().v1();

      Post post = Post(
          uid: uid,
          userName: userName,
          description: description,
          profileImage: profileImage,
          postId: postId,
          dateTime: DateTime.now(),
          postUrl: photoUrl,
          likes: []);

      await _fireStore.collection('posts').doc(postId).set(post.toJson());
      res = 'Success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //like a post
  Future<void> likePost(
    String postId,
    String uid,
    List likes,
  ) async {
    try {
      if (likes.contains(uid)) {
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {}
  }

  //comment a post
  Future<void> commentPost(String userName, String comment, String uid,
      String profileImage, String postId) async {
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v4();
        await _fireStore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profileImage,
          'name': userName,
          'comment': comment,
          'uid': uid,
          'postId': postId,
          'commentId': commentId,
          'timeofComment': DateTime.now()
        });
      }
    } catch (e) {}
  }

  //delete a comment
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _fireStore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {}
  }

//delete a post

  Future<void> deletePost(String postId, String imageUrl) async {
    try {
      // Delete the post document from Firestore
      await _fireStore.collection('posts').doc(postId).delete();

      // Delete the image from Firebase Storage
      await StorageMethods().deleteImageFromStorage(imageUrl);
    } catch (e) {}
  }

  //follow a user
  Future<void> follow(String userUid, String followUid) async {
    try {
      await _fireStore.collection('users').doc(userUid).update({
        'following': FieldValue.arrayUnion([followUid])
      });
      await _fireStore.collection('users').doc(followUid).update({
        'followers': FieldValue.arrayUnion([userUid])
      });
    } catch (e) {}
  }

  //unfollow
  Future<void> unFollow(String userUid, String followUid) async {
    try {
      await _fireStore.collection('users').doc(userUid).update({
        'following': FieldValue.arrayRemove([followUid])
      });
      await _fireStore.collection('users').doc(followUid).update({
        'followers': FieldValue.arrayRemove([userUid])
      });
    } catch (e) {}
  }
}
