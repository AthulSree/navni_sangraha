import 'package:flutter/material.dart';
import 'package:navni_sangraha/core/app_colors.dart';
import 'package:navni_sangraha/screens/dashboard/dashboard_hero.dart';
import 'package:navni_sangraha/screens/dashboard/widgets/statistic_card.dart';

class DashboardScreen extends StatelessWidget {
  final String userName;
  const DashboardScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 85, 49, 247),
              Color.fromARGB(255, 44, 42, 138),
              Color(0xFF1A1A24),
              Color(0xFF0F0F13),
            ],
            stops: [0.0, 0.35, 0.70, 1.0],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // ==========================
                // Hero Section
                // ==========================
                DashboardHero(userName: userName),

                // ==========================
                // Dashboard Content
                // ==========================
                SizedBox(height: 30),

                SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      Expanded(
                        child: StatisticCard(
                          title: "New Orders",
                          value: "12",
                          icon: Icons.inventory_2_outlined,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: StatisticCard(
                          title: "In Progress",
                          value: "28",
                          icon: Icons.pending_actions,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: StatisticCard(
                          title: "Completed",
                          value: "45",
                          icon: Icons.check_circle_outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
