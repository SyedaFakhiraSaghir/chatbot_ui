import 'dart:async';
import '../models/chat_message.dart';
import 'ai_service_interface.dart';

/// Example local AI service with rule-based responses
/// You can replace this with actual local ML model integration
class LocalAIService implements AIService {
  final Map<String, String> _responses;
  final List<ChatMessage> _conversationHistory = [];

  LocalAIService({
    Map<String, String>? customResponses,
  }) : _responses = customResponses ?? _defaultResponses();

  static Map<String, String> _defaultResponses() {
    return {
      'hello': 'Hello! How can I help you today?',
      'hi': 'Hi there! What can I do for you?',
      'how are you': "I'm doing great, thank you for asking!",
      'what is your name': "I'm an AI assistant powered by local intelligence.",
      'help': 'I can help answer questions, provide information, or just chat!',
      'bye': 'Goodbye! Feel free to come back if you need anything.',
      'thank': "You're welcome! Happy to help.",
      'how does this work': 'This is a local AI that responds based on keyword matching. You can customize the responses!',
      'default': "I'm still learning. Could you rephrase that?",
    };
  }

  @override
  Future<String> sendMessage({
    required String message,
    List<ChatMessage> conversationHistory = const [],
    Map<String, dynamic>? options,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate processing
    
    final response = _generateResponse(message.toLowerCase());
    _conversationHistory.add(ChatMessage.user(content: message));
    _conversationHistory.add(ChatMessage.assistant(content: response));
    
    return response;
  }

  @override
  Stream<String> sendMessageStream({
    required String message,
    List<ChatMessage> conversationHistory = const [],
    Map<String, dynamic>? options,
  }) async* {
    final response = _generateResponse(message.toLowerCase());
    
    // Simulate streaming by splitting response into words
    final words = response.split(' ');
    for (var word in words) {
      yield word + (word != words.last ? ' ' : '');
      await Future.delayed(const Duration(milliseconds: 50));
    }
    
    _conversationHistory.add(ChatMessage.user(content: message));
    _conversationHistory.add(ChatMessage.assistant(content: response));
  }

  String _generateResponse(String message) {
    for (var entry in _responses.entries) {
      if (message.contains(entry.key)) {
        return entry.value;
      }
    }
    return _responses['default']!;
  }

  @override
  Future<void> clearContext() async {
    _conversationHistory.clear();
  }

  @override
  Future<bool> isAvailable() async {
    return true; // Local service is always available
  }

  @override
  void setOptions(Map<String, dynamic> options) {
    // Implementation for setting options
  }

  void addCustomResponse(String keyword, String response) {
    _responses[keyword.toLowerCase()] = response;
  }
}