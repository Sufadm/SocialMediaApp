// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? uid;
  final String? userName;
  final String? description;
  final String? profileImage;
  final String? postId;
  final DateTime dateTime;
  final String? postUrl;
  final likes;

  Post(
      {required this.uid,
      required this.userName,
      required this.description,
      required this.profileImage,
      required this.postId,
      required this.dateTime,
      required this.postUrl,
      required this.likes});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "userName": userName,
        "description": description,
        "profileImage": profileImage,
        "postId": postId,
        "dateTime": dateTime,
        "postUrl": postUrl,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        uid: snapshot['uid'],
        userName: snapshot['userName'],
        description: snapshot['bio'],
        profileImage: snapshot['profileImage'],
        postId: snapshot['postId'],
        dateTime: snapshot['dateTime'],
        postUrl: snapshot['postUrl'],
        likes: ['likes']);
  }
}
