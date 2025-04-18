import 'package:agriplant/Back_end/Product.dart';
import 'package:agriplant/Back_end/ProductAgri.dart';
import 'package:agriplant/Back_end/ProductElev.dart';
import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:agriplant/widgets_UI/product_card.dart';
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
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(username)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            child: CircleAvatar(
              radius: 60,
              backgroundImage:
                  profilePic.isNotEmpty ? NetworkImage(profilePic) : null,
              child: profilePic.isEmpty
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
          ),
          Text(username, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text("$followersCount",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(
                    "Followers",
                    style: Theme.of(context).textTheme.titleMedium
                    
                    ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text("$followingCount",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(
                    "Following",
                    style: Theme.of(context).textTheme.titleMedium
                    
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          //the bottoms of follow and contact 
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              ElevatedButton(
            onPressed: _toggleFollow,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowing ? Colors.red : Colors.green,
            ),
            child: Text(isFollowing ? "Unfollow" : "Follow"),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(receiverId: widget.userId),
                ),
              );
            },
            child: const Icon(Icons.message,size: 25,),
          ),
            ],
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Product>>(
              future: _fetchUserProducts(widget.userId),
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
          )

          
        ],
      ),
    );
  }
}
