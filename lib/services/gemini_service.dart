import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';
import 'ai_service_interface.dart';

class GeminiService implements AIService {
  final String apiKey;
  final String model;
  final double temperature;
  final int maxTokens;
  final List<Map<String, String>> _conversationHistory = [];

  GeminiService({
    required this.apiKey,
    this.model = 'gemini-pro',
    this.temperature = 0.7,
    this.maxTokens = 2048,
  });

  String get _baseUrl => 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey';

  String get _streamUrl => 'https://generativelanguage.googleapis.com/v1beta/models/$model:streamGenerateContent?key=$apiKey';

  @override
  Future<String> sendMessage({
    required String message,
    List<ChatMessage> conversationHistory = const [],
    Map<String, dynamic>? options,
  }) async {
    final contents = _prepareContents(message, conversationHistory);

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': contents,
        'generationConfig': {
          'temperature': options?['temperature'] ?? temperature,
          'maxOutputTokens': options?['maxTokens'] ?? maxTokens,
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['candidates'][0]['content']['parts'][0]['text'];
      
      _conversationHistory.add({'role': 'user', 'content': message});
      _conversationHistory.add({'role': 'model', 'content': content});
      
      return content;
    } else {
      throw Exception('Gemini API error: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Stream<String> sendMessageStream({
    required String message,
    List<ChatMessage> conversationHistory = const [],
    Map<String, dynamic>? options,
  }) async* {
    final contents = _prepareContents(message, conversationHistory);

    final request = http.Request('POST', Uri.parse(_streamUrl));
    request.headers.addAll({'Content-Type': 'application/json'});
    request.body = jsonEncode({
      'contents': contents,
      'generationConfig': {
        'temperature': options?['temperature'] ?? temperature,
        'maxOutputTokens': options?['maxTokens'] ?? maxTokens,
      },
    });

    final response = await request.send();
    final stream = response.stream.transform(utf8.decoder);

    String fullResponse = '';
    await for (var chunk in stream) {
      final lines = chunk.split('\n');
      for (var line in lines) {
        if (line.isNotEmpty && line.trim().isNotEmpty) {
          try {
            final data = jsonDecode(line);
            final content = data['candidates'][0]['content']['parts'][0]['text'];
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
    _conversationHistory.add({'role': 'model', 'content': fullResponse});
  }

  List<Map<String, dynamic>> _prepareContents(
    String message,
    List<ChatMessage> conversationHistory,
  ) {
    final contents = <Map<String, dynamic>>[];

    // Add conversation history
    for (var msg in conversationHistory) {
      if (msg.role == MessageRole.user) {
        contents.add({
          'role': 'user',
          'parts': [{'text': msg.content}]
        });
      } else if (msg.role == MessageRole.assistant) {
        contents.add({
          'role': 'model',
          'parts': [{'text': msg.content}]
        });
      }
    }

    // Add current message
    contents.add({
      'role': 'user',
      'parts': [{'text': message}]
    });

    return contents;
  }

  @override
  Future<void> clearContext() async {
    _conversationHistory.clear();
  }

  @override
  Future<bool> isAvailable() async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [{'text': 'test'}]
            }
          ],
          'generationConfig': {'maxOutputTokens': 5},
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