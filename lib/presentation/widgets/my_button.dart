import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.fColor,
    required this.bColor,
    required this.name,
    required this.onPressed,
  });
  final Color fColor;
  final Color bColor;
  final String name;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0.3,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: bColor,
        foregroundColor: fColor,
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 15,
        ),
      ),
    );
  }
}
