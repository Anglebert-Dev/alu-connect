import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileRoleBadge extends StatelessWidget {
  final String role;

  const ProfileRoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isStudent = role.toLowerCase() == 'student';
    final color = isStudent ? AppColors.primary : AppColors.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
