import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF0F4C81); // Deep royal blue
  static const Color secondary = Color(0xFF1E88E5); // Lighter royal blue

  // Background and surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF9FAFB); // Very light gray
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFF1F2937); // Dark charcoal
  static const Color textSecondary = Color(0xFF4B5563); // Medium gray
  static const Color textLight = Color(0xFF9CA3AF); // Light gray for hints
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color border = Color(0xFFE5E7EB);

  // Status colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red

  // Category colors
  static const Map<String, Color> categoryColors = {
    'Hackathons': Color(0xFF8B5CF6),
    'Leadership Programs': Color(0xFF0F4C81),
    'Startup Events': Color(0xFF059669),
    'Workshops': Color(0xFFD97706),
    'Community Activities': Color(0xFFDB2777),
    'Internship Opportunities': Color(0xFF0891B2),
  };
}
