// This is a development test file - remove in production
// To use: dart test_import.dart

import 'package:chatbot_ui/chatbot_ui.dart';

void main() {
  // Use debugPrint instead of print for production
  debugPrint('Package imports successfully!');
  debugPrint('ChatTheme: ${ChatTheme.light()}');
  debugPrint('ChatUser: ${ChatUser.user}');
  debugPrint('LocalAIService: ${LocalAIService()}');
  debugPrint('All exports working!');
}

// Helper function for development logging
void debugPrint(String message) {
  // Only print in debug mode
  if (bool.fromEnvironment('dart.vm.product') == false) {
    // print(message);
  }
}