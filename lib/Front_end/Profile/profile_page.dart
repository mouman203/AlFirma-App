import 'package:agriplant/Back_end/ServicesB/ExpertiseService.dart';
import 'package:agriplant/Back_end/Products/ProductAgri.dart';
import 'package:agriplant/Back_end/Products/ProductElev.dart';
import 'package:agriplant/Back_end/ServicesB/RepairService.dart';
import 'package:agriplant/Back_end/ServicesB/TransportService.dart';
import 'package:agriplant/Front_end/Profile/Edit_profile_page.dart';
import 'package:agriplant/Front_end/Profile/Settings/settings.dart';
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

    if (userDoc.exists) {
      setState(() {
        followersCount = (userDoc["followers"] as List<dynamic>?)?.length ?? 0;
        followingCount = (userDoc["following"] as List<dynamic>?)?.length ?? 0;
        username = userDoc["first_name"];
        profilePic = userDoc["photo"];
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
Future<List<dynamic>> _loadSavedItems() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return [];

  final firestore = FirebaseFirestore.instance;

  final userDoc = await firestore.collection('Users').doc(currentUser.uid).get();
  if (!userDoc.exists || !userDoc.data()!.containsKey('saved')) {
    print("❌ No saved items found for the current user.");
    return [];
  }

  final savedItemIds = List<String>.from(userDoc['saved'] ?? []);
  print("🎉 Loaded saved item IDs: $savedItemIds");

  final List<dynamic> savedItems = [];

  for (var itemId in savedItemIds) {
    try {
      bool found = false;

      final fetchPatterns = {
        'Products/Agricol_products/Agricol_products': (DocumentSnapshot snap) => Productagri.fromFirestore(snap),
        'Products/Eleveur_products/Eleveur_products': (DocumentSnapshot snap) => ProductElev.fromFirestore(snap),
        'Services/Expertise/Expertise': (DocumentSnapshot snap) => ExpertiseService.fromFirestore(snap),
        'Services/Repairs/Repairs': (DocumentSnapshot snap) => RepairService.fromFirestore(snap),
        'Services/Transportation/Transportation': (DocumentSnapshot snap) => TransportService.fromFirestore(snap),
      };

      for (final entry in fetchPatterns.entries) {
        final pathParts = entry.key.split('/');
        final snap = await firestore
            .collection(pathParts[0])
            .doc(pathParts[1])
            .collection(pathParts[2])
            .doc(itemId)
            .get();

        print("🧐 Checking ${entry.key} for ID $itemId");

        if (snap.exists) {
          savedItems.add(entry.value(snap));
          print("✅ Found item in ${entry.key}");
          found = true;
          break;
        }
      }

      if (!found) {
        print("❌ ID $itemId not found in any structured collection.");
      }
    } catch (e) {
      print('❌ Error loading item $itemId: $e');
    }
  }

  print("🎉 Finished loading saved items: ${savedItems.length} found.");
  return savedItems;
}




  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 54, bottom: 16),
                  child: CircleAvatar(
                    radius: 93,
                    backgroundColor: isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C),
                    child: CircleAvatar(
                      radius: 90,
                      backgroundImage:
                          (profilePic != null && profilePic!.isNotEmpty)
                              ? NetworkImage(profilePic!)
                              : (isDarkMode
                                      ? const AssetImage("assets/anonymeD.png")
                                      : const AssetImage("assets/anonyme.png"))
                                  as ImageProvider,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 54,
                right: 100,
                child: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  child: IconButton(
                    icon: Icon(Icons.edit,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF256C4C)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfilePage(frompage:"profile")),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10, // المسافة المناسبة للأيقونة في أعلى اليمين
                child: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  child: IconButton(
                    icon: Icon(Icons.settings,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF256C4C)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()));
                    },
                  ),
                ),
              ),
            ],
          ),

          //uername

          Center(
            child: Column(
              children: [
                Text(
                  username, // ✅ عرض اسم المستخدم الفعلي
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),

                //following and followers
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

          const SizedBox(height: 25),
          DefaultTabController(
            length: 2,
            child: Builder(builder: (context) {
              final tabController = DefaultTabController.of(context);
              return Column(
                children: [
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
                    height: 500, // Adjust as needed
                    child: TabBarView(
                      children: [
                        // User's posts
                        FutureBuilder<List<Object>>(
                          future: fetchAllUserItems(
                              FirebaseAuth.instance.currentUser!.uid),
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
                                crossAxisSpacing: 10,
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
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text("No saved items yet."));
                            }

                            final savedItems = snapshot.data!;
                            return GridView.builder(
                              itemCount: savedItems.length,
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
              );
            }),
          ),
        ],
      ),
    );
  }
}
