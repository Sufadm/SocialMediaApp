// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pixmania/models/post.dart';
// import 'package:pixmania/services/storage_methods.dart';
// import 'package:uuid/uuid.dart';

// class FirestoreServices {
//   final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   //method to add a post
//   Future<String> uploadPost(String description, Uint8List postFile, String uid,
//       String userName, String profileImage) async {
//     String res = "Some errror occured";
//     try {
//       String photoUrl =
//           await StorageMethods().uploadImageToStorage('posts', postFile, true);
//       //created a uniqe id for each post
//       String postId = const Uuid().v1();

//       Post post = Post(
//           uid: uid,
//           userName: userName,
//           description: description,
//           profileImage: profileImage,
//           postId: postId,
//           dateTime: DateTime.now(),
//           postUrl: photoUrl,
//           likes: []);

//       await _fireStore.collection('posts').doc(postId).set(post.toJson());
//       res = 'Success';
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }
// }
