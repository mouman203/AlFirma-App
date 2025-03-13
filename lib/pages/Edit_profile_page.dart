import 'package:flutter/material.dart';

class Edit_profile_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'),
      backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 55, 72, 56)  // Dark green in dark mode
            : const Color.fromARGB(255, 42, 103, 34),
      ),
      
    );
  }
}