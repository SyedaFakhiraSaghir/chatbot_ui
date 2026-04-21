import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/chat_user.dart';
import '../models/chat_theme.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final ChatUser user;
  final ChatUser assistant;
  final ChatTheme theme;


    const ChatBubble({
    super.key,
    required this.message,
    required this.user,
    required this.assistant,
    required this.theme,
    });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final isError = message.role == MessageRole.error;
    
    Color bubbleColor;
    TextStyle textStyle;
    
    if (isError) {
      bubbleColor = theme.errorBubbleColor;
      textStyle = theme.errorTextStyle ?? const TextStyle(color: Colors.white);
    } else if (isUser) {
      bubbleColor = theme.userBubbleColor;
      textStyle = theme.userTextStyle ?? const TextStyle(color: Colors.white);
    } else {
      bubbleColor = theme.assistantBubbleColor;
      textStyle = theme.assistantTextStyle ?? const TextStyle(color: Colors.black);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser && theme.showAvatars)
            _buildAvatar(assistant),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  padding: theme.bubblePadding,
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(theme.borderRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.content,
                        style: textStyle,
                      ),
                      if (message.isStreaming)
                        const SizedBox(
                          width: 20,
                          height: 10,
                          child: LinearProgressIndicator(),
                        ),
                    ],
                  ),
                ),
                if (theme.showTimestamps)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isUser && theme.showAvatars)
            _buildAvatar(user),
        ],
      ),
    );
  }

  Widget _buildAvatar(ChatUser user) {
    if (user.avatarWidget != null) {
      return user.avatarWidget!;
    }
    
    if (user.avatarUrl != null) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(user.avatarUrl!),
      );
    }
    
    return CircleAvatar(
      radius: 16,
      backgroundColor: user.color ?? theme.primaryColor,
      child: Text(
        user.name[0].toUpperCase(),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays > 0) {
      return '${time.month}/${time.day} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}