import 'package:equatable/equatable.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Stream<List<MessageEntity>> call(GetMessagesParams params) {
    return repository.getMessages(params.conversationId);
  }
}

class GetMessagesParams extends Equatable {
  final String conversationId;

  const GetMessagesParams({required this.conversationId});

  @override
  List<Object> get props => [conversationId];
}
