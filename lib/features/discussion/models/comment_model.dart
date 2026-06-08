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

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'userId': userId,
        'userName': userName,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'replies': replies.map((r) => r.toJson()).toList(),
      };

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id'] as String,
        eventId: json['eventId'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        text: json['text'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        replies: (json['replies'] as List? ?? [])
            .map((r) => CommentModel.fromJson(r as Map<String, dynamic>))
            .toList(),
      );
}
