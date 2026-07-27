import 'package:flutter/material.dart';
import 'package:navni_sangraha/core/app_colors.dart';
import 'package:navni_sangraha/core/app_text_styles.dart';
import 'package:navni_sangraha/screens/dashboard/dashboard_hero.dart';
import 'package:navni_sangraha/screens/dashboard/widgets/order_status_card.dart';
import 'package:navni_sangraha/screens/dashboard/widgets/recent_order_card.dart';
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
            stops: [0.0, 0.10, 0.50, 1.0],
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



                // ==============================
                // Recent Orders
                // ==============================
                SizedBox(height: 40),

                Row(
                  children: [
                    Text("Recent Orders", style: AppTextStyles.title1,),
                    Spacer(),
                    Text("View All", style: AppTextStyles.titleViewAll,),
                    Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 15,)
                  ],
                ),

                SizedBox(height: 12,),

                RecentOrderCard(orderId: "NSD260725001", customerName: "Anjali", outfitType: "Lehenga", amount: "26000", status: "new", deliveryDate: "30-07-2026"),

                SizedBox(height: 12,),

                RecentOrderCard(orderId: "NSD260725001", customerName: "Anjali", outfitType: "Lehenga", amount: "26000", status: "progress", deliveryDate: "30-07-2026"),

                SizedBox(height: 12,),
                
                RecentOrderCard(orderId: "NSD260725001", customerName: "Anjali", outfitType: "Lehenga", amount: "26000", status: "completed", deliveryDate: "30-07-2026"),

                SizedBox(height: 12,),

                RecentOrderCard(orderId: "NSD260725001", customerName: "Anjali", outfitType: "Lehenga", amount: "26000", status: "progress", deliveryDate: "30-07-2026"),
              
              

                // ==============================
                // Order Status
                // ==============================
                SizedBox(height: 40),

                Row(
                  children: [
                    Text("Order Status Overview", style: AppTextStyles.title1,),
                  ],
                ),
                
                SizedBox(height: 12),

                OrderStatusCard(newOrders: 120, inProgress: 20, completed: 100),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
