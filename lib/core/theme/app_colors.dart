import 'package:flutter/material.dart';

/// Centralized color palette for PlantOps app
/// All developers should use these constants instead of hardcoded colors
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Colors (Plant/Nature themed)
  static const Color primary = Color(0xFF2E7D32); // Forest Green
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);

  // Secondary Colors
  static const Color secondary = Color(0xFF8BC34A); // Light Green
  static const Color accent = Color(0xFFFF9800); // Orange (for notifications/reminders)

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Plant Health Status Colors
  static const Color healthyPlant = Color(0xFF4CAF50);
  static const Color needsAttention = Color(0xFFFFC107);
  static const Color unhealthyPlant = Color(0xFFF44336);

  // Reminder Priority Colors
  static const Color priorityHigh = Color(0xFFF44336);
  static const Color priorityMedium = Color(0xFFFF9800);
  static const Color priorityLow = Color(0xFF4CAF50);
}