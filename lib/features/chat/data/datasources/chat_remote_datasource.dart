import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ConversationModel>> getConversations(String userId);
  Stream<List<MessageModel>> getMessages(String conversationId);
  Future<void> sendMessage(
    String conversationId,
    String senderId,
    String text,
  );
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  @override
  Stream<List<ConversationModel>> getConversations(String userId) {
    return firestore
        .collection('conversations')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ConversationModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Stream<List<MessageModel>> getMessages(String conversationId) {
    return firestore
        .collection('messages')
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Future<void> sendMessage(
    String conversationId,
    String senderId,
    String text,
  ) async {
    try {
      final message = MessageModel(
        id: '',
        conversationId: conversationId,
        senderId: senderId,
        text: text,
        timestamp: DateTime.now(),
      );

      // Add message to messages collection
      await firestore.collection('messages').add(message.toFirestore());

      // Update conversation last message
      await firestore.collection('conversations').doc(conversationId).update({
        'lastMessage': text,
        'lastMessageTime': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }
}
