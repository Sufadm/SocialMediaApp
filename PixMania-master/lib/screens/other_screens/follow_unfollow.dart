// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pixmania/constants/constants.dart';
import 'package:pixmania/providers/userprovider.dart';
import 'package:pixmania/screens/other_screens/visit_profile.dart';
import 'package:pixmania/models/usermodel.dart';
import 'package:provider/provider.dart';

class FollowScreen extends StatelessWidget {
  FollowScreen({super.key, required this.isFollowers});
  bool isFollowers;

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserProvider>(context).getUser;
    final followerList = userData.followers;
    final followingList = userData.following;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userData.userName!,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: kboxDecoration,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'uid',
                    whereIn: isFollowers
                        ? (followerList?.isNotEmpty == true
                            ? followerList
                            : [''])
                        : (followingList?.isNotEmpty == true
                            ? followingList
                            : ['']),
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SpinKitWaveSpinner(
                    size: 80,
                    color: Colors.teal,
                  ));
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                    'No   followers.',
                    style: headingStyle,
                  ));
                }
                final documents = snapshot.data!.docs;
                return Column(
                  children: [
                    kbox10,
                    isFollowers
                        ? Text('Followers', style: headingStyle)
                        : Text(
                            'Following',
                            style: headingStyle,
                          ),
                    const Divider(),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          UserData user = UserData.fromSnap(documents[index]);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                                contentPadding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                // visualDensity: const VisualDensity(vertical: -4),
                                leading: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.profileImage!),
                                    // AssetImage('assets/logo/camLogo.png'),
                                    radius: 26,
                                  ),
                                ),
                                title: InkWell(
                                    onTap: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => VisitProfile(
                                              snap: documents[index]),
                                        )),
                                    child: Text(user.userName!)),
                                trailing: isFollowers
                                    ? ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Followers'))
                                    : ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Following'))),
                          );
                        })
                  ],
                );
              }),
        ),
      )),
    );
  }
}
