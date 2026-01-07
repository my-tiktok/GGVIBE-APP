import 'package:equatable/equatable.dart';
import '../entities/conversation_entity.dart';
import '../repositories/chat_repository.dart';

class GetConversations {
  final ChatRepository repository;

  GetConversations(this.repository);

  Stream<List<ConversationEntity>> call(GetConversationsParams params) {
    return repository.getConversations(params.userId);
  }
}

class GetConversationsParams extends Equatable {
  final String userId;

  const GetConversationsParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
