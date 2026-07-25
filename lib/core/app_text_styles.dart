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

  static const title1 = TextStyle(color: Color.fromARGB(255, 204, 203, 203), fontSize: 18, fontWeight: FontWeight.w500);
  // eg: dashboard => Recent Orders

  static const title2 = TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold,);
  // eg: dashboard => Recent Orders OrderId

  static const title3 = TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w600,);
  // eg: dashboard => Recent Orders Customer Name

  static const title4 = TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600,);
  // eg: dashboard => Recent Orders Outfit Type

  static const title5 = TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold,);
  // eg: dashboard => Recent Orders OrderId

  static const titleViewAll = TextStyle(color: Color.fromARGB(255, 154, 114, 247), fontSize: 13, fontWeight: FontWeight.w500,);
  // eg: dashboard => Recent Orders OrderId


}



// --Now anywhere in the app:

// Text(
//     "Dashboard",
//     style: AppTextStyles.heading,
// )

// --No more repeating fontSize, fontWeight, and colors.