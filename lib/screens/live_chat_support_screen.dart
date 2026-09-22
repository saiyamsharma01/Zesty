import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class LiveChatSupportScreen extends StatefulWidget {
  const LiveChatSupportScreen({super.key});

  @override
  State<LiveChatSupportScreen> createState() => _LiveChatSupportScreenState();
}

class _LiveChatSupportScreenState extends State<LiveChatSupportScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'bot',
      'text': 'Hi there! 👋 Welcome to Zepto 24x7 Priority Support. How can I help you today?',
      'time': 'Just now',
    },
  ];

  final List<String> _quickChips = [
    'Where is my order?',
    'Missing item in delivery',
    'Check Refund Status',
    'Zepto Cash wallet issue',
    'Payment failed but deducted',
  ];

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = text.trim();
    _msgController.clear();

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': userMsg,
        'time': 'Just now',
      });
    });

    _scrollToBottom();

    // Smart bot reply after 600ms
    Future.delayed(const Duration(milliseconds: 600), () {
      String reply = "I've logged ticket #TKT${DateTime.now().millisecondsSinceEpoch.toString().substring(7)} for you. Our specialist is reviewing your account.";

      final lower = userMsg.toLowerCase();
      if (lower.contains('order') || lower.contains('delivery')) {
        reply = "Your recent order is currently in transit with 10-minute dark store delivery! You can track its live rider location in the 'Your Orders' section.";
      } else if (lower.contains('refund')) {
        reply = "All eligible refunds are automatically credited to your Zepto Cash wallet instantly or to your bank account within 2-4 hours.";
      } else if (lower.contains('cash') || lower.contains('wallet')) {
        reply = "Your Zepto Cash balance is completely secured and ready for 1-tap checkout on your next order!";
      } else if (lower.contains('missing') || lower.contains('item')) {
        reply = "We are very sorry about that! A full refund for the item has been flagged for instant processing to your Zepto Cash.";
      }

      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'bot',
            'text': reply,
            'time': 'Just now',
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF3F007D),
              child: Icon(Icons.support_agent, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Zepto Support',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
                Text(
                  '🟢 Online • Instant Replies',
                  style: TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.black87),
            onPressed: () => Get.toNamed(Routes.yourOrders),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Questions Chips Bar
          Container(
            height: 48,
            color: Colors.white,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _quickChips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final chip = _quickChips[index];
                return GestureDetector(
                  onTap: () => _sendMessage(chip),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE9D5FF)),
                    ),
                    child: Text(
                      chip,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF7E22CE)),
                    ),
                  ),
                );
              },
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isBot = msg['sender'] == 'bot';

                return Align(
                  alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isBot ? Colors.white : const Color(0xFF3F007D),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: isBot ? Radius.zero : const Radius.circular(14),
                        bottomRight: isBot ? const Radius.circular(14) : Radius.zero,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg['text'],
                          style: TextStyle(
                            fontSize: 13.5,
                            color: isBot ? Colors.black87 : Colors.white,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'],
                          style: TextStyle(
                            fontSize: 10,
                            color: isBot ? Colors.grey.shade500 : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Input Composer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _msgController,
                        onSubmitted: _sendMessage,
                        decoration: const InputDecoration(
                          hintText: 'Type your question...',
                          hintStyle: TextStyle(fontSize: 13.5, color: Colors.grey),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_msgController.text),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF3F007D),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
