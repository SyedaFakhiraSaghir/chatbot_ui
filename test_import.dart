// test_import.dart - Run with: dart test_import.dart
import 'package:chatbot_ui/chatbot_ui.dart';

void main() {
  print('Package imports successfully!');
  print('ChatTheme: ${ChatTheme.light()}');
  print('ChatUser: ${ChatUser.user}');
  print('LocalAIService: ${LocalAIService()}');
  print('All exports working!');
}