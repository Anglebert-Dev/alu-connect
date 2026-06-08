import 'package:flutter/material.dart';
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
  
  final List<String> _joinedEventIds = [];
  final List<String> _bookmarkedEventIds = [];
  final Map<String, List<dynamic>> _comments = {}; 

  List<EventModel> get opportunities => _opportunities;
  List<String> get joinedEventIds => _joinedEventIds;
  List<String> get bookmarkedEventIds => _bookmarkedEventIds;
  
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

  Future<void> joinEvent(String eventId) async {
    if (!_joinedEventIds.contains(eventId)) {
      _joinedEventIds.add(eventId);
      notifyListeners();
    }
  }

  Future<void> leaveEvent(String eventId) async {
    _joinedEventIds.remove(eventId);
    notifyListeners();
  }

  Future<void> toggleBookmark(String eventId) async {
    if (_bookmarkedEventIds.contains(eventId)) {
      _bookmarkedEventIds.remove(eventId);
    } else {
      _bookmarkedEventIds.add(eventId);
    }
    notifyListeners();
  }

  List<dynamic> getCommentsForEvent(String eventId) {
    return _comments[eventId] ?? [];
  }

  Future<void> addComment(String eventId, String message, String userName) async {
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
