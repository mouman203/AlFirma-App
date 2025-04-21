import 'package:flutter/material.dart';

class HireWorkerPage extends StatelessWidget {
  const HireWorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hire Worker'),
      elevation: 5,),
      body: const Center(child: Text('Hire Worker Service Page')),
    );
  }
}
