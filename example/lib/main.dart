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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot UI Demo'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Integration Methods',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select how you want to integrate the chat UI',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Full Screen Chat Option
              _buildIntegrationCard(
                context: context,
                title: 'Full Screen Chat',
                description: 'Open chat as a full screen page',
                icon: Icons.fullscreen,
                color: Colors.purple,
                onTap: () => _openFullScreenChat(context),
              ),
              
              const SizedBox(height: 16),
              
              // Floating Chat Bubble Option
              _buildIntegrationCard(
                context: context,
                title: 'Floating Chat Bubble',
                description: 'Chat bubble that floats over your app content',
                icon: Icons.chat_bubble,
                color: Colors.green,
                onTap: () => _openFloatingChat(context),
              ),
              
              const SizedBox(height: 24),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntegrationCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }

  void _openFullScreenChat(BuildContext context) {
    // Example: Using Local AI
    final service = LocalAIService();
    final chatProvider = ChatProvider(service);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatUI(
          chatProvider: chatProvider,
          title: 'AI Assistant',
          theme: ChatTheme.light(),
        ),
      ),
    );
  }

  void _openFloatingChat(BuildContext context) {
    // Navigate to a screen with floating chat bubble
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FloatingChatDemoScreen(),
      ),
    );
  }
}

// Demo screen showing floating chat bubble over content
class FloatingChatDemoScreen extends StatelessWidget {
  const FloatingChatDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Chat Demo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          
          
          // Floating Chat Bubble
          FloatingChatBubble(
            service: LocalAIService(), // Change this to any AI service
            title: 'AI Assistant',
            bubbleColor: Colors.purple,
            bubbleIcon: Icons.support_agent,
            showCloseButton: true,
            padding: const EdgeInsets.all(16),
          ),
        ],
      ),
    );
  }
}