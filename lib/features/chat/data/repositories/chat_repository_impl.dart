import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<ConversationEntity>> getConversations(String userId) {
    return remoteDataSource.getConversations(userId);
  }

  @override
  Stream<List<MessageEntity>> getMessages(String conversationId) {
    return remoteDataSource.getMessages(conversationId);
  }

  @override
  Future<Either<Failure, void>> sendMessage(
    String conversationId,
    String senderId,
    String text,
  ) async {
    try {
      await remoteDataSource.sendMessage(conversationId, senderId, text);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
