import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/discussion/models/comment_model.dart';
import '../features/discussion/models/message_model.dart';
import '../features/events/models/event_model.dart';

class StorageService {
  static const _kEvents = 'app_events';
  static const _kJoined = 'app_joined';
  static const _kBookmarked = 'app_bookmarked';
  static const _kParticipants = 'app_participants';
  static const _kMessages = 'app_messages';
  static const _kComments = 'app_comments';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> saveEvents(List<EventModel> events) async {
    final p = await _prefs;
    await p.setString(_kEvents, jsonEncode(events.map((e) => e.toJson()).toList()));
  }

  Future<List<EventModel>?> loadEvents() async {
    final p = await _prefs;
    final raw = p.getString(_kEvents);
    if (raw == null) return null;
    return (jsonDecode(raw) as List)
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveJoined(Map<String, List<String>> data) async {
    final p = await _prefs;
    await p.setString(_kJoined, jsonEncode(data));
  }

  Future<Map<String, List<String>>?> loadJoined() async {
    final p = await _prefs;
    final raw = p.getString(_kJoined);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, List<String>.from(v as List)));
  }

  Future<void> saveBookmarked(Map<String, List<String>> data) async {
    final p = await _prefs;
    await p.setString(_kBookmarked, jsonEncode(data));
  }

  Future<Map<String, List<String>>?> loadBookmarked() async {
    final p = await _prefs;
    final raw = p.getString(_kBookmarked);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, List<String>.from(v as List)));
  }

  Future<void> saveParticipants(Map<String, List<Map<String, String>>> data) async {
    final p = await _prefs;
    await p.setString(_kParticipants, jsonEncode(data));
  }

  Future<Map<String, List<Map<String, String>>>?> loadParticipants() async {
    final p = await _prefs;
    final raw = p.getString(_kParticipants);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(
        k, (v as List).map((e) => Map<String, String>.from(e as Map)).toList()));
  }

  Future<void> saveMessages(Map<String, List<MessageModel>> data) async {
    final p = await _prefs;
    final encoded = data.map((k, v) => MapEntry(k, v.map((m) => m.toJson()).toList()));
    await p.setString(_kMessages, jsonEncode(encoded));
  }

  Future<Map<String, List<MessageModel>>?> loadMessages() async {
    final p = await _prefs;
    final raw = p.getString(_kMessages);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(
        k, (v as List).map((m) => MessageModel.fromJson(m as Map<String, dynamic>)).toList()));
  }

  Future<void> saveComments(Map<String, List<CommentModel>> data) async {
    final p = await _prefs;
    final encoded = data.map((k, v) => MapEntry(k, v.map((c) => c.toJson()).toList()));
    await p.setString(_kComments, jsonEncode(encoded));
  }

  Future<Map<String, List<CommentModel>>?> loadComments() async {
    final p = await _prefs;
    final raw = p.getString(_kComments);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(
        k, (v as List).map((c) => CommentModel.fromJson(c as Map<String, dynamic>)).toList()));
  }
}
