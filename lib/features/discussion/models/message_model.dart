class MessageModel {
  final String id;
  final String eventId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      eventId: json['eventId'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
