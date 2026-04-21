import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';
import 'ai_service_interface.dart';

class OpenAIService implements AIService {
  final String apiKey;
  final String model;
  final double temperature;
  final int maxTokens;
  final String baseUrl;
  final List<Map<String, String>> _conversationHistory = [];

  OpenAIService({
    required this.apiKey,
    this.model = 'gpt-3.5-turbo',
    this.temperature = 0.7,
    this.maxTokens = 1000,
    this.baseUrl = 'https://api.openai.com/v1/chat/completions',
  });

  @override
  Future<String> sendMessage({
    required String message,
    List<ChatMessage> conversationHistory = const [],
    Map<String, dynamic>? options,
  }) async {
    final messages = _prepareMessages(message, conversationHistory);

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'temperature': options?['temperature'] ?? temperature,
        'max_tokens': options?['maxTokens'] ?? maxTokens,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      
      _conversationHistory.add({'role': 'user', 'content': message});
      _conversationHistory.add({'role': 'assistant', 'content': content});
      
      return content;
    } else {
      throw Exception('OpenAI API error: ${response.statusCode}');
    }
  }

  @override
  Stream<String> sendMessageStream({
    required String message,
    List<ChatMessage> conversationHistory = const [],
    Map<String, dynamic>? options,
  }) async* {
    final messages = _prepareMessages(message, conversationHistory);

    final request = http.Request('POST', Uri.parse(baseUrl));
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    });
    request.body = jsonEncode({
      'model': model,
      'messages': messages,
      'temperature': options?['temperature'] ?? temperature,
      'max_tokens': options?['maxTokens'] ?? maxTokens,
      'stream': true,
    });

    final response = await request.send();
    final stream = response.stream.transform(utf8.decoder);

    String fullResponse = '';
    await for (var chunk in stream) {
      final lines = chunk.split('\n');
      for (var line in lines) {
        if (line.startsWith('data: ') && line != 'data: [DONE]') {
          try {
            final data = jsonDecode(line.substring(6));
            final content = data['choices'][0]['delta']['content'];
            if (content != null) {
              fullResponse += content;
              yield content;
            }
          } catch (e) {
            // Skip invalid JSON
          }
        }
      }
    }

    _conversationHistory.add({'role': 'user', 'content': message});
    _conversationHistory.add({'role': 'assistant', 'content': fullResponse});
  }

  List<Map<String, String>> _prepareMessages(
    String message,
    List<ChatMessage> conversationHistory,
  ) {
    final messages = <Map<String, String>>[];

    for (var msg in conversationHistory) {
      if (msg.role == MessageRole.user) {
        messages.add({'role': 'user', 'content': msg.content});
      } else if (msg.role == MessageRole.assistant) {
        messages.add({'role': 'assistant', 'content': msg.content});
      }
    }

    messages.addAll(_conversationHistory);
    messages.add({'role': 'user', 'content': message});

    return messages;
  }

  @override
  Future<void> clearContext() async {
    _conversationHistory.clear();
  }

  @override
  Future<bool> isAvailable() async {
    try {
      // Simple test request
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [{'role': 'user', 'content': 'test'}],
          'max_tokens': 5,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  void setOptions(Map<String, dynamic> options) {
    // Implementation for setting options
  }
}