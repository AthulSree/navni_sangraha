import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:navni_sangraha/core/app_colors.dart';
import 'package:navni_sangraha/core/app_text_styles.dart';

class OrderStatusCard extends StatelessWidget {

  final int newOrders;
  final int inProgress;
  final int completed;

  const OrderStatusCard({
    super.key,
    required this.newOrders,
    required this.inProgress,
    required this.completed,
  });

  int get total => newOrders + inProgress + completed;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),

      child: Row(
        children: [

          // =====================
          // DONUT CHART
          // =====================

          SizedBox(
            width: 150,
            height: 150,

            child: Stack(
              alignment: Alignment.center,
              children: [

                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 45,

                    sections: [

                      PieChartSectionData(
                        value: newOrders.toDouble(),
                        color: const Color(0xFF8B5CF6),
                        radius: 16,
                        title: "",
                      ),

                      PieChartSectionData(
                        value: inProgress.toDouble(),
                        color: const Color(0xFF3B82F6),
                        radius: 16,
                        title: "",
                      ),

                      PieChartSectionData(
                        value: completed.toDouble(),
                        color: const Color(0xFF10B981),
                        radius: 16,
                        title: "",
                      ),
                    ],
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(
                      total.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Text(
                      "Orders",
                      style: AppTextStyles.title4
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // =====================
          // LEGEND
          // =====================

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                _StatusItem(
                  color: const Color(0xFF8B5CF6),
                  title: "New Orders",
                  value: newOrders.toString(),
                ),

                const SizedBox(height: 18),

                _StatusItem(
                  color: const Color(0xFF3B82F6),
                  title: "In Progress",
                  value: inProgress.toString(),
                ),

                const SizedBox(height: 18),

                _StatusItem(
                  color: const Color(0xFF10B981),
                  title: "Completed",
                  value: completed.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {

  final Color color;
  final String title;
  final String value;

  const _StatusItem({
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}