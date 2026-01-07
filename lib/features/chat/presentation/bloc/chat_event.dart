import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadConversationsEvent extends ChatEvent {
  final String userId;

  const LoadConversationsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
