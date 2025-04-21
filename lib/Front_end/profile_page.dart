import 'package:agriplant/Back_end/ExpertiseService.dart';
import 'package:agriplant/Back_end/Product.dart';
import 'package:agriplant/Back_end/ProductAgri.dart';
import 'package:agriplant/Back_end/ProductElev.dart';
import 'package:agriplant/Back_end/RepairService.dart';
import 'package:agriplant/Back_end/Service.dart';
import 'package:agriplant/Back_end/TransportService.dart';
import 'package:agriplant/Front_end/Edit_profile_page.dart';
import 'package:agriplant/Front_end/settings.dart';
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
        agriSnap.docs.map((doc) => Productagri.fromFirestore(doc)).toList();

    // Fetch Eleveur Products
    final elevSnap = await firestore
        .collection('Products')
        .doc('Eleveur_products')
        .collection('Eleveur_products')
        .where('ownerId', isEqualTo: userId)
        .get();

    final elevProducts =
        elevSnap.docs.map((doc) => ProductElev.fromFirestore(doc)).toList();

    // Fetch and filter Services
    final expertiseServices = await ExpertiseService.getExpertiseServicesOnce();
    final repairServices = await RepairService.getRepairServicesOnce();
    final transportServices = await TransportService.getTransportServicesOnce();

    final filteredExpertise =
        expertiseServices.where((e) => e.ownerId == userId).toList();
    final filteredRepairs =
        repairServices.where((e) => e.ownerId == userId).toList();
    final filteredTransport =
        transportServices.where((e) => e.ownerId == userId).toList();

    // Combine all into one list
    return [
      ...agriProducts,
      ...elevProducts,
      ...filteredExpertise,
      ...filteredRepairs,
      ...filteredTransport,
    ];
  }

  Future<List<dynamic>> _loadSavedItems() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .collection('Saved')
        .get();

    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          final type = data['typeService'] ?? data['typeProduct'];

          if (type == 'Expertise') {
            return ExpertiseService(
              id: data['id'],
              categorie: data['categorie'],
              typeService: type,
              price: (data['price'] as num).toDouble(),
              description: data['description'],
              rate: data['rate'],
              ownerId: data['ownerId'],
              comments: List<Map<String, dynamic>>.from(data['comments']),
              photos: List<String>.from(data['photos']),
              liked: List<String>.from(data['liked']),
              disliked: List<String>.from(data['disliked']),
              wilaya: data['wilaya'],
              daira: data['daira'],
              TypeC: data['TypeC'],
              date_of_add: (data['date_of_add'] as Timestamp).toDate(),
            );
          } else if (type == 'Transport') {
            return TransportService(
              id: data['id'],
              categorie: data['categorie'],
              typeService: type,
              price: (data['price'] as num).toDouble(),
              description: data['description'],
              rate: data['rate'],
              ownerId: data['ownerId'],
              comments: List<Map<String, dynamic>>.from(data['comments']),
              photos: List<String>.from(data['photos']),
              liked: List<String>.from(data['liked']),
              disliked: List<String>.from(data['disliked']),
              wilaya: data['wilaya'],
              daira: data['daira'],
              moyenDeTransport: data['moyenDeTransport'],
              date_of_add: (data['date_of_add'] as Timestamp).toDate(),
            );
          } else if (type == 'Repairs') {
            return RepairService(
              id: data['id'],
              categorie: data['categorie'],
              typeService: type,
              price: (data['price'] as num).toDouble(),
              description: data['description'],
              rate: data['rate'],
              ownerId: data['ownerId'],
              comments: List<Map<String, dynamic>>.from(data['comments']),
              photos: List<String>.from(data['photos']),
              liked: List<String>.from(data['liked']),
              disliked: List<String>.from(data['disliked']),
              wilaya: data['wilaya'],
              daira: data['daira'],
              date_of_add: (data['date_of_add'] as Timestamp).toDate(),
            );
          } else if (data['typeProduct'] == 'AgricolProduct') {
            return Productagri(
              id: data['id'] ?? '',
              name: data['name'] ?? '',
              typeProduct: data['typeProduct'] ?? '',
              price: (data['price'] ?? 0).toDouble(),
              description: data['description'] ?? '',
              rate: data['rate'] ?? 0,
              ownerId: data['ownerId'] ?? '',
              comments: List<Map<String, dynamic>>.from(data['comments'] ?? []),
              photos: List<String>.from(data['photos'] ?? []),
              liked: List<String>.from(data['liked'] ?? []),
              disliked: List<String>.from(data['disliked'] ?? []),
              category: data['category'],
              unite: data['unite'],
              subcategory: data['subcategory'],
              quantite: (data['quantite'] as num?)?.toDouble(),
              surface: (data['surface'] as num?)?.toDouble(),
              wilaya: data['wilaya'],
              daira: data['daira'],
              date_of_add: (data['date_of_add'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
            );
          } else if (data['typeProduct'] == 'EleveurProduct') {
            return ProductElev(
              id: data['id'] ?? '',
              name: data['name'] ?? '',
              typeProduct: data['typeProduct'] ?? '',
              price: (data['price'] ?? 0).toDouble(),
              description: data['description'] ?? '',
              rate: data['rate'] ?? 0,
              ownerId: data['ownerId'],
              comments: List<Map<String, dynamic>>.from(data['comments'] ?? []),
              photos: List<String>.from(data['photos'] ?? []),
              liked: List<String>.from(data['liked'] ?? []),
              disliked: List<String>.from(data['disliked'] ?? []),
              category: data['category'],
              quantite: (data['quantite'] as num?)?.toDouble(),
              wilaya: data['wilaya'],
              daira: data['daira'],
              date_of_add: (data['date_of_add'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
            );
          } else if (data['typeService'] != null) {
            return Service(
              id: data['id'],
              categorie: data['categorie'],
              typeService: data['typeService'],
              price: (data['price'] as num).toDouble(),
              description: data['description'],
              rate: data['rate'],
              ownerId: data['ownerId'],
              comments: List<Map<String, dynamic>>.from(data['comments']),
              photos: List<String>.from(data['photos']),
              liked: List<String>.from(data['liked']),
              disliked: List<String>.from(data['disliked']),
              date_of_add: (data['date_of_add'] as Timestamp).toDate(),
            );
          } else if (data['typeProduct'] != null) {
            return Product(
              id: data['id'],
              name: data['name'],
              typeProduct: data['typeProduct'],
              price: (data['price'] as num).toDouble(),
              description: data['description'],
              rate: data['rate'],
              ownerId: data['ownerId'],
              comments: List<Map<String, dynamic>>.from(data['comments']),
              photos: List<String>.from(data['photos']),
              liked: List<String>.from(data['liked']),
              disliked: List<String>.from(data['disliked']),
              date_of_add: (data['date_of_add'] as Timestamp).toDate(),
              wilaya: data['wilaya'],
              daira: data['daira'],
            );
          }
        })
        .whereType<dynamic>()
        .toList();
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
                            builder: (context) => const EditProfilePage()),
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
                              return const Center(child: Text("No posts yet."));
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
                                  child: Text("No saved posts yet."));
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
