import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id;
  final List<String> participantIds;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  const ConversationEntity({
    required this.id,
    required this.participantIds,
    this.lastMessage,
    this.lastMessageTime,
  });

  @override
  List<Object?> get props => [id, participantIds, lastMessage, lastMessageTime];
}
