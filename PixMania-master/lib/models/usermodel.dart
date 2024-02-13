import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String? userName;
  final String? bio;
  final String? profileImage;
  final List? followers;
  final List? following;
  final List? chats;
  UserData(
      {required this.uid,
      required this.userName,
      required this.bio,
      required this.profileImage,
      required this.followers,
      required this.following,
      required this.chats});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "userName": userName,
        "bio": bio,
        "profileImage": profileImage,
        "followers": followers,
        "following": following,
        "chats": chats
      };

  static UserData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
        uid: snapshot['uid'],
        userName: snapshot['userName'],
        bio: snapshot['bio'],
        profileImage: snapshot['profileImage'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        chats: snapshot['chats']);
  }
}
