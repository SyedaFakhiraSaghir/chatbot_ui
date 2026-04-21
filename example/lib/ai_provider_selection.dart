import 'package:flutter/material.dart';
import 'package:chatbot_ui/chatbot_ui.dart';

enum AIProvider {
  local('Local AI', Icons.devices, Colors.green),
  openAI('OpenAI', Icons.auto_awesome, Colors.blue),
  groq('Groq', Icons.speed, Colors.orange),
  gemini('Gemini', Icons.rocket_launch, Colors.deepPurple);

  final String name;
  final IconData icon;
  final Color color;

  const AIProvider(this.name, this.icon, this.color);
}

class AIProviderSelectionDialog extends StatefulWidget {
  final Function(AIService, String) onProviderSelected;

  const AIProviderSelectionDialog({
    super.key,
    required this.onProviderSelected,
  });

  @override
  State<AIProviderSelectionDialog> createState() => _AIProviderSelectionDialogState();
}

class _AIProviderSelectionDialogState extends State<AIProviderSelectionDialog> {
  AIProvider? _selectedProvider;
  final Map<AIProvider, String> _apiKeys = {};
  final Map<AIProvider, String> _models = {
    AIProvider.groq: 'mixtral-8x7b-32768',
    AIProvider.openAI: 'gpt-3.5-turbo',
    AIProvider.gemini: 'gemini-pro',
  };

  final Map<AIProvider, List<String>> _availableModels = {
    AIProvider.groq: [
      'mixtral-8x7b-32768',
      'llama2-70b-4096',
      'gemma-7b-it',
      'llama3-70b-8192',
      'llama3-8b-8192',
    ],
    AIProvider.openAI: [
      'gpt-3.5-turbo',
      'gpt-4',
      'gpt-4-turbo-preview',
    ],
    AIProvider.gemini: [
      'gemini-pro',
      'gemini-pro-vision',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select AI Provider',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose which AI service to use for your chat',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Provider selection
            ...AIProvider.values.map((provider) => _buildProviderOption(provider)),
            
            if (_selectedProvider != null) ...[
              const SizedBox(height: 20),
              // API Key input
              TextField(
                decoration: InputDecoration(
                  labelText: '${_selectedProvider!.name} API Key',
                  hintText: 'Enter your API key',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(_selectedProvider!.icon, color: _selectedProvider!.color),
                ),
                obscureText: true,
                onChanged: (value) => _apiKeys[_selectedProvider!] = value,
              ),
              
              const SizedBox(height: 16),
              
              // Model selection (for providers with multiple models)
              if (_availableModels.containsKey(_selectedProvider))
                DropdownButtonFormField<String>(
                  value: _models[_selectedProvider],
                  decoration: const InputDecoration(
                    labelText: 'Model',
                    border: OutlineInputBorder(),
                  ),
                  items: _availableModels[_selectedProvider]?.map((model) {
                    return DropdownMenuItem(value: model, child: Text(model));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _models[_selectedProvider!] = value;
                      });
                    }
                  },
                ),
              
              const SizedBox(height: 24),
              
              // Start button
              ElevatedButton.icon(
                onPressed: () => _startChat(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: _selectedProvider!.color,
                ),
                icon: const Icon(Icons.chat, color: Colors.white),
                label: Text(
                  'Start Chat with ${_selectedProvider!.name}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProviderOption(AIProvider provider) {
    final isSelected = _selectedProvider == provider;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      color: isSelected ? provider.color.withValues(alpha: 0.1) : null,
      child: InkWell(
        onTap: () => setState(() => _selectedProvider = provider),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: provider.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(provider.icon, color: provider.color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getProviderDescription(provider),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: provider.color),
            ],
          ),
        ),
      ),
    );
  }

  String _getProviderDescription(AIProvider provider) {
    switch (provider) {
      case AIProvider.local:
        return 'Fast, offline AI with rule-based responses';
      case AIProvider.openAI:
        return 'GPT models with advanced capabilities';
      case AIProvider.groq:
        return 'Ultra-fast inference with LPU technology';
      case AIProvider.gemini:
        return 'Google\'s most capable AI model';
    }
  }

  void _startChat() {
    if (_selectedProvider == null || (_selectedProvider != AIProvider.local && 
        (_apiKeys[_selectedProvider]?.isEmpty ?? true))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter API key')),
      );
      return;
    }

    AIService service;
    String title;

    switch (_selectedProvider!) {
      case AIProvider.local:
        service = LocalAIService();
        title = 'Local AI Assistant';
        break;
      case AIProvider.openAI:
        service = OpenAIService(
          apiKey: _apiKeys[AIProvider.openAI]!,
          model: _models[AIProvider.openAI]!,
        );
        title = 'OpenAI Assistant';
        break;
      case AIProvider.groq:
        service = GroqService(
          apiKey: _apiKeys[AIProvider.groq]!,
          model: _models[AIProvider.groq]!,
        );
        title = 'Groq AI Assistant';
        break;
      case AIProvider.gemini:
        service = GeminiService(
          apiKey: _apiKeys[AIProvider.gemini]!,
          model: _models[AIProvider.gemini]!,
        );
        title = 'Gemini Assistant';
        break;
    }

    Navigator.pop(context);
    widget.onProviderSelected(service, title);
  }
}