import 'package:flutter/material.dart';

class AddProductEntreprise extends StatefulWidget {
  const AddProductEntreprise({super.key});

  @override
  State<AddProductEntreprise> createState() => _AddProductEntrepriseState();
}

class _AddProductEntrepriseState extends State<AddProductEntreprise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Je suis une entreprise')),
      body: Center(
        child: Text('yek nrmlm l entreprise t demander brk '),
      ),
    );
  }
}
