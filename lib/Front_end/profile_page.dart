import 'package:agriplant/Front_end/Saved.dart';
import 'package:agriplant/Front_end/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  //final user = FirebaseAuth.instance.currentUser!;
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 54 , bottom: 26),
            child: CircleAvatar(
              radius: 93,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage( "assets/Profil.jpg"),

              ),
            ),
          ),
          Center(
            child: Text(
              "Jessi Williams",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 40),
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
                  MaterialPageRoute(builder: (context) => const Saved()),
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
                  MaterialPageRoute(builder: (context) => const Settings()),
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
    );
  }
}
