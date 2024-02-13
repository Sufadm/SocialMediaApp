// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble(
      {super.key,
      required this.message,
      required this.time,
      required this.isUsersMessage});

  String message;
  String time;
  bool isUsersMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment:
            isUsersMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isUsersMessage
                  ? const Color.fromARGB(255, 181, 243, 238)
                  : const Color.fromARGB(255, 160, 223, 158),
            ),
            child: Column(
              crossAxisAlignment: isUsersMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: isUsersMessage ? Colors.black : Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: isUsersMessage
                        ? Colors.black.withOpacity(0.8)
                        : Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
