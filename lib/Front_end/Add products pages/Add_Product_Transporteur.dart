import 'package:flutter/material.dart';

class AddProductTransporteur extends StatefulWidget {
  const AddProductTransporteur({super.key});

  @override
  State<AddProductTransporteur> createState() => _AddProductTransporteurState();
}

class _AddProductTransporteurState extends State<AddProductTransporteur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Je suis un transporteur')),
      body: Center(
        child: Text('Ajouter un produit'),
      ),
    );
  }
}
