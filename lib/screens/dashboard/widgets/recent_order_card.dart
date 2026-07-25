import 'package:flutter/material.dart';
import 'package:navni_sangraha/core/app_colors.dart';
import 'package:navni_sangraha/core/app_text_styles.dart';

class RecentOrderCard extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String outfitType;
  final String amount;
  final String status;
  final String deliveryDate;

  const RecentOrderCard({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.outfitType,
    required this.amount,
    required this.status,
    required this.deliveryDate,
  });

  @override
  Widget build(BuildContext context) {
    Color getStatusColor() {
      switch (status.toLowerCase()) {
        case "new":
          return const Color(0xFF8B5CF6); // purple (AppColors.primary)
        case "progress":
          return const Color(0xFF3B82F6); // blue
        case "completed":
          return const Color(0xFF10B981); // green (AppColors.success)
        default:
          return Colors.grey;
      }
    }

    String getStatusText() {
      if (status.toLowerCase() == "progress") {
        return "In Progress";
      }
      return status.substring(0, 1).toUpperCase() +
          status.substring(1).toLowerCase();
    }

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: getStatusColor().withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Column: Order details & Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Orderid
                      Text(
                        orderId,
                        style: AppTextStyles.title2,
                      ),
                      const SizedBox(width: 8),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3,),
                        decoration: BoxDecoration(
                          color: getStatusColor().withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          getStatusText(),
                          style: TextStyle(
                            color: getStatusColor(),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Customer Name
                  Text(
                    customerName,
                    style: AppTextStyles.title3,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    outfitType,
                    style: AppTextStyles.title4,
                  ),
                ],
              ),
            ),

            // Right Column: Price and Delivery Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "₹$amount",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  deliveryDate,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
