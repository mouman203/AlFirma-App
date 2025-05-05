import 'package:agriplant/Back_end/ServicesB/ExpertiseService.dart';
import 'package:agriplant/Back_end/Products/ProductAgri.dart';
import 'package:agriplant/Back_end/Products/ProductElev.dart';
import 'package:agriplant/Back_end/ServicesB/RepairService.dart';
import 'package:agriplant/Back_end/ServicesB/TransportService.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:agriplant/widgets_UI/Item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

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

    final agriSnap = await firestore
        .collection('Products')
        .doc('Agricol_products')
        .collection('Agricol_products')
        .where('ownerId', isEqualTo: userId)
        .get();
    final agriProducts = agriSnap.docs.map(Productagri.fromFirestore).toList();

    final elevSnap = await firestore
        .collection('Products')
        .doc('Eleveur_products')
        .collection('Eleveur_products')
        .where('ownerId', isEqualTo: userId)
        .get();
    final elevProducts = elevSnap.docs.map(ProductElev.fromFirestore).toList();

    final expertiseSnap = await firestore
        .collection('Services')
        .doc('Expertise')
        .collection('Expertise')
        .where('ownerId', isEqualTo: userId)
        .get();
    final expertiseServices =
        expertiseSnap.docs.map(ExpertiseService.fromFirestore).toList();

    final repairSnap = await firestore
        .collection('Services')
        .doc('Repairs')
        .collection('Repairs')
        .where('ownerId', isEqualTo: userId)
        .get();
    final repairServices =
        repairSnap.docs.map(RepairService.fromFirestore).toList();

    final transportSnap = await firestore
        .collection('Services')
        .doc('Transportation')
        .collection('Transportation')
        .where('ownerId', isEqualTo: userId)
        .get();
    final transportServices =
        transportSnap.docs.map(TransportService.fromFirestore).toList();

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 28,
            color:
                isDarkMode ? const Color(0xFF90D5AE) : const Color(0xFF256C4C),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 93,
              backgroundColor: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C),
              child: CircleAvatar(
                radius: 90,
                backgroundImage: profilePic.isNotEmpty
                    ? NetworkImage(profilePic)
                    : (isDarkMode
                            ? const AssetImage("assets/anonymeD.png")
                            : const AssetImage("assets/anonyme.png"))
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 16),
            Text(username, style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 13),
           
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
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!Users.isGuestUser()) ...[
                    SizedBox(
                      width: 140,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _toggleFollow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFollowing
                              ? Colors.red
                              : isDarkMode
                                  ? const Color(0xFF90D5AE)
                                  : const Color(0xFF256C4C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isFollowing ? "Unfollow" : "Follow",
                          style: TextStyle(
                              color: isDarkMode ? Colors.black : Colors.white,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 140,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(receiverId: widget.userId),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Icon(
                          IconlyBold.message,
                          size: 30,
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 25),
            DefaultTabController(
              length: 1,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      const Tab(
                        icon: Icon(
                          IconlyBold.category,
                          size: 32,
                        ),
                      ),
                    ],
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      insets: const EdgeInsets.symmetric(horizontal: 50.0),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 500,
                    child: TabBarView(
                      children: [
                        FutureBuilder<List<Object>>(
                          future: fetchAllUserItems(widget.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text("No items yet."));
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
                                crossAxisSpacing: 9,
                                mainAxisSpacing: 2,
                              ),
                              itemBuilder: (context, index) {
                                return ItemCard(item: itemList[index]);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
