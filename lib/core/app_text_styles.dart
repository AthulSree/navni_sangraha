import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const primaryHeading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(fontSize: 16, color: AppColors.textPrimary);

  static const subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const dashboardUser = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}



// --Now anywhere in the app:

// Text(
//     "Dashboard",
//     style: AppTextStyles.heading,
// )

// --No more repeating fontSize, fontWeight, and colors.