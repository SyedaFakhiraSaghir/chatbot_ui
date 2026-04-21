import 'dart:async';
import '../models/chat_message.dart';

abstract class AIService {
  /// Send a message and get a complete response
  Future<String> sendMessage({
    required String message,
    List<ChatMessage> conversationHistory,
    Map<String, dynamic>? options,
  });

  /// Send a message and get a streaming response
  Stream<String> sendMessageStream({
    required String message,
    List<ChatMessage> conversationHistory,
    Map<String, dynamic>? options,
  });

  /// Clear conversation context
  Future<void> clearContext();

  /// Check if service is available
  Future<bool> isAvailable();

  /// Set custom options
  void setOptions(Map<String, dynamic> options);
}