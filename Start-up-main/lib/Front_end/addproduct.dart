import 'package:flutter/material.dart';

//hadi mat5altouch fiha yarhem waldiko;)
class Addproduct extends StatelessWidget {
  const Addproduct({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("You can't add a product for now."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("OK"),
        ),
      ],
    );
  }
}
