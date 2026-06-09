import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CommentInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? replyingToName;
  final VoidCallback onSubmit;
  final VoidCallback onCancelReply;

  const CommentInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
    required this.onCancelReply,
    this.replyingToName,
  });

  @override
  State<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<CommentInputBar> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (widget.focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            alignment: 1.0,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.replyingToName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text(
                  'Replying to ${widget.replyingToName}',
                  style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onCancelReply,
                  child: const Icon(Icons.close, size: 16, color: AppColors.textLight),
                ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => widget.onSubmit(),
                  decoration: InputDecoration(
                    hintText: widget.replyingToName != null ? 'Write a reply...' : 'Add a comment...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                onPressed: widget.onSubmit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
