import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pixmania/constants/constants.dart';
import 'package:pixmania/screens/other_screens/follow_unfollow.dart';
import 'package:pixmania/screens/settings/settings_screen.dart';
import 'package:pixmania/services/firestore.dart';
import 'package:pixmania/models/usermodel.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: Colors.white70,
      ),
      margin: const EdgeInsets.all(0),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FireStore().userCollectionReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = UserData.fromSnap(snapshot.data!);
            String imagePath = userData.profileImage ??
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZSk4gp49octHXf0Tug_Fdbd0eamGYhLd1Lcoy8j1l18_Tyt0OzkqaZ8r8TDmveiInAxo&usqp=CAU";
            String followers = userData.followers?.length.toString() ?? "0";
            String following = userData.following?.length.toString() ?? "0";
            String userName = userData.userName ?? "PixManiaUser";
            String bio = userData.bio ?? "Lets share the prcious moments";

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black87,
                          radius: 38,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(imagePath),
                            radius: 36,
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              bio,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingScreen(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Icon(Icons.menu),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(followers),
                          InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        FollowScreen(isFollowers: true),
                                  )),
                              child: const Text(
                                'Followers',
                                style: TextStyle(fontSize: 18),
                              )),
                        ],
                      ),
                      const VerticalDivider(
                        thickness: 2,
                        color: Colors.grey,
                        width: 2,
                      ),
                      Column(
                        children: [
                          Text(following),
                          InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        FollowScreen(isFollowers: false),
                                  )),
                              child: const Text(
                                'Following',
                                style: TextStyle(fontSize: 18),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                kbox20,
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('Error retrieving user data');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
