import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _fullName;
  String? _email;
  String? _role; // 'Student' or 'Organizer'

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get fullName => _fullName;
  String? get email => _email;
  String? get role => _role;

  // Placeholder methods for registration, login, logout, and session check
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    // TODO: Implement registration logic in Phase 2
    return false;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // TODO: Implement login logic in Phase 2
    return false;
  }

  Future<void> logout() async {
    // TODO: Implement logout logic in Phase 2
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkSession() async {
    // TODO: Implement session load from SharedPreferences in Phase 8
  }
}
