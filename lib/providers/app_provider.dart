import 'package:flutter/material.dart';
import '../features/discussion/models/message_model.dart';
import '../features/events/models/event_model.dart';

class AppProvider with ChangeNotifier {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<EventModel> _opportunities = [
    EventModel(
      id: 'event_1',
      title: 'Global Hackathon 2026',
      description: 'Join the biggest tech hackathon at ALU and win amazing prizes.',
      organizerId: 'organizer_1',
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
      date: DateTime.now().add(const Duration(days: 14)),
      location: 'Venture Studio',
      category: 'Startup Events',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
  
  // Scoped per userId so each account has its own RSVP and saved state.
  final Map<String, List<String>> _joinedEventIdsByUser = {};
  final Map<String, List<String>> _bookmarkedEventIdsByUser = {};
  final Map<String, List<MessageModel>> _chatMessages = {
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
    ]
  };

  List<EventModel> get opportunities => _opportunities;

  List<String> joinedEventIdsForUser(String userId) =>
      _joinedEventIdsByUser[userId] ?? [];

  List<String> bookmarkedEventIdsForUser(String userId) =>
      _bookmarkedEventIdsByUser[userId] ?? [];
  
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<EventModel> get filteredEvents {
    return _opportunities.where((event) {
      final matchesCategory = _selectedCategory == 'All' || event.category == _selectedCategory;
      final matchesSearch = event.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> fetchOpportunities() async {
    // Already loaded mock data
  }

  Future<void> joinEvent(String eventId, String userId) async {
    final joined = _joinedEventIdsByUser.putIfAbsent(userId, () => []);
    if (!joined.contains(eventId)) {
      joined.add(eventId);
      notifyListeners();
    }
  }

  Future<void> leaveEvent(String eventId, String userId) async {
    _joinedEventIdsByUser[userId]?.remove(eventId);
    notifyListeners();
  }

  Future<void> toggleBookmark(String eventId, String userId) async {
    final bookmarked = _bookmarkedEventIdsByUser.putIfAbsent(userId, () => []);
    if (bookmarked.contains(eventId)) {
      bookmarked.remove(eventId);
    } else {
      bookmarked.add(eventId);
    }
    notifyListeners();
  }

  List<MessageModel> getMessagesForEvent(String eventId) {
    return _chatMessages[eventId] ?? [];
  }

  Future<void> sendMessage(String eventId, String text, String userId, String userName) async {
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      eventId: eventId,
      userId: userId,
      userName: userName,
      text: text,
      timestamp: DateTime.now(),
    );

    if (_chatMessages.containsKey(eventId)) {
      _chatMessages[eventId]!.add(message);
    } else {
      _chatMessages[eventId] = [message];
    }
    notifyListeners();
  }

  Future<bool> createOpportunity({
    required String title,
    required String description,
    required String category,
    required String date,
    required String location,
  }) async {
    return false;
  }
}
