import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/comment_model.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final bool isReply;
  final void Function(CommentModel comment) onReplyTap;

  const CommentTile({
    super.key,
    required this.comment,
    required this.onReplyTap,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('MMM d • h:mm a').format(comment.timestamp);
    final initial = comment.userName.isNotEmpty ? comment.userName[0].toUpperCase() : '?';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: isReply ? 14 : 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: Text(
                initial,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: isReply ? 12 : 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeFormat,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  if (!isReply)
                    GestureDetector(
                      onTap: () => onReplyTap(comment),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 6.0),
                        child: Text(
                          'Reply',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 46.0, top: 8.0),
            child: Column(
              children: comment.replies
                  .map((reply) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: CommentTile(
                          comment: reply,
                          isReply: true,
                          onReplyTap: onReplyTap,
                        ),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
