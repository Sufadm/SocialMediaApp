// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixmania/constants/constants.dart';
import 'package:pixmania/screens/other_screens/posts_inprofile.dart';
import 'package:pixmania/services/auth.dart';
import 'package:pixmania/screens/profile_screen/profile_widgets/profile_card.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    super.key,
  });

  AuthServices auth = AuthServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String currentUser = _auth.currentUser!.uid;

    return Container(
      decoration: kboxDecoration,
      child: Column(
        children: [
          const ProfileCard(),
          kbox10,
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: currentUser)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error:${snapshot.error.toString()}'));
                  } else {
                    final documents = snapshot.data!.docs;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ViewPost(snap: documents[index]),
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          documents[index].data()['postUrl']))),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
