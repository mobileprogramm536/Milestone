import 'package:flutter/material.dart';

class CurvedFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String assetPath; // Path to the image file

  const CurvedFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.assetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero, // Remove extra padding
      shape:
          const CircleBorder(), // Ensure the button is circular (optional, depends on the PNG shape)
      child: Image.asset(
        assetPath, // Display the PNG directly
        fit: BoxFit.contain,
        width: 40, // Size of the button
        height: 60,
      ),
    );
  }
}
