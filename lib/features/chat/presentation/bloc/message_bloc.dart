import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  StreamSubscription? _messagesSubscription;

  MessageBloc({
    required this.getMessages,
    required this.sendMessage,
  }) : super(MessageInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    await _messagesSubscription?.cancel();
    _messagesSubscription = getMessages(
      GetMessagesParams(conversationId: event.conversationId),
    ).listen(
      (messages) {
        emit(MessagesLoaded(messages));
      },
      onError: (error) {
        emit(MessageError(error.toString()));
      },
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    final result = await sendMessage(
      SendMessageParams(
        conversationId: event.conversationId,
        senderId: event.senderId,
        text: event.text,
      ),
    );

    result.fold(
      (failure) => emit(MessageError(failure.message)),
      (_) {
        // Message sent successfully, state will be updated by stream
      },
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
