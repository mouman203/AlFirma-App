import 'package:flutter/material.dart';

class AddProductClient extends StatefulWidget {
  const AddProductClient({super.key});

  @override
  State<AddProductClient> createState() => _AddProductClientState();
}

class _AddProductClientState extends State<AddProductClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Je suis un client')),
      body: const Center(
        child: Text('u cant add anything'),
      ),
    );
  }
}
