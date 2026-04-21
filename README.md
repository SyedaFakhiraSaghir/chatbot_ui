Chatbot UI

Chatbot UI is a comprehensive Flutter package that provides a ready-to-use chat interface with seamless integration for multiple AI providers including OpenAI, Groq, Gemini, and local AI services.

<img width="583" height="842" alt="image" src="https://github.com/user-attachments/assets/26d6c9f0-d75f-49fd-b09f-7502f20f0bf7" />
<img width="540" height="843" alt="image" src="https://github.com/user-attachments/assets/4ed4c039-2af6-4490-92f5-6f1a6aed98b2" />
<img width="538" height="858" alt="image" src="https://github.com/user-attachments/assets/86fd29c3-de25-4998-84a8-5dd87a047ec5" />
<img width="539" height="835" alt="image" src="https://github.com/user-attachments/assets/efc3a9d0-3308-468f-b9c6-19d0799800ce" />


Features

🎨 Fully Customizable UI - Themes, colors, bubbles, and animations
🤖 Multiple AI Providers - OpenAI, Groq, Gemini, Local AI
💬 Streaming Responses - Real-time token-by-token responses
📱 Floating Chat Bubble - Non-intrusive chat widget
🚀 Easy Integration - Add chat with just a few lines of code
🔄 Conversation History - Automatic context management
🎯 Type Safety - Full Dart type support
📦 Zero Configuration - Local AI works out of the box
Installation

1. Add Dependency

Add to your pubspec.yaml:

yaml
dependencies:
  chatbot_ui: ^0.1.1
2. Install Package

bash
flutter pub get
3. Import in Your Code

dart
import 'package:chatbot_ui/chatbot_ui.dart';
Quick Start

Minimal Example (3 lines of code)

dart
// 1. Create a service (choose your AI provider)
final service = LocalAIService();

// 2. Create provider
final chatProvider = ChatProvider(service);

// 3. Add the chat UI
ChatUI(
  chatProvider: chatProvider,
  title: 'AI Assistant',
)
Complete Working Example

dart
import 'package:flutter/material.dart';
import 'package:chatbot_ui/chatbot_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ChatUI(
          chatProvider: ChatProvider(LocalAIService()),
          title: 'AI Assistant',
        ),
      ),
    );
  }
}
Floating Chat Bubble (Easiest Integration)

dart
// Step 1: Choose your AI provider
final aiService = LocalAIService(); // or OpenAIService, GroqService, GeminiService

// Step 2: Add the floating chat bubble to your app
FloatingChatBubble(
  service: aiService,
  title: 'Chat Support',
  bubbleColor: Colors.blue,
)

// That's it! Your users get a beautiful chat interface
AI Providers

1. Local AI Service (No API Key Required)

Best for: Testing, offline use, simple rule-based responses

dart
import 'package:chatbot_ui/chatbot_ui.dart';

final service = LocalAIService();

// With custom responses
final customService = LocalAIService(
  customResponses: {
    'hello': 'Hi there! Welcome to my app!',
    'help': 'How can I assist you today?',
    'bye': 'Goodbye! Come back anytime.',
  },
);

// Add custom response dynamically
customService.addCustomResponse('support', 'Our support team is available 24/7');
Default Responses:

"hello" → "Hello! How can I help you today?"
"how are you" → "I'm doing great, thank you for asking!"
"help" → "I can help answer questions, provide information, or just chat!"
"bye" → "Goodbye! Feel free to come back if you need anything."
2. OpenAI Service

Best for: Advanced AI capabilities, GPT models

dart
final service = OpenAIService(
  apiKey: 'your-openai-api-key',
  model: 'gpt-3.5-turbo', // or 'gpt-4'
  temperature: 0.7,
  maxTokens: 1000,
);

// Available models:
// - gpt-3.5-turbo (fast, cost-effective)
// - gpt-4 (more capable, slower)
// - gpt-4-turbo-preview (latest features)
3. Groq Service (Ultra-Fast)

Best for: Speed, LPU acceleration

dart
final service = GroqService(
  apiKey: 'your-groq-api-key',
  model: 'mixtral-8x7b-32768', // or 'llama2-70b-4096', 'gemma-7b-it'
  temperature: 0.7,
  maxTokens: 1024,
);

