// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/chatmodel.dart';

class ChatService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //send message
  Future<void> sendMessage(
    String senderId,
    String receiverId,
    String message,
  ) async {
    String chatId = const Uuid().v4();

    final chat = ChatModel(
        chatId: chatId,
        message: message,
        time: Timestamp.now(),
        receiver: receiverId);
    final senderInstance =
        _fireStore.collection('users').doc(senderId).collection('chats');
    final receiverInstance =
        _fireStore.collection('users').doc(receiverId).collection('chats');
    try {
      //to set fields in user
      await senderInstance.doc(receiverId).set({
        'receiverId': receiverId,
        'time': Timestamp.now(),
        'lastMessage': message
      });
      await receiverInstance.doc(senderId).set({
        'receiverId': senderId,
        'time': Timestamp.now(),
        'lastMessage': message
      });
      //to save chat
      await senderInstance
          .doc(receiverId)
          .collection('messages')
          .doc(chatId)
          .set(chat.toJson());
      await receiverInstance
          .doc(senderId)
          .collection('messages')
          .doc(chatId)
          .set(chat.toJson());
    } catch (e) {}
  }
}
