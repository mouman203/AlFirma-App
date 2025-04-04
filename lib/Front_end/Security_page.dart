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
    TextEditingController _emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: val == "Email"
              ? Text("Update Email")
              : Text("Update Phone Number"),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText:
                  val == "Email" ? "Enter new email" : "Enter new Phone num",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close dialog
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                
                Navigator.pop(context);
              },
              child: Text("Submit"),
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
              ? Text("Email Options")
              : Text("Phone Number Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    Icon(Icons.edit, color: Color.fromARGB(255, 42, 103, 34)),
                title: val == "Email"
                    ? Text("Change Email")
                    : Text("Change Phone Number"),
                onTap: () {
                  Navigator.pop(context);
                  val == "Email"
                      ? Email_PhoneUpdateDialog("Email", context)
                      : Email_PhoneUpdateDialog("Phone", context);
                  print("hello");
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: val == "Email"
                    ? Text("Delete Email")
                    : Text("Delete Phone Number"),
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
          title: Text("Change Password"),
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
              SizedBox(height: 10), // Add space between the text fields
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10), // Add space between the text fields
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
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () { Navigator.pop(context);},
              child: Text("Submit"),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text(
                  'Attention ⚠️',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        Colors.red, // Optional: You can change the text color
                  ),
                ),
                content: val == "Account" ? Text(
                  'Are you sure you want to delete this account?',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        Colors.black, // Optional: You can change the text color
                  ),
                ):Text(
                  'Are you sure you want to delete the $val ?',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        Colors.black, // Optional: You can change the text color
                  ),
                ),actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () { Navigator.pop(context);},
                    child: Text("Submit"),
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
                        ListTile(
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

          SizedBox(
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
                  leading: Icon(Icons.email,
                      color: Color.fromARGB(255, 42, 103, 34)),
                  title: Text("email"),
                  subtitle: Text("$email"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => Email_PhoneOptions("Email"),
                ),
                ListTile(
                  leading: Icon(Icons.phone,
                      color: const Color.fromARGB(255, 42, 103, 34)),
                  title: Text("Phone"),
                  subtitle: Text("$phone"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => Email_PhoneOptions("Phone"),
                ),
              ],
            ),
          ),

          SizedBox(
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
                  leading: Icon(Icons.lock,
                      color: const Color.fromARGB(255, 42, 103, 34)),
                  title: Text("Change Password"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: _showChangePasswordDialog,
                ),
              ],
            ),
          ),
          SizedBox(
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
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text("Delete Account"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap:()=>_showDeletingAccMsg("Account"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
