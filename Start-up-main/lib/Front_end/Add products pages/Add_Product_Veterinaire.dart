import 'package:flutter/material.dart';

class AddProductVeterinaire extends StatefulWidget {
  const AddProductVeterinaire({super.key});

  @override
  State<AddProductVeterinaire> createState() => _AddProductVeterinaireState();
}

class _AddProductVeterinaireState extends State<AddProductVeterinaire> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Je suis un veterinaire')),
      body: Center(
        child: Text('Ajouter un produit'),
      ),
    );
  }
}
