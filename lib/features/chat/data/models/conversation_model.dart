import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.participantIds,
    super.lastMessage,
    super.lastMessageTime,
  });

  factory ConversationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConversationModel(
      id: doc.id,
      participantIds: List<String>.from(data['participantIds'] ?? []),
      lastMessage: data['lastMessage'],
      lastMessageTime: data['lastMessageTime'] != null
          ? (data['lastMessageTime'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'participantIds': participantIds,
      'lastMessage': lastMessage,
      'lastMessageTime':
          lastMessageTime != null ? Timestamp.fromDate(lastMessageTime!) : null,
    };
  }
}
