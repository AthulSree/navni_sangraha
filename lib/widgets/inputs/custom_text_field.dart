import 'package:flutter/material.dart';
import 'package:navni_sangraha/core/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Displaying the Label
        Text(
          widget.label,
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
          controller: widget.controller,
          obscureText: widget.isPassword ? isObscured : false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(

            hintText: widget.hint,

            hintStyle: const TextStyle(color: Colors.grey),

            prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: Colors.grey,) : null,

            filled: true,

            fillColor: AppColors.surface,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

            suffixIcon: widget.isPassword ? IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: (){
                setState(() {
                  isObscured = !isObscured;
                });
              },
            ) : null,
          ),
        ),
      ],
    );
  }
}

/*
We no longer write
  label
Instead we write
  widget.label
Why?
Because label belongs to the CustomTextField widget.
The State object accesses it through the widget property.
*/
