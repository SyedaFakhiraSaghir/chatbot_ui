import 'package:flutter_test/flutter_test.dart';
import 'package:chatbot_ui/chatbot_ui.dart';

void main() {
  test('Package exports correctly', () {
    // Just testing that the package exports without errors
    expect(ChatTheme.light(), isNotNull);
    expect(ChatUser.user, isNotNull);
    expect(ChatUser.assistant, isNotNull);
  });
}