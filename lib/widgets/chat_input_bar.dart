import 'package:flutter/material.dart';
import '../models/chat_theme.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String) onSend;
  final ChatTheme theme;
  final bool isLoading;
  final TextEditingController? controller;
  final String hintText;

  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.theme,
    this.isLoading = false,
    this.controller,
    this.hintText = 'Type a message...',
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isLoading) {
      widget.onSend(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.theme.inputBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: null,
                  minLines: 1,
                  maxLength: widget.theme.inputMaxLines as int?, // Fix: Cast to int?
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: widget.theme.backgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    counterText: '', // Hide the counter
                  ),
                  style: widget.theme.inputTextStyle,
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
              const SizedBox(width: 8),
              if (widget.isLoading)
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )
              else
                IconButton(
                  onPressed: _handleSend,
                  icon: widget.theme.sendButtonIcon ??
                      Icon(
                        Icons.send,
                        color: widget.theme.primaryColor,
                      ),
                  style: IconButton.styleFrom(
                    backgroundColor: widget.theme.primaryColor.withValues(alpha: 0.1),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}