import 'package:equatable/equatable.dart';
import '../../domain/entities/conversation_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ConversationsLoaded extends ChatState {
  final List<ConversationEntity> conversations;

  const ConversationsLoaded(this.conversations);

  @override
  List<Object> get props => [conversations];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}
