import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/ai_service_interface.dart';

class ChatProvider extends ChangeNotifier {
  final AIService _aiService;
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String? _error;
  StreamSubscription? _streamSubscription;

  ChatProvider(this._aiService);

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;
  String? get error => _error;

  void sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage.user(content: content);
    _messages.add(userMessage);
    _error = null;
    notifyListeners();

    // Add typing indicator
    _isTyping = true;
    notifyListeners();

    // Add placeholder for assistant message
    final assistantMessage = ChatMessage.assistant(content: '', isStreaming: true);
    _messages.add(assistantMessage);
    notifyListeners();

    try {
      // Start streaming response
      final stream = _aiService.sendMessageStream(
        message: content,
        conversationHistory: _messages.where((m) => m.role != MessageRole.error).toList(),
      );

      _streamSubscription = stream.listen(
        (chunk) {
          // Update the last message with new chunk
          final lastIndex = _messages.length - 1;
          final updatedMessage = _messages[lastIndex].copyWith(
            content: _messages[lastIndex].content + chunk,
          );
          _messages[lastIndex] = updatedMessage;
          notifyListeners();
        },
        onError: (error) {
          _handleError(error.toString());
        },
        onDone: () {
          // Mark streaming as complete
          final lastIndex = _messages.length - 1;
          _messages[lastIndex] = _messages[lastIndex].copyWith(isStreaming: false);
          _isTyping = false;
          _streamSubscription = null;
          notifyListeners();
        },
      );
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String errorMessage) {
    _isTyping = false;
    _error = errorMessage;
    
    // Remove the streaming assistant message
    if (_messages.isNotEmpty && _messages.last.isStreaming) {
      _messages.removeLast();
    }
    
    // Add error message
    _messages.add(ChatMessage.error(content: errorMessage));
    notifyListeners();
    
    // Clear error after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (_error == errorMessage) {
        _error = null;
        notifyListeners();
      }
    });
  }

  void clearMessages() {
    _messages.clear();
    _error = null;
    _aiService.clearContext();
    notifyListeners();
  }

  void retryLastMessage() {
    if (_messages.isNotEmpty) {
      final lastUserMessage = _messages.lastWhere(
        (m) => m.role == MessageRole.user,
        orElse: () => throw Exception('No user message found'),
      );
      sendMessage(lastUserMessage.content);
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}