import 'package:flutter/material.dart';

class AddProductReparateur extends StatefulWidget {
  const AddProductReparateur({super.key});

  @override
  State<AddProductReparateur> createState() => _AddProductReparateurState();
}

class _AddProductReparateurState extends State<AddProductReparateur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Je suis un reparateur')),
      body: Center(
        child: Text('Ajouter un produit'),
      ),
    );
  }
}
