import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(text,
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}