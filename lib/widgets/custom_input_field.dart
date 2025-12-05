
import 'package:flutter/material.dart';

// ===================== WIDGET INPUT FIELD =====================

class CustomInputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final TextInputType keyboardType;
  final TextEditingController controller;



  const CustomInputField({
    super.key,
    required this.icon,
    required this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    required this.controller,

  });

  @override
  Widget build(BuildContext context) {

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
              prefixIcon: Icon(icon,size: 22),
              labelText: hint,
              border: InputBorder.none

          ),
        ),
      );
    }

}
