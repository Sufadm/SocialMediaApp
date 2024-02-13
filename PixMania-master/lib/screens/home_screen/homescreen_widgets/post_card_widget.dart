// ignore_for_file: use_build_context_synchronously, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixmania/constants/constants.dart';
import 'package:pixmania/providers/userprovider.dart';
import 'package:pixmania/screens/other_screens/comment_screen.dart';
import 'package:pixmania/screens/other_screens/visit_profile.dart';
import 'package:pixmania/services/firestore.dart';
import 'package:pixmania/models/usermodel.dart';
import 'package:pixmania/utils/utils.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  PostCard({super.key, this.postImage, required this.snap});
  String? postImage;
  bool isLiked = false;
  final snap;
  @override
  Widget build(BuildContext context) {
    // timePosted = DateFormat('yyyy-MM-dd').format(snap['dateTime']);
    UserData user = Provider.of<UserProvider>(context).getUser;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black87,
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(snap['profileImage']),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Text(
                    snap['userName'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onTap: () {
                    if (snap['uid'] == user.uid) {
                      showSnackBar(context, 'Visit your profile...');
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => VisitProfile(
                          snap: snap,
                        ),
                      ));
                    }
                  },
                ),
                Text(
                  DateFormat.yMMMd().format(snap['dateTime'].toDate()),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            )
          ],
        ),
        GestureDetector(
          onDoubleTap: () {
            FireStore().likePost(snap['postId'], user.uid, snap['likes']);
          },
          child: Container(
            decoration: const BoxDecoration(),
            child: InteractiveViewer(
                child: Image(image: NetworkImage(snap['postUrl']))),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                FireStore().likePost(snap['postId'], user.uid, snap['likes']);
              },
              icon: AnimatedSwitcher(
                duration: const Duration(seconds: 2),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: snap['likes'].contains(user.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.pink,
                        size: 24, // adjust the size as needed
                      )
                    : const Icon(
                        Icons.favorite_border,
                        size: 24, // adjust the size as needed
                      ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      snap: snap,
                    ),
                  ));
                },
                icon: const Icon(Icons.chat_outlined)),
            user.uid == snap['uid']
                ? IconButton(
                    onPressed: () async {
                      AwesomeDialog(
                        dialogBackgroundColor: scafoldBg,
                        context: context,
                        dialogType: DialogType
                            .warning, // Change it as per your requirements
                        animType: AnimType.scale,
                        title: 'Delete post?',
                        desc: 'The post will be deleted',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          await FireStore()
                              .deletePost(snap['postId'], snap['postUrl']);
                          showSnackBar(context, 'Post Deleted!');
                        },
                      ).show();
                    },
                    icon: const Icon(
                      Icons.delete_sweep_outlined,
                      // size: 26,
                    ))
                : const SizedBox()
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 15,
            ),
            Text('${snap['likes'].length} Likes'),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(
            width: 15,
          ),
          Text(snap['userName'],
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(
            width: 5,
          ),
          Text(snap['description'],
              style: const TextStyle(color: Colors.black87))
        ]),
        // kbox10,
        Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CommentScreen(
                    snap: snap,
                  ),
                ));
              },
              child: const SizedBox(
                child: Text(
                  'View comments',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
        kbox10,
        const Divider(
          thickness: 2,
          height: 0,
        )
      ],
    );
  }
}
