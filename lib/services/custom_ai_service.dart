// lib/services/custom_ai_service.dart
import 'dart:async';
import '../models/chat_message.dart';
import 'ai_service_interface.dart';

/// Example template for creating custom AI services
class CustomAIService implements AIService {
  final String apiEndpoint;
  final Map<String, String>? headers;
  
  CustomAIService({
    required this.apiEndpoint,
    this.headers,
  });

  @override
  Future<String> sendMessage({
    required String message,
    List<ChatMessage> conversationHistory = const [],
    Map<String, dynamic>? options,
  }) async {
    // Implement your custom API call here
    await Future.delayed(const Duration(milliseconds: 500));
    return "Custom AI response to: $message";
  }

  @override
  Stream<String> sendMessageStream({
    required String message,
    List<ChatMessage> conversationHistory = const [],
    Map<String, dynamic>? options,
  }) async* {
    // Implement streaming response
    final response = "Custom streaming response to: $message";
    final words = response.split(' ');
    for (var word in words) {
      yield word + (word != words.last ? ' ' : '');
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  @override
  Future<void> clearContext() async {
    // Clear conversation context
  }

  @override
  Future<bool> isAvailable() async {
    // Check if service is available
    return true;
  }

  @override
  void setOptions(Map<String, dynamic> options) {
    // Set custom options
  }
}