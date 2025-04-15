import 'package:agriplant/Front_end/Edit_profile_page.dart';
import 'package:agriplant/Front_end/Saved.dart';
import 'package:agriplant/Front_end/settings.dart';
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
  String? profilePic;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String userId = _auth.currentUser!.uid;

    DocumentSnapshot userDoc =
        await _firestore.collection("Users").doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        followersCount = (userDoc["followers"] as List<dynamic>?)?.length ?? 0;
        followingCount = (userDoc["following"] as List<dynamic>?)?.length ?? 0;
        username = userDoc["first_name"];
        profilePic = userDoc["photo"] ;
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
              backgroundColor: isDarkMode
                    ? const Color(0xFF273930)
                    : const Color(0xFF256C4C),
              child: CircleAvatar(
                radius: 90,
                backgroundImage: profilePic != null
                    ? NetworkImage(profilePic!)
                    :  isDarkMode ? const AssetImage("assets/anonymeD.png") as ImageProvider :  const AssetImage("assets/anonyme.png") as ImageProvider,
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
                        Text("$followersCount",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text("Followers"),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Text("$followingCount",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text("Following"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          //edit profile
          ListTile(
            leading: Icon(Icons.edit,
                color: isDarkMode
                    ? Colors.white
                    : const Color(0xFF256C4C)),
            title: const Text('Edit Profile'),
            trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode
                    ? Colors.white
                    : const Color(0xFF256C4C)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()),
              );
            },
          ),
          
          ListTile(
            leading: Icon(IconlyBold.bookmark,
                color: isDarkMode
                    ? Colors.white
                    : const Color(0xFF256C4C)),
            title: Text('Saved',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                    trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode
                    ? Colors.white
                    : const Color(0xFF256C4C)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Saved()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_sharp,
                color: isDarkMode
                    ? Colors.white
                    : const Color(0xFF256C4C)),
            title: Text('Settings',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                    trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode
                    ? Colors.white
                    : const Color(0xFF256C4C)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_sharp,
                color: isDarkMode
                    ? Colors.white
                    : const Color(0xFF256C4C)),
            title: Text('Log out',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                    trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode
                    ? Colors.white
                    : const Color(0xFF256C4C)),
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
            leading: Icon(Icons.info_outline_rounded,
                color: isDarkMode
                    ? Colors.white
                    : const Color(0xFF256C4C)),
                    trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode
                    ? Colors.white
                    : const Color(0xFF256C4C)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
