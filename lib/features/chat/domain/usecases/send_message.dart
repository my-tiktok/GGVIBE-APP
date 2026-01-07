import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class SendMessage implements UseCase<void, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      params.conversationId,
      params.senderId,
      params.text,
    );
  }
}

class SendMessageParams extends Equatable {
  final String conversationId;
  final String senderId;
  final String text;

  const SendMessageParams({
    required this.conversationId,
    required this.senderId,
    required this.text,
  });

  @override
  List<Object> get props => [conversationId, senderId, text];
}
