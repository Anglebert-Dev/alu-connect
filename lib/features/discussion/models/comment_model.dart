class CommentModel {
  final String id;
  final String eventId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
    List<CommentModel>? replies,
  }) : replies = replies ?? [];
}
