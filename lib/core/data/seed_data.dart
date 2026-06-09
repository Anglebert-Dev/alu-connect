import '../../features/discussion/models/comment_model.dart';
import '../../features/discussion/models/message_model.dart';
import '../../features/events/models/event_model.dart';

class SeedData {
  static List<EventModel> get events => [
        EventModel(
          id: 'event_1',
          title: 'Global Hackathon 2026',
          description: 'Join the biggest tech hackathon at ALU and win amazing prizes.',
          organizerId: 'organizer_1',
          organizerName: 'Jane Organizer',
          date: DateTime.now().add(const Duration(days: 5)),
          location: 'Innovation Hub',
          category: 'Hackathons',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        EventModel(
          id: 'event_2',
          title: 'Leadership Workshop',
          description: 'Develop your leadership skills with industry experts.',
          organizerId: 'organizer_1',
          organizerName: 'Jane Organizer',
          date: DateTime.now().add(const Duration(days: 10)),
          location: 'Main Auditorium',
          category: 'Leadership Programs',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        EventModel(
          id: 'event_3',
          title: 'Startup Pitch Night',
          description: 'Pitch your ideas to top investors.',
          organizerId: 'organizer_1',
          organizerName: 'Jane Organizer',
          date: DateTime.now().add(const Duration(days: 14)),
          location: 'Venture Studio',
          category: 'Startup Events',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

  static Map<String, List<Map<String, String>>> get participants => {
        'event_1': [
          {'id': 'user_2', 'name': 'Alex Johnson'},
          {'id': 'user_3', 'name': 'Samantha Lee'},
        ],
      };

  static Map<String, List<MessageModel>> get chatMessages => {
        'event_1': [
          MessageModel(
            id: 'msg_1',
            eventId: 'event_1',
            userId: 'user_2',
            userName: 'Alex Johnson',
            text: 'Is anyone looking for a team member?',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          MessageModel(
            id: 'msg_2',
            eventId: 'event_1',
            userId: 'user_3',
            userName: 'Samantha Lee',
            text: 'Yes! We need a frontend developer.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
      };

  static Map<String, List<CommentModel>> get comments => {
        'event_2': [
          CommentModel(
            id: 'comment_1',
            eventId: 'event_2',
            userId: 'user_4',
            userName: 'Maria Santos',
            text: 'Will there be any recorded sessions for those who cannot attend?',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            replies: [
              CommentModel(
                id: 'reply_1',
                eventId: 'event_2',
                userId: 'organizer_1',
                userName: 'Jane Organizer',
                text: 'Yes! All sessions will be recorded and shared afterward.',
                timestamp: DateTime.now().subtract(const Duration(hours: 4)),
              ),
            ],
          ),
          CommentModel(
            id: 'comment_2',
            eventId: 'event_2',
            userId: 'user_5',
            userName: 'David Kim',
            text: 'What should we bring to the workshop?',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ],
      };
}
