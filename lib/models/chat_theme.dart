import 'package:flutter/material.dart';

class ChatTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color userBubbleColor;
  final Color assistantBubbleColor;
  final Color errorBubbleColor;
  final Color textColor;
  final Color inputBackgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry bubblePadding;
  final EdgeInsetsGeometry messageListPadding;
  final TextStyle? userTextStyle;
  final TextStyle? assistantTextStyle;
  final TextStyle? errorTextStyle;
  final TextStyle? inputTextStyle;
  final int inputMaxLines; // Changed from double to int
  final Widget? sendButtonIcon;
  final bool showAvatars;
  final bool showTimestamps;

  const ChatTheme({
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.userBubbleColor = Colors.blue,
    this.assistantBubbleColor = Colors.grey,
    this.errorBubbleColor = Colors.red,
    this.textColor = Colors.white,
    this.inputBackgroundColor = Colors.white,
    this.borderRadius = 12.0,
    this.bubblePadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.messageListPadding = const EdgeInsets.all(16),
    this.userTextStyle,
    this.assistantTextStyle,
    this.errorTextStyle,
    this.inputTextStyle,
    this.inputMaxLines = 5, // Changed to int
    this.sendButtonIcon,
    this.showAvatars = true,
    this.showTimestamps = true,
  });

  static ChatTheme light() => const ChatTheme();

  static ChatTheme dark() => ChatTheme(
        backgroundColor: Colors.grey[900]!,
        userBubbleColor: Colors.blue[700]!,
        assistantBubbleColor: Colors.grey[800]!,
        inputBackgroundColor: Colors.grey[800]!,
        textColor: Colors.white,
      );
}