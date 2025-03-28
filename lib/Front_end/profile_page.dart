import 'package:agriplant/Front_end/Saved.dart';
import 'package:agriplant/Front_end/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int followersCount = 0;
  int followingCount = 0;
  String username = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String userId = _auth.currentUser!.uid;

    DocumentSnapshot userDoc = await _firestore.collection("Users").doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        followersCount = (userDoc["followers"] as List<dynamic>?)?.length ?? 0;
        followingCount = (userDoc["following"] as List<dynamic>?)?.length ?? 0;
        username = userDoc["first_name"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 54, bottom: 16),
            child: CircleAvatar(
              radius: 93,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage("assets/Profil.jpg"),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Text(
                  username, // ✅ عرض اسم المستخدم الفعلي
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("$followersCount", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text("Followers"),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Text("$followingCount", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text("Following"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ListTile(
            leading: Icon(IconlyBold.bookmark, color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
            title: Text('Saved', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Saved()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_sharp, color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
            title: Text('Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_sharp, color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
            title: Text('Log out', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil("login_page", (route) => false);
            },
          ),
          ListTile(
            title: const Text("About Us"),
            leading: Icon(Icons.info_outline_rounded, color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
