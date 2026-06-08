class EventModel {
  final String id;
  final String title;
  final String description;
  final String organizerId;
  final DateTime date;
  final String location;
  final String category;
  final String? imageUrl;
  final DateTime createdAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.organizerId,
    required this.date,
    required this.location,
    required this.category,
    this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'organizerId': organizerId,
      'date': date.toIso8601String(),
      'location': location,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      organizerId: json['organizerId'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
