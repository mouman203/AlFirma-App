import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final String userId; // ✅ معرف المستخدم الذي نريد عرض ملفه الشخصي

  const UserProfilePage({super.key, required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String username = "Loading...";
  String profilePic = "";
  int followersCount = 0;
  int followingCount = 0;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String currentUserId = _auth.currentUser!.uid;
    DocumentSnapshot userDoc = await _firestore.collection("Users").doc(widget.userId).get();

    if (userDoc.exists) {
      List<dynamic> followers = userDoc["followers"] ?? [];
      setState(() {
        username = userDoc["first_name"] ?? "Unknown";
        followersCount = followers.length;
        followingCount = (userDoc["following"] as List<dynamic>?)?.length ?? 0;
        isFollowing = followers.contains(currentUserId);
      });
    }
  }

  Future<void> _toggleFollow() async {
    String currentUserId = _auth.currentUser!.uid;
    DocumentReference userRef = _firestore.collection("Users").doc(widget.userId);
    DocumentReference currentUserRef = _firestore.collection("Users").doc(currentUserId);

    if (isFollowing) {
      await userRef.update({"followers": FieldValue.arrayRemove([currentUserId])});
      await currentUserRef.update({"following": FieldValue.arrayRemove([widget.userId])});
      setState(() {
        isFollowing = false;
        followersCount--;
      });
    } else {
      await userRef.update({"followers": FieldValue.arrayUnion([currentUserId])});
      await currentUserRef.update({"following": FieldValue.arrayUnion([widget.userId])});
      setState(() {
        isFollowing = true;
        followersCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(username)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: profilePic.isNotEmpty ? NetworkImage(profilePic) : null,
              child: profilePic.isEmpty ? const Icon(Icons.person, size: 60) : null,
            ),
          ),
          Text(username, style: Theme.of(context).textTheme.headlineSmall),
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _toggleFollow,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowing ? Colors.red : Colors.green,
            ),
            child: Text(isFollowing ? "Unfollow" : "Follow"),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(receiverId: widget.userId),
                ),
              );
            },
            icon: const Icon(Icons.message),
            label: const Text("Send Message"),
          ),
        ],
      ),
    );
  }
}
