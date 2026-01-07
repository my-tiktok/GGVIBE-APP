import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_conversations.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetConversations getConversations;
  StreamSubscription? _conversationsSubscription;

  ChatBloc({required this.getConversations}) : super(ChatInitial()) {
    on<LoadConversationsEvent>(_onLoadConversations);
  }

  Future<void> _onLoadConversations(
    LoadConversationsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    await _conversationsSubscription?.cancel();
    _conversationsSubscription = getConversations(
      GetConversationsParams(userId: event.userId),
    ).listen(
      (conversations) {
        emit(ConversationsLoaded(conversations));
      },
      onError: (error) {
        emit(ChatError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _conversationsSubscription?.cancel();
    return super.close();
  }
}
