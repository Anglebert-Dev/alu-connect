import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  
  final List<UserModel> _users = [
    const UserModel(
      id: 'student_1',
      fullName: 'John Student',
      email: 'student@alu.com',
      password: 'password123',
      role: 'Student',
    ),
    const UserModel(
      id: 'organizer_1',
      fullName: 'Jane Organizer',
      email: 'organizer@alu.com',
      password: 'password123',
      role: 'Organizer',
    ),
  ];

  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;

  AuthProvider() {
    checkSession();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final emailLower = email.trim().toLowerCase();
    
    final bool exists = _users.any((u) => u.email.toLowerCase() == emailLower);
    if (exists) {
      return false;
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: name.trim(),
      email: emailLower,
      password: password,
      role: role,
    );

    _users.add(newUser);
    _currentUser = newUser;
    _isAuthenticated = true;
    
    await _saveSession(newUser);
    notifyListeners();
    return true;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final emailLower = email.trim().toLowerCase();
    
    try {
      final user = _users.firstWhere(
        (u) => u.email.toLowerCase() == emailLower && u.password == password,
      );
      
      _currentUser = user;
      _isAuthenticated = true;
      
      await _saveSession(user);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUser = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_session');
    
    notifyListeners();
  }

  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionString = prefs.getString('user_session');
    
    if (sessionString != null) {
      try {
        final Map<String, dynamic> userMap = json.decode(sessionString) as Map<String, dynamic>;
        final user = UserModel.fromJson(userMap);
        
        _currentUser = user;
        _isAuthenticated = true;
        notifyListeners();
      } catch (_) {
        await prefs.remove('user_session');
      }
    }
  }

  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionString = json.encode(user.toJson());
    await prefs.setString('user_session', sessionString);
  }

  Future<void> updateProfile({required String name, required String role}) async {
    if (_currentUser == null) return;

    final updatedUser = UserModel(
      id: _currentUser!.id,
      fullName: name.trim(),
      email: _currentUser!.email,
      password: _currentUser!.password,
      role: role,
    );

    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
    }

    _currentUser = updatedUser;
    await _saveSession(updatedUser);
    notifyListeners();
  }
}
