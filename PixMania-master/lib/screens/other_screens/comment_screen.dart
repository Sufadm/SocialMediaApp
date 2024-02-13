// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pixmania/providers/userprovider.dart';
import 'package:pixmania/services/firestore.dart';
import 'package:pixmania/models/usermodel.dart';
import 'package:pixmania/utils/utils.dart';
import 'package:provider/provider.dart';

import '../home_screen/homescreen_widgets/comment_card.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen({super.key, required this.snap});
  final snap;
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Comments'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(snap['postId'])
            .collection('comments')
            .orderBy('timeofComment', descending: true)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          final documents = snapshot.data!.docs;

          return documents.isEmpty
              ? const Center(
                  child: Text(
                    'No comments',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                )
              : ListView.separated(
                  // padding: const EdgeInsets.all(0),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: documents.length,
                  itemBuilder: (context, index) => CommentCard(
                        snap: documents[index],
                      ));
        },
      ),

      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.profileImage!),
                radius: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.userName}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: InkWell(
                  child: const Row(
                    children: [Icon(Icons.send)],
                  ),
                  onTap: () async {
                    await FireStore().commentPost(
                        user.userName!,
                        commentController.text,
                        user.uid,
                        user.profileImage!,
                        snap['postId']);
                    commentController.clear();
                    showSnackBar(context, 'Comment posted');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
