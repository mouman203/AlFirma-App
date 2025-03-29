import 'package:flutter/material.dart';

class AddProductExpert extends StatefulWidget {
  const AddProductExpert({super.key});

  @override
  State<AddProductExpert> createState() => _AddProductExpertState();
}

class _AddProductExpertState extends State<AddProductExpert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Je suis un expert')),
      body: Center(
        child: Text('Ajouter un produit'),
      ),
    );
  }
}