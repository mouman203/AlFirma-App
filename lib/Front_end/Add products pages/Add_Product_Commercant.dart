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
      appBar: AppBar(title: Text('Je suis un commercant')),
      body: Center(
        child: Text('Ajouter un produit'),
      ),
    );
  }
}
