import 'package:agriplant/Front_end/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class Contact_us_page extends StatefulWidget {
  const Contact_us_page({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<Contact_us_page> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();
  bool isLoading = true;

  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc['first_name'] ?? '';
          _emailController.text = user.email ?? '';
          isLoading = false;
        });
      }
    }
  }

  /// 🔹 Send Email Using EmailJS API
  Future<void> sendEmail(
      String userName, String userEmail, String subject, String message) async {
    const String serviceId =
        "service_9ih5d5t"; // Replace with your EmailJS Service ID
    const String templateId =
        "template_key4pbx"; // Replace with your EmailJS Template ID
    const String userPublicKey =
        "GQDDMi8Lddg4RPJkl"; // Replace with your EmailJS Public Key

    final Uri url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

    final Map<String, dynamic> emailData = {
      "service_id": serviceId,
      "template_id": templateId,
      "user_id": userPublicKey,
      "template_params": {
        "user_name": userName,
        "user_email": userEmail,
        "subject": subject,
        "message": message
      }
    };

    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        "Content-Type": "application/json",
      },
      body: jsonEncode(emailData),
    );

    if (response.statusCode == 200) {
      print("✅ Success: Email sent successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Email sent successfully! ✅"),
            duration: Duration(seconds: 2)),
      );
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SettingsPage()));
    } else {
      print("❌ Error: Failed to send email - ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error sending email ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Your Problem"),
        backgroundColor: isDarkMode ? colorScheme.surface : colorScheme.surface,
        elevation: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            TextField(
              style: TextStyle(
                  fontSize: 19,
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
              controller: _emailController,
              readOnly: true, // Make email field non-editable
              decoration: InputDecoration(
                labelText: "Your Email",
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              style: TextStyle(
                  fontSize: 19,
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
              controller: _nameController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Your Name",
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              ),
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: "Subject",
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              ),
              controller: _reportController,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: "Describe your problem",
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await sendEmail(_nameController.text, _emailController.text,
                      _subjectController.text, _reportController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? const Color(0xFF90D5AE)
                      : const Color(0xFF256C4C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text("Send Report",
                    style: TextStyle(
                        fontSize: 22,
                        color: isDarkMode ? Colors.black : Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
