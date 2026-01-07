import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessagesEvent extends MessageEvent {
  final String conversationId;

  const LoadMessagesEvent(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class SendMessageEvent extends MessageEvent {
  final String conversationId;
  final String senderId;
  final String text;

  const SendMessageEvent({
    required this.conversationId,
    required this.senderId,
    required this.text,
  });

  @override
  List<Object> get props => [conversationId, senderId, text];
}
