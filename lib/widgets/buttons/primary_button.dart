import 'package:flutter/material.dart';
import 'package:navni_sangraha/core/app_colors.dart';
import 'package:navni_sangraha/core/app_gradient.dart';

enum ButtonType { primary, secondary, danger }

class PrimaryButton extends StatelessWidget {
  // Content
  final String text;
  final IconData? icon;
  // Behaviour
  final VoidCallback? onPressed;
  final bool isLoading;
  // Appearance
  final ButtonType type;

  const PrimaryButton({
    super.key,
    required this.text,
    this.type = ButtonType.primary,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Switch to decide color
    final bgGradient = switch (type) {
      ButtonType.primary => AppGradients.primary,
      ButtonType.secondary => AppGradients.secondary,
      ButtonType.danger => AppGradients.danger,
    };

    return Container(
      decoration: BoxDecoration(
        gradient: bgGradient,
        borderRadius: BorderRadius.circular(16)
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
      
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(16),
            // ),
          ),
      
          child: isLoading
              ? const SizedBox(width:22, height:22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: 20,),
                      const SizedBox(width: 8),
                    ] else ...[
                      const SizedBox(width: 0, height: 0),
                    ],
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/*
  When you write:

  ElevatedButton(
    onPressed: onPressed,
  )

  you're saying:

  "Flutter, when this button is tapped, call the function stored in onPressed."

  You are handing the function over to ElevatedButton.
*/
