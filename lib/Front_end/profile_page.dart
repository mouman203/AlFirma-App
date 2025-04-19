import 'package:agriplant/Back_end/Product.dart';
import 'package:agriplant/Back_end/ProductAgri.dart';
import 'package:agriplant/Back_end/ProductElev.dart';
import 'package:agriplant/Front_end/Edit_profile_page.dart';
import 'package:agriplant/Front_end/Saved.dart';
import 'package:agriplant/Front_end/settings.dart';
import 'package:agriplant/widgets_UI/product_card.dart';
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
        profilePic = userDoc["photo"];
      });
    }
  }

  Future<List<Product>> _fetchUserProducts(String userId) async {
  final firestore = FirebaseFirestore.instance;

  final agriSnap = await firestore
      .collection('Products')
      .doc('Agricol_products')
      .collection('Agricol_products')
      .where('ownerId', isEqualTo: userId)
      .get();

  final elevSnap = await firestore
      .collection('Products')
      .doc('Eleveur_products')
      .collection('Eleveur_products')
      .where('ownerId', isEqualTo: userId)
      .get();

  final agriProducts = agriSnap.docs.map((doc) {
    final data = doc.data();
    return Productagri(
          id: doc.id,
          ownerId: data["ownerId"],
          name: data['name'] ?? '',
          typeProduct: data["typeProduct"] ?? "AgricolProduct",
          description: data['description'] ?? '',
          photos: (data['photos'] is List)
              ? List<String>.from(data['photos'])
              : ["assets/nophoto.png"],
          price: (data['price'] is num)
              ? data['price'].toDouble()
              : double.tryParse(data['price'].toString()) ?? 0.0,
          unite: data['unite'] ?? 'DA',
          category: data['category'] ?? '',
          rate: (data['rate'] is num)
              ? data['rate'].toInt()
              : int.tryParse(data['rate'].toString()) ?? 0,
          comments: (data['comments'] is List)
              ? List<Map<String, dynamic>>.from(data['comments'])
              : [],
          liked:
              (data["liked"] is List) ? List<String>.from(data["liked"]) : [],
          disliked: (data["disliked"] is List)
              ? List<String>.from(data["disliked"])
              : [],
          date_of_add: data["date_of_add"] != null && data["date_of_add"] is Timestamp
              ? (data["date_of_add"] as Timestamp).toDate()
              : DateTime.now(),

          type: data['type'],
          produit: data['produit'],
          quantite: data['quantite'],
          surface: data['surface'],
          wilaya: data['wilaya'],
          daira: data['daira'],
        );
      }).toList();

  final elevProducts = elevSnap.docs.map((doc) {
    final data = doc.data();
    return ProductElev(
          id: doc.id,
          ownerId: data["ownerId"],
          name: data['name'] ?? '',
          typeProduct: data['typeProduct'] ?? "EleveurProduct",
          description: data['description'] ?? '',
          photos: (data['photos'] is List)
              ? List<String>.from(data['photos'])
              : ["assets/nophoto.png"],
          price: (data['price'] is num)
              ? data['price'].toDouble()
              : double.tryParse(data['price'].toString()) ?? 0.0,
          category: data['category'] ?? '',
          rate: (data['rate'] is num)
              ? data['rate'].toInt()
              : int.tryParse(data['rate'].toString()) ?? 0,
          comments: (data['comments'] is List)
              ? List<Map<String, dynamic>>.from(data['comments'])
              : [],
          liked:
              (data["liked"] is List) ? List<String>.from(data["liked"]) : [],
          disliked: (data["disliked"] is List)
              ? List<String>.from(data["disliked"])
              : [],
          date_of_add: data["date_of_add"] != null && data["date_of_add"] is Timestamp
          ? (data["date_of_add"] as Timestamp).toDate()
          : DateTime.now(),
          produit: data['produit'],
          quantite: data['quantite'],
          wilaya: data['wilaya'],
          daira: data['daira'],
        );
      }).toList();

  return [...agriProducts, ...elevProducts];
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
                        ? const Color(0xFF273930)
                        : const Color(0xFF256C4C),
                    child: CircleAvatar(
                      radius: 90,
                      backgroundImage: profilePic != null
                          ? NetworkImage(profilePic!)
                          : isDarkMode
                              ? const AssetImage("assets/anonymeD.png")
                              : const AssetImage("assets/anonyme.png")
                                  as ImageProvider,
                    ),
                  ),
                ),
              ),
             
              Positioned(
                top: 54,
                right: 100,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Color.fromARGB(255, 14, 10, 10)),
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
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    child: IconButton(
                      icon: const Icon(Icons.settings, color: Color.fromARGB(255, 14, 10, 10)),
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
         
          const SizedBox(height: 40),
          //product sharing
           
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Product>>(
              future: _fetchUserProducts(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
            
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("لا توجد منتجات لهذا المستخدم.");
                }
            
                final productList = snapshot.data!;
            
                return GridView.builder(
                  itemCount: productList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: productList[index]);
                  },
                );
              },
            ),
          ),
          
          const SizedBox(height: 10),

          //edit profile


          ListTile(
            leading: Icon(IconlyBold.bookmark,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            title: Text('Saved',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Saved()));
            },
          ),
        
          ListTile(
            leading: Icon(Icons.logout_sharp,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            title: Text('Log out',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            onTap: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("login_page", (route) => false);
            },
          ),
        
        ],
      ),
    );
  }
}
