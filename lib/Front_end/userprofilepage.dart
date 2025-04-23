import 'package:agriplant/Back_end/ExpertiseService.dart';
import 'package:agriplant/Back_end/ProductAgri.dart';
import 'package:agriplant/Back_end/ProductElev.dart';
import 'package:agriplant/Back_end/RepairService.dart';
import 'package:agriplant/Back_end/TransportService.dart';
import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:agriplant/widgets_UI/Item_card.dart';
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
  String role = "";
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
    DocumentSnapshot userDoc =
        await _firestore.collection("Users").doc(widget.userId).get();

    if (userDoc.exists) {
      List<dynamic> followers = userDoc["followers"] ?? [];
      setState(() {
        username = userDoc["first_name"] ?? "Unknown";
        followersCount = followers.length;
        isFollowing = followers.contains(currentUserId);
        profilePic = userDoc["photo"] ?? "";
        role = userDoc["activeType"] ?? "Unknown";
      });
    }
  }

  Future<void> _toggleFollow() async {
    String currentUserId = _auth.currentUser!.uid;
    DocumentReference userRef =
        _firestore.collection("Users").doc(widget.userId);
    DocumentReference currentUserRef =
        _firestore.collection("Users").doc(currentUserId);

    if (isFollowing) {
      await userRef.update({
        "followers": FieldValue.arrayRemove([currentUserId])
      });
      await currentUserRef.update({
        "following": FieldValue.arrayRemove([widget.userId])
      });
      setState(() {
        isFollowing = false;
        followersCount--;
      });
    } else {
      await userRef.update({
        "followers": FieldValue.arrayUnion([currentUserId])
      });
      await currentUserRef.update({
        "following": FieldValue.arrayUnion([widget.userId])
      });
      setState(() {
        isFollowing = true;
        followersCount++;
      });
    }
  }

 Future<List<Object>> fetchAllUserItems(String userId) async {
  final firestore = FirebaseFirestore.instance;

  // Fetch Agricol Products
  final agriSnap = await firestore
      .collection('Products')
      .doc('Agricol_products')
      .collection('Agricol_products')
      .where('ownerId', isEqualTo: userId)
      .get();
  final agriProducts =
      agriSnap.docs.map(Productagri.fromFirestore).toList();

  // Fetch Eleveur Products
  final elevSnap = await firestore
      .collection('Products')
      .doc('Eleveur_products')
      .collection('Eleveur_products')
      .where('ownerId', isEqualTo: userId)
      .get();
  final elevProducts =
      elevSnap.docs.map(ProductElev.fromFirestore).toList();

  // Fetch Expertise Services
  final expertiseSnap = await firestore
      .collection('Services')
      .doc('Expertise')
      .collection('Expertise')
      .where('ownerId', isEqualTo: userId)
      .get();
  final expertiseServices =
      expertiseSnap.docs.map(ExpertiseService.fromFirestore).toList();

  // Fetch Repair Services
  final repairSnap = await firestore
      .collection('Services')
      .doc('Repairs')
      .collection('Repairs')
      .where('ownerId', isEqualTo: userId)
      .get();
  final repairServices =
      repairSnap.docs.map(RepairService.fromFirestore).toList();

  // Fetch Transport Services
  final transportSnap = await firestore
      .collection('Services')
      .doc('Transportation')
      .collection('Transportation')
      .where('ownerId', isEqualTo: userId)
      .get();
  final transportServices =
      transportSnap.docs.map(TransportService.fromFirestore).toList();

  // Combine all items into one list
  return [
    ...agriProducts,
    ...elevProducts,
    ...expertiseServices,
    ...repairServices,
    ...transportServices,
  ];
}

  @override
  Widget build(BuildContext context) {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text("$username ($role)")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //the profile pic and the name of the user
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8,top: 8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.secondaryContainer,
                    ],
                    stops: [
                      0.0,
                      1.0
                    ], // 50% الأول للون الأول، والباقي للون الثاني
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 16),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: profilePic.isNotEmpty
                            ? NetworkImage(profilePic)
                            : null,
                        child: profilePic.isEmpty
                            ? const Icon(Icons.person, size: 60)
                            : null,
                      ),
                    ),
                    Text(username,
                        style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("$followersCount",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Followers",
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Text("$followingCount",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Following",
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    //the bottoms of follow and contact
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _toggleFollow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFollowing
                                  ? Colors.red
                                  : const Color.fromARGB(255, 47, 114, 38),
                            ),
                            child: Text(
                              isFollowing ? "Unfollow" : "Follow",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatPage(receiverId: widget.userId),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.message,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
        
            //the products of the user
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8,bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.secondaryContainer,
                      Theme.of(context).colorScheme.primaryContainer,
                    ],
                    stops: [
                      0.0,
                      0.4
                    ], // 50% الأول للون الأول، والباقي للون الثاني
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        "Items",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<List<Object>>(
                          future: fetchAllUserItems(widget.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
            
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text(
                                  "There are not items for $username yet.",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey));
                            }
            
                            final itemList = snapshot.data!;
            
                            return GridView.builder(
                              itemCount: itemList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (context, index) {
                                return ItemCard(item: itemList[index]);
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
