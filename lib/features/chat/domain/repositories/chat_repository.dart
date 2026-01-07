import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/conversation_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<ConversationEntity>> getConversations(String userId);
  Stream<List<MessageEntity>> getMessages(String conversationId);
  Future<Either<Failure, void>> sendMessage(
    String conversationId,
    String senderId,
    String text,
  );
}
