class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final String role; // 'Student' or 'Organizer'

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
    );
  }
}
