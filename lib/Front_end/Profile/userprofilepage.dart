import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/generated/l10n.dart';
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

  Future<List<Products>> fetchAllUserItems(String userId) async {
    final firestore = FirebaseFirestore.instance;

// ===================================Fetching products===================================

    final productSnap = await firestore
        .collection('item')
        .doc('Products')
        .collection('Products')
        .where('ownerId', isEqualTo: userId)
        .get();
    final products =
        productSnap.docs.map((doc) => Products.fromFirestore(doc)).toList();

// ===================================Fetching services===================================

    final serviceSnap = await firestore
        .collection('item')
        .doc('Services')
        .collection('Services')
        .where('ownerId', isEqualTo: userId)
        .where('typeService', isEqualTo: "Traansport service")
        .get();
    final services = serviceSnap.docs.map(Products.fromFirestore).toList();

    // Combine all items into one list
    return [
      ...products,
      ...services,
    ];
  }

  // ... (everything above stays exactly the same)

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
      body: DefaultTabController(
        length: 1,
        child: Column(
          children: [
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
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
                                    : const AssetImage(
                                        "assets/anonyme.png")) as ImageProvider,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(username,
                            style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text("$followersCount",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text(S.of(context).followers,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              children: [
                                Text("$followingCount",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text(S.of(context).following,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
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
                                      isFollowing
                                          ? S.of(context).unfollow
                                          : S.of(context).follow,
                                      style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                               
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        TabBar(
                          tabs: const [
                            Tab(
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
                            insets:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  )
                ],
                body: TabBarView(
                  children: [
                    FutureBuilder<List<Products>>(
                      future: fetchAllUserItems(widget.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text(S.of(context).noItemsYet));
                        }

                        final itemList = snapshot.data!;
                        return GridView.builder(
                          itemCount: itemList.length,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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
            ),
          ],
        ),
      ),
    );
  }
}
