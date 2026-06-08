import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../providers/app_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../events/models/event_model.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_bar.dart';

class ChatScreen extends StatefulWidget {
  final EventModel event;

  const ChatScreen({super.key, required this.event});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;

    context.read<AppProvider>().sendMessage(widget.event.id, text, user.id, user.fullName);
    _messageController.clear();

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
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final currentUserId = context.watch<AuthProvider>().currentUser?.id;
    final messages = appProvider.getMessagesForEvent(widget.event.id);

    return Scaffold(
      appBar: CustomAppBar(title: 'Live Chat', showBackButton: true),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: AppColors.surface,
            width: double.infinity,
            child: Text(
              widget.event.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.textLight),
                        SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Say hi to other attendees!',
                          style: TextStyle(color: AppColors.textLight, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppConstants.paddingDefault),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ChatBubble(
                        message: message,
                        isMe: message.userId == currentUserId,
                      );
                    },
                  ),
          ),
          ChatInputBar(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
