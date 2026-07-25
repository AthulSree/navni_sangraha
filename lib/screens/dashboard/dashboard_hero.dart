

import 'package:flutter/material.dart';
import 'package:navni_sangraha/core/app_colors.dart';

class DashboardHero extends StatelessWidget {
  final String userName;
  const DashboardHero({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ----------------------
                    // Top Row
                    // ----------------------
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A), // Navy blue
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryDark, // Dark purple
                                    width: 1.5,
                                  ),
                                ),
                                child: Image.asset("assets/navni_sangraha_logo.png"),
                              ),

                              const SizedBox(width: 14),

                              // App Name
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Navni Sangraha",
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),


                                  // App Subtitle
                                  Text(
                                    "Boutique ERP",
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Notification Icon
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.textPrimary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Person Icon
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.textPrimary.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    Text(
                      "Hello, $userName 👋",
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 18),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Here's what's happening today.",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                  ],
                );
  }
}