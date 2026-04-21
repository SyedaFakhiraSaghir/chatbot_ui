import 'package:flutter/material.dart';
import 'package:chatbot_ui/chatbot_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot UI Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot UI Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatExample(
                      service: LocalAIService(),
                      title: 'Local AI Chat',
                    ),
                  ),
                );
              },
              child: const Text('Local AI Chat'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatExample(
                      service: OpenAIService(
                        apiKey: 'YOUR_API_KEY_HERE',
                      ),
                      title: 'OpenAI Chat',
                    ),
                  ),
                );
              },
              child: const Text('OpenAI Chat (requires API key)'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatExample extends StatelessWidget {
  final AIService service;
  final String title;

  const ChatExample({
    super.key,
    required this.service,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final chatProvider = ChatProvider(service);
    
    return ChatUI(
      chatProvider: chatProvider,
      title: title,
      theme: ChatTheme.light(),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => chatProvider.clearMessages(),
        ),
      ],
    );
  }
}