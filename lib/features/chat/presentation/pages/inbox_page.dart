import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'chat_page.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<ChatBloc>().add(LoadConversationsEvent(authState.user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GGVIBE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading || state is ChatInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ConversationsLoaded) {
              if (state.conversations.isEmpty) {
                return const Center(
                  child: Text(
                    'No conversations yet',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.conversations.length,
                itemBuilder: (context, index) {
                  final conversation = state.conversations[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      conversation.participantIds
                          .where((id) {
                            final authState = context.read<AuthBloc>().state;
                            return authState is Authenticated && id != authState.user.uid;
                          })
                          .join(', '),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      conversation.lastMessage ?? 'No messages',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: conversation.lastMessageTime != null
                        ? Text(
                            _formatTime(conversation.lastMessageTime!),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          )
                        : null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatPage(
                            conversationId: conversation.id,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is ChatError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            }
            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      return DateFormat.Hm().format(time);
    } else if (diff.inDays < 7) {
      return DateFormat.E().format(time);
    } else {
      return DateFormat.MMMd().format(time);
    }
  }
}
