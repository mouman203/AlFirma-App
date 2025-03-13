import 'package:agriplant/pages/Settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Contact_us_page extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<Contact_us_page> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();

  /// 🔹 Send Email Using EmailJS API
  Future<void> sendEmail(String userName,String userEmail, String subject, String message) async {
    const String serviceId =
        "service_9ih5d5t"; // 🔥 Replace with your EmailJS Service ID
    const String templateId =
        "template_key4pbx"; // 🔥 Replace with your EmailJS Template ID
    const String userPublicKey =
        "GQDDMi8Lddg4RPJkl"; // 🔥 Replace with your EmailJS Public Key

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
        SnackBar(content: Text("Email sent successfully! ✅"),
        duration: Duration(seconds: 2),
        ),
      );
       await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Settings()),
      );
    } else {
      print("❌ Error: Failed to send email - ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending email ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Your Problem"),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 55, 72, 56)  // Dark green in dark mode
            : const Color.fromARGB(255, 42, 103, 34),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Your Name",
                labelStyle: TextStyle(
      color: isDarkMode 
          ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode 
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode 
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
        width: 2.0, // Optional: makes it more prominent when focused
      ),
    ),
  ),
              ),
            
            const SizedBox(height: 15),
            TextField(
  style: TextStyle(
    fontSize: 17,
    color: isDarkMode 
        ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
  ),
  controller: _emailController,
  decoration: InputDecoration(
    labelText: "Your Email",
    labelStyle: TextStyle(
      color: isDarkMode 
          ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode 
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode 
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
        width: 2.0, // Optional: makes it more prominent when focused
      ),
    ),
  ),
),

            const SizedBox(height: 15),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: "Subject",
                labelStyle: TextStyle(
      color: isDarkMode 
          ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode 
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode 
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
        width: 2.0, // Optional: makes it more prominent when focused
      ),
    ),
  ),
              ),
           
            const SizedBox(height: 15),
            TextField(
              controller: _reportController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: "Describe your problem",
                labelStyle: TextStyle(
      color: isDarkMode 
          ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode 
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode 
            ? Colors.white // white in dark mode
        : const Color.fromARGB(255, 42, 103, 34), // Green in light mode
        width: 2.0, // Optional: makes it more prominent when focused
      ),
    ),
  ),

                
              ),
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String userName =  _nameController.text;
                  String userEmail = _emailController.text;
                  String subject = _subjectController.text;
                  String message = _reportController.text;

                  if (userName.isNotEmpty &&
                      userEmail.isNotEmpty &&
                      subject.isNotEmpty &&
                      message.isNotEmpty) {
                    await sendEmail(userName,userEmail, subject, message);
                  } else {
                    print("❌ Error: Please fill all fields.");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill all fields ⚠️")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 55, 72, 56)  // Dark green in dark mode
            : const Color.fromARGB(255, 44, 107, 36),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text( "Send Report", style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white // White in dark mode
                  : Colors.black, // Black in light mode
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