// Available Groq models:
// - mixtral-8x7b-32768 (best performance)
// - llama2-70b-4096 (high accuracy)
// - gemma-7b-it (fast and efficient)
// - llama3-70b-8192 (latest Llama)
// - llama3-8b-8192 (lightweight)
4. Gemini Service

Best for: Google's AI capabilities

dart
final service = GeminiService(
  apiKey: 'your-gemini-api-key',
  model: 'gemini-pro',
  temperature: 0.7,
  maxTokens: 2048,
);

// Available models:
// - gemini-pro (text-only)
// - gemini-pro-vision (image understanding)
Integration Methods

Method 1: Full Screen Chat

Use case: Dedicated chat page

dart
class MyChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatProvider = ChatProvider(LocalAIService());
    
    return ChatUI(
      chatProvider: chatProvider,
      title: 'Customer Support',
      theme: ChatTheme.light(),
      showHeader: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => chatProvider.clearMessages(),
        ),
      ],
    );
  }
}
Method 2: Floating Chat Bubble

Use case: Chat overlay on any screen

dart
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: Stack(
        children: [
          // Your app content
          YourAppContent(),
          
          // Floating chat bubble
          FloatingChatBubble(
            service: LocalAIService(),
            title: 'AI Support',
            bubbleColor: Colors.blue,
            bubbleIcon: Icons.support_agent,
            showCloseButton: true,
            bubbleSize: 60,
            padding: const EdgeInsets.all(16),
          ),
        ],
      ),
    );
  }
}
Method 3: Embedded Chat

Use case: Chat as part of a larger layout

dart
class EmbeddedChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ChatUI(
            chatProvider: ChatProvider(LocalAIService()),
            title: 'Chat',
            showHeader: false, // Hide header for embedding
          ),
        ),
        // Other widgets below chat
        const BottomNavigationBar(),
      ],
    );
  }
}
Customization

Theme Customization

dart
final customTheme = ChatTheme(
  // Colors
  primaryColor: Colors.purple,
  userBubbleColor: Colors.purple,
  assistantBubbleColor: Colors.grey.shade300,
  errorBubbleColor: Colors.red,
  backgroundColor: Colors.white,
  inputBackgroundColor: Colors.grey.shade100,
  
  // Text styles
  userTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
  assistantTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
  errorTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
  
  // Layout
  borderRadius: 16.0,
  bubblePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  messageListPadding: const EdgeInsets.all(16),
  inputMaxLines: 5,
  
  // Features
  showAvatars: true,
  showTimestamps: true,
  
  // Custom icon
  sendButtonIcon: const Icon(Icons.send_rounded),
);

// Use in ChatUI
ChatUI(
  chatProvider: chatProvider,
  theme: customTheme,
  // ...
)
Pre-built Themes

dart
// Light theme (default)
final lightTheme = ChatTheme.light();

// Dark theme
final darkTheme = ChatTheme.dark();

// Custom theme from light
final customLight = ChatTheme.light().copyWith(
  primaryColor: Colors.green,
  userBubbleColor: Colors.green,
);
Custom User Profiles

dart
// Custom user
final customUser = ChatUser(
  id: 'user_123',
  name: 'John Doe',
  avatarUrl: 'https://example.com/avatar.jpg',
  color: Colors.blue,
);

// Custom assistant
final customAssistant = ChatUser(
  id: 'ai_bot',
  name: 'SmartBot',
  avatarWidget: Image.asset('assets/bot_avatar.png'),
  color: Colors.orange,
);

// Use in ChatUI
ChatUI(
  chatProvider: chatProvider,
  user: customUser,
  assistant: customAssistant,
  // ...
)
API Reference

ChatMessage Class

dart
class ChatMessage {
  final String id;                    // Unique identifier
  final String content;               // Message text
  final MessageRole role;             // user, assistant, system, error
  final DateTime timestamp;           // When message was created
  final bool isStreaming;             // Whether message is being streamed
  final Map<String, dynamic>? metadata; // Additional data
  
  // Factory methods
  factory ChatMessage.user({required String content});
  factory ChatMessage.assistant({required String content, bool isStreaming});
  factory ChatMessage.error({required String content});
}
ChatProvider Class

