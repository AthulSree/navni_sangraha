import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  // initialising variable to final
  final String label;
  final String hint;
  final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Displaying the Label
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 204, 203, 203),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        // 2. Adding space between label and textfield
        SizedBox(height: 8),

        // 3. Displaying the Text Field with Hint
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(

            hintText: hint,

            hintStyle: const TextStyle(color: Colors.grey),

            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,

            filled: true,

            fillColor: Color(0xFF1A1A22),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
            ),
            
          ),
        ),
      ],
    );
  }
}

/*********************************************************
 * What does required this.label mean?
 * Suppose someone writes:
 *   CustomTextField();
 * Flutter won't know what to display.
 * Instead, we force the developer to provide values.
 * Like this:
 * CustomTextField(
 *     label: "Username",
 *     hint: "Enter username",
 * )
 * This makes your widget reusable.
 *********************************************************/
