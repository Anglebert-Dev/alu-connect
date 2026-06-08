import 'dart:async' show unawaited;
import 'package:flutter/material.dart';
import '../core/data/seed_data.dart';
import '../features/discussion/models/comment_model.dart';
import '../features/discussion/models/message_model.dart';
import '../features/events/models/event_model.dart';
import '../services/storage_service.dart';

class AppProvider with ChangeNotifier {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final _storage = StorageService();

  final List<EventModel> _opportunities = [];
  final Map<String, List<String>> _joinedEventIdsByUser = {};
  final Map<String, List<String>> _bookmarkedEventIdsByUser = {};
  final Map<String, List<Map<String, String>>> _participantsByEvent = {};
  final Map<String, List<MessageModel>> _chatMessages = {};
  final Map<String, List<CommentModel>> _comments = {};

  AppProvider() {
    _opportunities.addAll(SeedData.events);
    SeedData.participants.forEach((k, v) => _participantsByEvent[k] = [...v]);
    SeedData.chatMessages.forEach((k, v) => _chatMessages[k] = [...v]);
    SeedData.comments.forEach((k, v) => _comments[k] = [...v]);
    unawaited(_init());
  }

  Future<void> _init() async {
    final events = await _storage.loadEvents();
    if (events != null) { _opportunities.clear(); _opportunities.addAll(events); }
    final joined = await _storage.loadJoined();
    if (joined != null) _joinedEventIdsByUser.addAll(joined);
    final bookmarked = await _storage.loadBookmarked();
    if (bookmarked != null) _bookmarkedEventIdsByUser.addAll(bookmarked);
    final parts = await _storage.loadParticipants();
    if (parts != null) parts.forEach((k, v) => _participantsByEvent[k] = v);
    final msgs = await _storage.loadMessages();
    if (msgs != null) msgs.forEach((k, v) => _chatMessages[k] = v);
    final cmts = await _storage.loadComments();
    if (cmts != null) cmts.forEach((k, v) => _comments[k] = v);
    notifyListeners();
  }

  List<EventModel> get opportunities => _opportunities;
  List<String> joinedEventIdsForUser(String userId) => _joinedEventIdsByUser[userId] ?? [];
  List<String> bookmarkedEventIdsForUser(String userId) => _bookmarkedEventIdsByUser[userId] ?? [];
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<EventModel> get filteredEvents {
    return _opportunities.where((event) {
      final matchesCategory = _selectedCategory == 'All' || event.category == _selectedCategory;
      final matchesSearch = event.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void setSearchQuery(String q) { _searchQuery = q; notifyListeners(); }
  void setSelectedCategory(String c) { _selectedCategory = c; notifyListeners(); }
  Future<void> fetchOpportunities() async {}

  Future<void> joinEvent(String eventId, String userId, String userName) async {
    final joined = _joinedEventIdsByUser.putIfAbsent(userId, () => []);
    if (!joined.contains(eventId)) {
      joined.add(eventId);
      final participants = _participantsByEvent.putIfAbsent(eventId, () => []);
      if (!participants.any((p) => p['id'] == userId)) {
        participants.add({'id': userId, 'name': userName});
      }
      unawaited(_storage.saveJoined(_joinedEventIdsByUser));
      unawaited(_storage.saveParticipants(_participantsByEvent));
      notifyListeners();
    }
  }

  Future<void> leaveEvent(String eventId, String userId) async {
    _joinedEventIdsByUser[userId]?.remove(eventId);
    _participantsByEvent[eventId]?.removeWhere((p) => p['id'] == userId);
    unawaited(_storage.saveJoined(_joinedEventIdsByUser));
    unawaited(_storage.saveParticipants(_participantsByEvent));
    notifyListeners();
  }

  Future<void> toggleBookmark(String eventId, String userId) async {
    final bookmarked = _bookmarkedEventIdsByUser.putIfAbsent(userId, () => []);
    bookmarked.contains(eventId) ? bookmarked.remove(eventId) : bookmarked.add(eventId);
    unawaited(_storage.saveBookmarked(_bookmarkedEventIdsByUser));
    notifyListeners();
  }

  List<Map<String, String>> getParticipantsForEvent(String eventId) => _participantsByEvent[eventId] ?? [];
  int createdOpportunitiesCount(String userId) => _opportunities.where((e) => e.organizerId == userId).length;
  List<MessageModel> getMessagesForEvent(String eventId) => _chatMessages[eventId] ?? [];

  Future<void> sendMessage(String eventId, String text, String userId, String userName) async {
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      eventId: eventId, userId: userId, userName: userName, text: text, timestamp: DateTime.now(),
    );
    _chatMessages.putIfAbsent(eventId, () => []).add(message);
    unawaited(_storage.saveMessages(_chatMessages));
    notifyListeners();
  }

  List<CommentModel> getCommentsForEvent(String eventId) => _comments[eventId] ?? [];

  void addComment(String eventId, String text, String userId, String userName) {
    final comment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      eventId: eventId, userId: userId, userName: userName, text: text, timestamp: DateTime.now(),
    );
    _comments.putIfAbsent(eventId, () => []).insert(0, comment);
    unawaited(_storage.saveComments(_comments));
    notifyListeners();
  }

  void addReply(String eventId, String commentId, String text, String userId, String userName) {
    final comments = _comments[eventId];
    if (comments == null) return;
    final index = comments.indexWhere((c) => c.id == commentId);
    if (index == -1) return;
    comments[index].replies.add(CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      eventId: eventId, userId: userId, userName: userName, text: text, timestamp: DateTime.now(),
    ));
    unawaited(_storage.saveComments(_comments));
    notifyListeners();
  }

  Future<bool> createOpportunity({
    required String title, required String description, required String category,
    required DateTime date, required String location,
    required String organizerId, required String organizerName,
  }) async {
    _opportunities.insert(0, EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title, description: description, organizerId: organizerId, organizerName: organizerName,
      date: date, location: location, category: category, createdAt: DateTime.now(),
    ));
    unawaited(_storage.saveEvents(_opportunities));
    notifyListeners();
    return true;
  }
}