dart
class ChatProvider extends ChangeNotifier {
  List<ChatMessage> get messages;     // All chat messages
  bool get isTyping;                  // Whether AI is typing
  String? get error;                  // Current error message
  
  void sendMessage(String content);   // Send a message
  void clearMessages();               // Clear all messages
  void retryLastMessage();            // Retry last failed message
}
AIService Interface

dart
abstract class AIService {
  Future<String> sendMessage({
    required String message,
    List<ChatMessage> conversationHistory,
    Map<String, dynamic>? options,
  });
  
  Stream<String> sendMessageStream({
    required String message,
    List<ChatMessage> conversationHistory,
    Map<String, dynamic>? options,
  });
  
  Future<void> clearContext();
  Future<bool> isAvailable();
  void setOptions(Map<String, dynamic> options);
}
Examples

Example 1: Customer Support Chat

dart
class CustomerSupportChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = OpenAIService(
      apiKey: 'your-api-key',
      model: 'gpt-3.5-turbo',
    );
    
    final theme = ChatTheme(
      primaryColor: Colors.indigo,
      userBubbleColor: Colors.indigo,
      assistantBubbleColor: Colors.grey.shade200,
    );
    
    return ChatUI(
      chatProvider: ChatProvider(service),
      title: 'Customer Support',
      theme: theme,
      user: ChatUser(
        id: 'customer',
        name: 'You',
        avatarUrl: 'https://example.com/customer.jpg',
      ),
      assistant: ChatUser(
        id: 'support',
        name: 'Support Agent',
        avatarWidget: const Icon(Icons.support_agent),
      ),
    );
  }
}
Example 2: Medical Assistant (with Disclaimer)

dart
class MedicalAssistantChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.yellow.shade100,
            child: const Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Disclaimer: This AI provides general information only. '
                    'Always consult a healthcare professional.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ChatUI(
              chatProvider: ChatProvider(
                OpenAIService(apiKey: 'key', model: 'gpt-4'),
              ),
              title: 'Health Assistant',
              theme: ChatTheme.light().copyWith(
                primaryColor: Colors.teal,
                userBubbleColor: Colors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Example 3: E-commerce Product Assistant

dart
class ProductAssistant extends StatefulWidget {
  final String productId;
  
  const ProductAssistant({super.key, required this.productId});
  
  @override
  State<ProductAssistant> createState() => _ProductAssistantState();
}

class _ProductAssistantState extends State<ProductAssistant> {
  late ChatProvider _chatProvider;
  late AIService _aiService;
  
  @override
  void initState() {
    super.initState();
    _aiService = CustomAIService(
      apiEndpoint: 'https://api.example.com/chat',
      headers: {'X-Product-ID': widget.productId},
    );
    _chatProvider = ChatProvider(_aiService);
  }
  
  @override
  Widget build(BuildContext context) {
    return FloatingChatBubble(
      service: _aiService,
      title: 'Product Expert',
      bubbleColor: Colors.orange,
      bubbleIcon: Icons.shopping_bag,
    );
  }
}
Troubleshooting

Common Issues and Solutions

Issue	Solution
API Key not working	Verify key is correct and has proper permissions
Streaming not working	Check if your AI provider supports streaming
UI not showing	Ensure ChatProvider is properly initialized
Messages not saving	Implement your own persistence layer
Slow responses	Use Groq for faster responses or reduce maxTokens
Debug Mode

dart
// Enable debug logging
class DebugAIService extends LocalAIService {
  @override
  Future<String> sendMessage({...}) async {
    print('Sending: $message');
    final response = await super.sendMessage(...);
    print('Received: $response');
    return response;
  }
}
Performance Optimization

dart
// Use const constructors where possible
const customTheme = ChatTheme(
  primaryColor: Colors.blue,
  // ...
);

// Dispose providers properly
@override
void dispose() {
  _chatProvider.dispose();
  super.dispose();
}
Support & Resources

GitHub Repository: github.com/SyedaFakhiraSaghir/chatbot_ui
Issue Tracker: github.com/SyedaFakhiraSaghir/chatbot_ui/issues
Documentation: github.com/SyedaFakhiraSaghir/chatbot_ui/blob/main/README.md
Examples: Check the /example folder
Topics

chat
ui
ai
chatbot
messaging
License

MIT License - feel free to use in commercial and personal projects.
