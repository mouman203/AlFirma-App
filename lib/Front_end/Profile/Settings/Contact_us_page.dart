import 'package:agriplant/Front_end/Profile/Settings/settings.dart';
import 'package:agriplant/generated/l10n.dart';
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

  @override
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
        "service_4nv1lsu"; // Replace with your EmailJS Service ID
    const String templateId =
        "template_w2m37zg"; // Replace with your EmailJS Template ID
    const String userPublicKey =
        "8975FA9hs_OdLRAIT"; // Replace with your EmailJS Public Key

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
        SnackBar(
          backgroundColor: Color.fromARGB(255, 54, 126, 44), // Green background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 1),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  S.of(context).emailSentSuccess,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SettingsPage()));
    } else {
      print("❌ Error: Failed to send email - ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 1),
          content: Row(
            children: [
              const Icon(Icons.warning_amber_outlined, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  S.of(context).emailSendError,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Create a reusable method for TextFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool readOnly = false,
    int maxLines = 1,
    bool boldItalicStyle = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      style: TextStyle(
        fontSize: boldItalicStyle ? 20 : 18,
        color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
        fontWeight: boldItalicStyle ? FontWeight.w600 : FontWeight.normal,
        fontStyle: FontStyle.normal,
      ),
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          icon,
          color: isDarkMode ? Colors.white70 : const Color(0xFF256C4C),
          size: 22,
        ),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : const Color(0xFF256C4C),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // 👈 Rounded edges
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white54 : const Color(0xFF256C4C),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white54 : const Color(0xFF256C4C),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
            width: 2.5,
          ),
        ),
        filled: true,
        fillColor: isDarkMode 
            ? Colors.grey[850]?.withOpacity(0.3) 
            : Colors.grey[50]?.withOpacity(0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.support_agent,
              color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              S.of(context).reportAProblem,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: isDarkMode ? colorScheme.surface : colorScheme.surface,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            _buildTextField(
              controller: _emailController,
              labelText: S.of(context).yourEmail,
              icon: Icons.email_outlined,
              readOnly: true,
              boldItalicStyle: true,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _nameController,
              labelText: S.of(context).yourName,
              icon: Icons.person_outline,
              readOnly: true,
              boldItalicStyle: true,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _subjectController,
              labelText: S.of(context).subject,
              icon: Icons.subject_outlined,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _reportController,
              labelText: S.of(context).describeProblem,
              icon: Icons.description_outlined,
              maxLines: 10,
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await sendEmail(
                    _nameController.text,
                    _emailController.text,
                    _subjectController.text,
                    _reportController.text,
                  );
                },
                icon: Icon(
                  Icons.send_outlined,
                  color: isDarkMode ? Colors.black : Colors.white,
                  size: 20,
                ),
                label: Text(
                  S.of(context).sendReport,
                  style: TextStyle(
                    fontSize: 22,
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? const Color(0xFF90D5AE)
                      : const Color(0xFF256C4C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}