// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pixmania/constants/constants.dart';
import 'package:pixmania/providers/userprovider.dart';
import 'package:pixmania/screens/chat_screen/chats.dart';
import 'package:pixmania/screens/other_screens/posts_inprofile.dart';
import 'package:pixmania/services/firestore.dart';
import 'package:pixmania/models/usermodel.dart';
import 'package:provider/provider.dart';

class VisitProfile extends StatelessWidget {
  VisitProfile({super.key, required this.snap});
  final snap;
  bool isfollowing = false;

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserProvider>(context).getUser;
    ValueNotifier followNotify = ValueNotifier(userData.following);
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: kboxDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snap['uid'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SpinKitWaveSpinner(
                    size: 80,
                    color: Colors.teal,
                  ));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error.toString()}'),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No data found'));
                } else {
                  final user = snapshot.data!.data();
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.white70,
                    ),
                    margin: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        kbox10,
                        //   const BackButton(),
                        Row(
                          children: [
                            Stack(
                              children: [
                                Positioned(
                                  top: -5,
                                  left: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back_ios),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 10, right: 10),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 46.5,
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundImage:
                                          NetworkImage(user!['profileImage']),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  user['userName'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(user['bio']),
                              ],
                            ),
                            const Expanded(child: SizedBox(width: 5)),
                            userData.uid == snap['uid']
                                ? const SizedBox()
                                : ElevatedButton(
                                    style: const ButtonStyle(),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => Chats(
                                            recieverId: snap['uid'],
                                            userName: snap['userName'],
                                            profileImage: user['profileImage']),
                                      ));
                                    },
                                    child: const Text('Message'),
                                  ),
                            const SizedBox(width: 10)
                          ],
                        ),
                        kbox10,
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(user['followers'].length.toString()),
                                  const Text(
                                    'Followers',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              const VerticalDivider(
                                thickness: 2,
                                color: Colors.grey,
                                width: 2,
                              ),
                              Column(
                                children: [
                                  Text(user['following'].length.toString()),
                                  const Text(
                                    'Following',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: followNotify,
                          builder: (context, value, child) {
                            if (followNotify.value.contains(snap['uid'])) {
                              return ElevatedButton(
                                onPressed: () {
                                  AwesomeDialog(
                                    dialogBackgroundColor: scafoldBg,
                                    context: context,
                                    dialogType: DialogType
                                        .warning, // Change it as per your requirements
                                    animType: AnimType.scale,
                                    title: 'Unfollow this profile?',
                                    desc: 'Press ok to unfollow',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () async {
                                      await FireStore()
                                          .unFollow(userData.uid, snap['uid']);
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .refreshUser();
                                    },
                                  ).show();
                                },
                                child: const Text('Following'),
                              );
                            } else {
                              return ElevatedButton(
                                onPressed: () async {
                                  await FireStore()
                                      .follow(userData.uid, snap['uid']);
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .refreshUser();
                                },
                                child: const Text('Follow'),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: snap['uid'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: SpinKitWaveSpinner(
                        size: 80,
                        color: Colors.teal,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error:${snapshot.error.toString()}'));
                    } else {
                      final documents = snapshot.data!.docs;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
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
                                        image: NetworkImage(documents[index]
                                            .data()['postUrl']))),
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
      )),
    );
  }
}
