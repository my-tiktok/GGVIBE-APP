import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/message_bloc.dart';
import '../bloc/message_event.dart';
import '../bloc/message_state.dart';
import '../widgets/message_input_widget.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;

  const ChatPage({
    super.key,
    required this.conversationId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MessageBloc>().add(LoadMessagesEvent(widget.conversationId));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final currentUserId =
        authState is Authenticated ? authState.user.uid : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<MessageBloc, MessageState>(
              listener: (context, state) {
                if (state is MessagesLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                } else if (state is MessageError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is MessageLoading || state is MessageInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessagesLoaded) {
                  if (state.messages.isEmpty) {
                    return const Center(
                      child: Text('No messages yet. Start the conversation!'),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isMe = message.senderId == currentUserId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat.Hm().format(message.timestamp),
                                style: TextStyle(
                                  color: isMe
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is MessageError) {
                  return Center(
                    child: Text('Error: ${state.message}'),
                  );
                }
                return const Center(child: Text('Something went wrong'));
              },
            ),
          ),
          MessageInputWidget(
            conversationId: widget.conversationId,
            senderId: currentUserId,
          ),
        ],
      ),
    );
  }
}
