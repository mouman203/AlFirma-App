import 'package:flutter/material.dart';

class AddProductEleveur extends StatefulWidget {
  const AddProductEleveur({super.key});

  @override
  State<AddProductEleveur> createState() => _AddProductEleveurState();
}

class _AddProductEleveurState extends State<AddProductEleveur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Je suis un Eleveur')),
      body: Center(
        child: Text('Ajouter un produit'),
      ),
    );
  }
}
