import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); //This is a private constructor. It prevents someone from writing: AppColors();
  static const background = Color(0xFF0F0F13);

  static const surface = Color(0xFF1A1A22);

  static const primary = Color(0xFF8B5CF6);

  static const primaryDark = Color(0xFF6D28D9);

  static const accent = Color(0xFFC084FC);

  static const textPrimary = Colors.white;

  static const textSecondary = Color(0xFF9CA3AF);

  static const success = Color(0xFF10B981);

  static const error = Color(0xFFEF4444);

  static const secondary = Colors.grey;

  static const danger = Colors.red;

  static const card = Color(0xFF1E1E1E);

  static const border = Color(0xFF2B2B2B);

  static const subtitle = Colors.white70;
}

// Notice that AppColors has a private constructor (AppColors._()), which prevents you from creating an instance of it 
//(i.e., you cannot do var colors = AppColors();).

// Because you cannot create instances of the class, any members must be marked as static so they can be accessed 
//directly on the class name:
