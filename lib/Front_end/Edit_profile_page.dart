import 'package:flutter/material.dart';

class Edit_profile_page extends StatelessWidget {
  const Edit_profile_page({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'),
      backgroundColor: isDarkMode ? colorScheme.surface : colorScheme.surface,
      ),
      
    );
  }
}