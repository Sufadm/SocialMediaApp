// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:pixmania/models/usermodel.dart';
import 'package:pixmania/providers/userprovider.dart';
import 'package:pixmania/services/chat_services.dart';
import 'package:pixmania/screens/chat_screen/chat_widget/chat_bubble.dart';
import 'package:provider/provider.dart';

class Chats extends StatelessWidget {
  Chats(
      {super.key,
      required this.recieverId,
      required this.userName,
      required this.profileImage});
  TextEditingController chatController = TextEditingController();
  String recieverId;
  String userName;
  String profileImage;

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(userName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(profileImage),
            ),
          ),
        ],
      ),
      body: Container(
        // decoration: kboxDecoration,
        decoration: const BoxDecoration(color: Colors.white70),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('chats')
                .doc(recieverId)
                .collection('messages')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitWaveSpinner(
                    size: 80,
                    color: Colors.teal,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error:${snapshot.error.toString()}'),
                );
              } else {
                final documents = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final chatData = documents[index];
                    bool isUserMessage = chatData['receiver'] != user.uid;
                    String formattedTime =
                        DateFormat('hh:mm a').format(chatData['time'].toDate());

                    return ChatBubble(
                        message: chatData['message'],
                        time: formattedTime,
                        isUsersMessage: isUserMessage);
                  },
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: // text input
          SafeArea(
        child: Container(
          color: Colors.white,
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: chatController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message ',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                child: const Row(
                  children: [Icon(Icons.send)],
                ),
                onTap: () async {
                  if (chatController.text.isNotEmpty) {
                    await ChatService()
                        .sendMessage(user.uid, recieverId, chatController.text);
                    chatController.text = '';
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
