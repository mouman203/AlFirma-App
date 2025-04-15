import 'package:flutter/material.dart';

class AddProductCommercant extends StatefulWidget {
  const AddProductCommercant({super.key});

  @override
  State<AddProductCommercant> createState() => _AddProductCommercantState();
}

class _AddProductCommercantState extends State<AddProductCommercant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Je suis un commercant')),
      body: const Center(
        child: Text('mm hada yek y demander brk'),
      ),
    );
  }
}
