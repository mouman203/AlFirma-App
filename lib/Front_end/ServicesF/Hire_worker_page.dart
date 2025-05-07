import 'package:flutter/material.dart';

class HireWorkerPage extends StatelessWidget {
  const HireWorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hire Workers'),
      elevation: 5,),
      body: const Center(child: Text('Hire Workers')),
    );
  }
}
