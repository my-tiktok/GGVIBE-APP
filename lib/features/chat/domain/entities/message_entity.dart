import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, conversationId, senderId, text, timestamp];
}
