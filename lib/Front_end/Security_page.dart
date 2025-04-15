import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  String? email;
  String? phone;

  // Show dialog to update email and phone num
  void Email_PhoneUpdateDialog(String val, context) {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: val == "Email"
              ? const Text("Update Email")
              : const Text("Update Phone Number"),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText:
                  val == "Email" ? "Enter new email" : "Enter new Phone num",
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close dialog
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

//show email and phone num options
  void Email_PhoneOptions(String val) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: val == "Email"
              ? const Text("Email Options")
              : const Text("Phone Number Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.edit, color: Color.fromARGB(255, 42, 103, 34)),
                title: val == "Email"
                    ? const Text("Change Email")
                    : const Text("Change Phone Number"),
                onTap: () {
                  Navigator.pop(context);
                  val == "Email"
                      ? Email_PhoneUpdateDialog("Email", context)
                      : Email_PhoneUpdateDialog("Phone", context);
                  print("hello");
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: val == "Email"
                    ? const Text("Delete Email")
                    : const Text("Delete Phone Number"),
                onTap: () {
                  Navigator.pop(context);
                  val == "Email"
                      ? _showDeletingAccMsg("Email")
                      : _showDeletingAccMsg("Phone Number");
                  print("hello");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //show changing password
  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Change Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Old Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Add space between the text fields
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Add space between the text fields
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  //show deleting Account msg
  void _showDeletingAccMsg(String val) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text(
              'Attention ⚠️',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red, // Optional: You can change the text color
              ),
            ),
            content: val == "Account"
                ? const Text(
                    'Are you sure you want to delete this account?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors
                          .black, // Optional: You can change the text color
                    ),
                  )
                : Text(
                    'Are you sure you want to delete the $val ?',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors
                          .black, // Optional: You can change the text color
                    ),
                  ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("Users").doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        email = userDoc["email"];
        phone = userDoc["phone"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Security Settings"),
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Profile Image on the Left
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/Security.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Text and Security Level Card on the Right
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const ListTile(
                          title: Text(
                              "Enable multiple autherntification methods to enhace your account security"),
                        ),

                        // Small Card for Security Level
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Card(
                            color: Colors
                                .orange.shade100, // Change color based on level
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Text(
                                "Medium Security", // Change dynamically
                                style: TextStyle(
                                  color: Colors.orange.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 30,
          ),
          //authentication card
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              "Contact Information",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900),
            ),
          ),

          Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email,
                      color: Color.fromARGB(255, 42, 103, 34)),
                  title: const Text("email"),
                  subtitle: Text("$email"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Email_PhoneOptions("Email"),
                ),
                ListTile(
                  leading: const Icon(Icons.phone,
                      color: Color.fromARGB(255, 42, 103, 34)),
                  title: const Text("Phone"),
                  subtitle: Text("$phone"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Email_PhoneOptions("Phone"),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 30,
          ),

          //security card
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              "Security Card",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900),
            ),
          ),

          Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock,
                      color: Color.fromARGB(255, 42, 103, 34)),
                  title: const Text("Change Password"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _showChangePasswordDialog,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),

          //account management card
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              "Account Management",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900),
            ),
          ),

          Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text("Delete Account"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showDeletingAccMsg("Account"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
