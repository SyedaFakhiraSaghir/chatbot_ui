import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/chat_user.dart';
import '../models/chat_theme.dart';
import 'chat_bubble.dart';
import 'typing_indicator.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isTyping;
  final ChatUser user;
  final ChatUser assistant;
  final ChatTheme theme;
  final ScrollController? scrollController;

  const ChatMessageList({
  super.key,
  required this.messages,
  required this.isTyping,
  required this.user,
  required this.assistant,
  required this.theme,
  this.scrollController,    
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        padding: theme.messageListPadding,
        reverse: true,
        itemCount: messages.length + (isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == messages.length && isTyping) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  if (theme.showAvatars)
                    _buildTypingAvatar(),
                  const TypingIndicator(),
                ],
              ),
            );
          }
          
          final message = messages.reversed.toList()[index];
          return ChatBubble(
            message: message,
            user: user,
            assistant: assistant,
            theme: theme,
          );
        },
      ),
    );
  }

  Widget _buildTypingAvatar() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: assistant.color ?? theme.primaryColor,
        child: Text(
          assistant.name[0].toUpperCase(),
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}