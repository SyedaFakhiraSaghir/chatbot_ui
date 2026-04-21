import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/chat_user.dart';
import '../models/chat_theme.dart';
import 'chat_message_list.dart';
import 'chat_input_bar.dart';

class ChatUI extends StatefulWidget {
  final ChatProvider chatProvider;
  final ChatUser? user;
  final ChatUser? assistant;
  final ChatTheme? theme;
  final Widget? header;
  final bool showHeader;
  final String? title;
  final List<Widget>? actions;

  const ChatUI({
    super.key,
    required this.chatProvider,
    this.user,
    this.assistant,
    this.theme,
    this.header,
    this.showHeader = true,
    this.title,
    this.actions,
  });

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  late ScrollController _scrollController;
  late ChatTheme _theme;
  late ChatUser _user;
  late ChatUser _assistant;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _theme = widget.theme ?? ChatTheme.light();
    _user = widget.user ?? ChatUser.user;
    _assistant = widget.assistant ?? ChatUser.assistant;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.chatProvider,
      child: Scaffold(
        backgroundColor: _theme.backgroundColor,
        appBar: widget.showHeader
            ? AppBar(
                title: Text(widget.title ?? _assistant.name),
                backgroundColor: _theme.primaryColor,
                actions: widget.actions ?? [
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _showClearDialog();
                    },
                  ),
                ],
              )
            : null,
        body: Column(
          children: [
            if (widget.header != null) widget.header!,
            ChatMessageList(
              messages: widget.chatProvider.messages,
              isTyping: widget.chatProvider.isTyping,
              user: _user,
              assistant: _assistant,
              theme: _theme,
              scrollController: _scrollController,
            ),
            if (widget.chatProvider.error != null)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.chatProvider.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () => widget.chatProvider.retryLastMessage(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ChatInputBar(
              onSend: (message) => widget.chatProvider.sendMessage(message),
              theme: _theme,
              isLoading: widget.chatProvider.isTyping,
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Conversation'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.chatProvider.clearMessages();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}