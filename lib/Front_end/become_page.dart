import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BecomePage extends StatefulWidget {
  const BecomePage({super.key});

  @override
  State<BecomePage> createState() => _BecomePageState();
}

class _BecomePageState extends State<BecomePage> {
  final List<String> userTypes = [
    'Agriculteur',
    'Éleveur',
    'Expert Agri',
    'Vétérinaire',
    'Commerçant',
    'Entreprise',
    'Transporteur',
    'Reparateur'
  ];

  void addUserType(String userType) async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get the logged-in user
      if (user != null) {
        String userId = user.uid; // Get UID
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          'userType': userType,
          'user-type-updated-At': FieldValue.serverTimestamp(),
        });
        print("User type updated successfully!");
      } else {
        print("No user is logged in!");
      }
    } catch (e) {
      print("Error updating user type: $e");
    }
  }

  void showSuccessPopup(BuildContext context, String? type) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("🎉 Congratulations!"),
            content: Text("Yeeey! You are now $type !"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // Light green background
      appBar: AppBar(title: Text('Choisissez votre type')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.5, // Adjust height-to-width ratio
          ),
          itemCount: userTypes.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Handle user selection here
                addUserType(
                    userTypes[index]); // Store the selected type in Firestore

                print("Selected: ${userTypes[index]}");
                showSuccessPopup(context, userTypes[index]);
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: Center(
                  child: Text(
                    userTypes[index],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
