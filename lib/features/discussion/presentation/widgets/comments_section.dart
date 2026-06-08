import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/app_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../models/comment_model.dart';
import 'comment_tile.dart';

class CommentsSection extends StatefulWidget {
  final String eventId;

  const CommentsSection({super.key, required this.eventId});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  CommentModel? _replyingTo;

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;

    final appProvider = context.read<AppProvider>();

    if (_replyingTo != null) {
      appProvider.addReply(
        widget.eventId,
        _replyingTo!.id,
        text,
        user.id,
        user.fullName,
      );
    } else {
      appProvider.addComment(widget.eventId, text, user.id, user.fullName);
    }

    _commentController.clear();
    setState(() => _replyingTo = null);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = context.watch<AppProvider>().getCommentsForEvent(widget.eventId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (comments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'No comments yet. Be the first!',
                style: TextStyle(color: AppColors.textLight, fontSize: 13),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            separatorBuilder: (_, _) => const Divider(height: 24),
            itemBuilder: (context, index) => CommentTile(
              comment: comments[index],
              onReplyTap: (comment) => setState(() => _replyingTo = comment),
            ),
          ),
        const SizedBox(height: 16),
        if (_replyingTo != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text(
                  'Replying to ${_replyingTo!.userName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _replyingTo = null),
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
                  controller: _commentController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submitComment(),
                  decoration: InputDecoration(
                    hintText: _replyingTo != null ? 'Write a reply...' : 'Add a comment...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                onPressed: _submitComment,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
