import 'package:flutter/material.dart';
import '../chatbot_ui.dart';

class FloatingChatBubble extends StatefulWidget {
  final AIService service;
  final ChatTheme? theme;
  final String? title;
  final IconData? bubbleIcon;
  final Color? bubbleColor;
  final bool showCloseButton;
  final double bubbleSize;
  final EdgeInsets padding;

  const FloatingChatBubble({
    super.key,
    required this.service,
    this.theme,
    this.title,
    this.bubbleIcon,
    this.bubbleColor,
    this.showCloseButton = true,
    this.bubbleSize = 56,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  State<FloatingChatBubble> createState() => _FloatingChatBubbleState();
}

class _FloatingChatBubbleState extends State<FloatingChatBubble> with SingleTickerProviderStateMixin {
  bool _isChatOpen = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late ChatProvider _chatProvider;

  @override
  void initState() {
    super.initState();
    _chatProvider = ChatProvider(widget.service);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _chatProvider.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
      if (_isChatOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content behind the bubble (your app content)
        Positioned.fill(
          child: Container(
            color: _isChatOpen 
                ? Colors.black.withValues(alpha: 0.5) 
                : Colors.transparent,
          ),
        ),
        
        // Floating Chat Window
        if (_isChatOpen)
          Positioned(
            bottom: widget.bubbleSize + widget.padding.bottom + 10,
            right: widget.padding.right,
            left: widget.padding.left,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    constraints: const BoxConstraints(
                      maxHeight: 600,
                      minHeight: 400,
                    ),
                    width: MediaQuery.of(context).size.width - widget.padding.horizontal,
                    child: ChatUI(
                      chatProvider: _chatProvider,
                      title: widget.title ?? 'AI Assistant',
                      theme: widget.theme ?? ChatTheme.light(),
                      showHeader: true,
                      actions: [
                        if (widget.showCloseButton)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: _toggleChat,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        
        // Floating Chat Bubble Button
        Positioned(
          bottom: widget.padding.bottom,
          right: widget.padding.right,
          child: GestureDetector(
            onTap: _toggleChat,
            child: Container(
              width: widget.bubbleSize,
              height: widget.bubbleSize,
              decoration: BoxDecoration(
                color: widget.bubbleColor ?? Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ripple effect when chat is open
                  if (_isChatOpen)
                    Container(
                      width: widget.bubbleSize,
                      height: widget.bubbleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  
                  // Icon
                  Icon(
                    _isChatOpen ? Icons.close : (widget.bubbleIcon ?? Icons.chat),
                    color: Colors.white,
                    size: widget.bubbleSize * 0.5,
                  ),
                  
                  // Unread message indicator
                  if (_chatProvider.messages.isNotEmpty && !_isChatOpen)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${_chatProvider.messages.where((m) => m.role == MessageRole.assistant).length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}