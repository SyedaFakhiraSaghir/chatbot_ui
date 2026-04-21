name: chatbot_ui
description: A customizable Flutter chat UI package with easy integration for local or API-based AI chatbots.
version: 1.0.0
homepage: https://github.com/yourusername/chatbot_ui
repository: https://github.com/yourusername/chatbot_ui
issue_tracker: https://github.com/yourusername/chatbot_ui/issues
documentation: https://github.com/yourusername/chatbot_ui/blob/main/README.md

// Step 1: Choose your AI provider
final aiService = LocalAIService(); // or OpenAIService, GroqService, GeminiService

// Step 2: Add the floating chat bubble to your app
FloatingChatBubble(
  service: aiService,
  title: 'Chat Support',
  bubbleColor: Colors.blue,
)

// That's it! Your users get a beautiful chat interface

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.0.0'

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  intl: ^0.18.1
  http: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true

topics:
  - chat
  - ui
  - ai
  - chatbot
  - messaging