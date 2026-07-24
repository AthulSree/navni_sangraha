import 'package:flutter/material.dart';
import 'package:navni_sangraha/core/app_colors.dart';

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool isLoading;
  final String? subtitle;
  final Color? backgroundColor;

  const StatisticCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.onTap,
    this.isLoading = false,
    this.subtitle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),

      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05)
          )
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP ROW
            Row(
              children: [
                // CARD ICON
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withValues(
                      alpha: 0.15,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.primary,
                    size: 24,
                  ),
                ),

                const Spacer(),

                // ... ICON
                Icon(Icons.chevron_right_rounded, size: 14, color: Colors.grey),
              ],
            ),
            const Spacer(),

            // Loading Spinner
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            else
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 6),

            // Title
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





// Container
// │
// └── Padding
//      │
//      └── Column
//           │
//           ├── Row
//           │     ├── Icon
//           │     └── Spacer()
//           │
//           ├── Spacer()
//           │
//           ├── Text(value)
//           │
//           └── Text(title)