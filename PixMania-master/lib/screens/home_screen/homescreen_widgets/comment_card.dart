// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixmania/constants/constants.dart';
import 'package:pixmania/providers/userprovider.dart';
import 'package:pixmania/services/firestore.dart';
import 'package:pixmania/models/usermodel.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.snap});
  final snap;
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserProvider>(context).getUser;
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(left: 15),
          visualDensity: const VisualDensity(vertical: -4),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(snap['profilePic']),
            radius: 22,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(DateFormat.yMMMd().format(snap['timeofComment'].toDate())),
              snap['uid'] == user.uid
                  ? IconButton(
                      padding: const EdgeInsets.only(right: 0),
                      onPressed: () {
                        AwesomeDialog(
                          dialogBackgroundColor: scafoldBg,
                          context: context,
                          dialogType: DialogType
                              .warning, // Change it as per your requirements
                          animType: AnimType.scale,
                          title: 'Delete comment?',
                          desc: 'The comment will be deleted',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            FireStore().deleteComment(
                                snap['postId'], snap['commentId']);
                          },
                        ).show();
                      },
                      icon: const Icon(Icons.more_vert))
                  : const SizedBox(
                      width: 0,
                    )
            ],
          ),
          title: Text(
            snap['name'],
            style: const TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            snap['comment'],
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
