import 'package:flutter/material.dart';

class ChatUser {
  final String id;
  final String name;
  final String? avatarUrl;
  final Widget? avatarWidget;
  final Color? color;

  const ChatUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.avatarWidget,
    this.color,
  });

  static const ChatUser assistant = ChatUser(
    id: 'assistant',
    name: 'AI Assistant',
    color: Colors.blue,
  );

  static const ChatUser user = ChatUser(
    id: 'user',
    name: 'You',
    color: Colors.green,
  );
}