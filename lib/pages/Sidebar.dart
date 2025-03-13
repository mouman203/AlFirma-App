import 'package:agriplant/pages/Settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Saved.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Container(
        color: isDarkMode
            ? const Color.fromARGB(255, 55, 72, 56)  // Dark green in dark mode
            : Colors.green.shade50, // Light green in light mode
        child: ListView(
          children: [
            ListTile(
              leading: Icon(IconlyBold.bookmark, 
                  color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
              title: Text(
                'Saved',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Saved()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_sharp, 
                  color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
              title: Text(
                'Settings',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_sharp, 
                  color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
              title: Text(
                'Log out',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login_page", (route) => false);
              },
            ),
            ListTile(
            title: const Text("About Us"),
            leading: Icon(Icons.info_outline_rounded,color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
            onTap: () {},
          ),
          ],
        ),
      ),
    );
  }
}
