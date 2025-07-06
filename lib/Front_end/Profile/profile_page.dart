import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/Front_end/Profile/Edit_profile_page.dart';
import 'package:agriplant/Front_end/Profile/Settings/settings.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:agriplant/widgets_UI/Item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

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

    if (!mounted) return;

    if (userDoc.exists) {
      setState(() {
        followersCount = (userDoc["followers"] as List<dynamic>?)?.length ?? 0;
        followingCount = (userDoc["following"] as List<dynamic>?)?.length ?? 0;
        username = "${userDoc["first_name"]} ${userDoc["last_name"]}";
        profilePic = userDoc["photo"];
      });
    }
  }

  Future<List<Products>> fetchAllUserItems(String userId) async {
    final firestore = FirebaseFirestore.instance;

    final productSnap = await firestore
        .collection('item')
        .doc('Products')
        .collection('Products')
        .where('ownerId', isEqualTo: userId)
        .get();
    final products =
        productSnap.docs.map((doc) => Products.fromFirestore(doc)).toList();

    final serviceSnap = await firestore
        .collection('item')
        .doc('Services')
        .collection('Services')
        .where('ownerId', isEqualTo: userId)
        .get();
    final services =
        serviceSnap.docs.map((doc) => Products.fromFirestore(doc)).toList();

    return [...products, ...services];
  }

  Future<List<dynamic>> _loadSavedItems() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final firestore = FirebaseFirestore.instance;

    final userDoc =
        await firestore.collection('Users').doc(currentUser.uid).get();
    if (!userDoc.exists || !userDoc.data()!.containsKey('saved')) {
      print("❌ No saved items found for the current user.");
      return [];
    }

    final savedItemIds = List<String>.from(userDoc['saved']);
    print("🎉 Loaded saved item IDs: $savedItemIds");

    final List<dynamic> producsaved = [];
    final List<dynamic> servicesaved = [];

    for (String itemId in savedItemIds) {
      final productSnap = await firestore
          .collection('item')
          .doc('Products')
          .collection('Products')
          .where('id', isEqualTo: itemId)
          .get();
      producsaved.addAll(
          productSnap.docs.map((doc) => Products.fromFirestore(doc)).toList());

      final serviceSnap = await firestore
          .collection('item')
          .doc('Services')
          .collection('Services')
          .where('id', isEqualTo: itemId)
          .get();
      servicesaved.addAll(
          serviceSnap.docs.map((doc) => Products.fromFirestore(doc)).toList());
    }

    final savedItems = [...producsaved, ...servicesaved];
    print("🎉 Finished loading saved items: ${savedItems.length} found.");
    return savedItems;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: LayoutBuilder(builder: (context, constraints) {
            final tabController = DefaultTabController.of(context);
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 54, bottom: 16),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer Circle (border color)
                                  CircleAvatar(
                                    radius: 93,
                                    backgroundColor: isDarkMode
                                        ? const Color(0xFF90D5AE)
                                        : const Color(0xFF256C4C),
                                    child: CircleAvatar(
                                      radius: 90,
                                      backgroundImage: (profilePic != null &&
                                              profilePic!.isNotEmpty)
                                          ? NetworkImage(profilePic!)
                                          : (isDarkMode
                                                  ? const AssetImage(
                                                      "assets/anonymeD.png")
                                                  : const AssetImage(
                                                      "assets/anonyme.png"))
                                              as ImageProvider,
                                    ),
                                  ),

                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isDarkMode
                                              ? const Color(0xFF90D5AE)
                                              : const Color(0xFF256C4C),
                                          width: 2.5,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.edit,
                                            size: 26,
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color(0xFF256C4C),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const EditProfilePage(
                                                        frompage: "profile"),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              child: IconButton(
                                icon: Icon(Icons.settings,
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF256C4C)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingsPage()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              username,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text("$followersCount",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text(S.of(context).followers),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text("$followingCount",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text(S.of(context).following),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      TabBar(
                        controller: tabController,
                        tabs: List.generate(2, (index) {
                          final isSelected = tabController.index == index;
                          return Tab(
                            icon: Icon(
                              index == 0
                                  ? (isSelected
                                      ? IconlyBold.category
                                      : IconlyLight.category)
                                  : (isSelected
                                      ? IconlyBold.bookmark
                                      : IconlyLight.bookmark),
                              size: 32,
                            ),
                          );
                        }),
                        onTap: (_) => (context as Element).markNeedsBuild(),
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 3.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          insets: const EdgeInsets.symmetric(horizontal: 50.0),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 600, // <-- Set to large enough fixed height
                        child: TabBarView(
                          children: [
                            FutureBuilder<List<Products>>(
                              future: fetchAllUserItems(
                                  FirebaseAuth.instance.currentUser!.uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        S.of(context).noItemsYet,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  );
                                }

                                final itemList = snapshot.data!;
                                return GridView.builder(
                                  itemCount: itemList.length,
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
                            FutureBuilder<List<dynamic>>(
                              future: _loadSavedItems(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        S.of(context).noSavedItems,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  );
                                }

                                final savedItems = snapshot.data!;
                                return GridView.builder(
                                  itemCount: savedItems.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 8,
                                  ),
                                  itemBuilder: (context, index) {
                                    final item = savedItems[index];
                                    return ItemCard(
                                      item: item,
                                      onUnsave: () {
                                        setState(() {
                                          savedItems.remove(item);
                                        });
                                      },
                                    );
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
              ),
            );
          }),
        ),
      ),
    );
  }
}
