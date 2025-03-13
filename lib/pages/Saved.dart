import 'package:flutter/material.dart';

class Saved extends StatelessWidget {
 
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Saved'),
      backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 55, 72, 56)  // Dark green in dark mode
            : const Color.fromARGB(255, 42, 103, 34),
      ),
      
    );
  }
}