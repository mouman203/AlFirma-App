import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  String? id;
  String? ownerId;
  String typeItem;
  String? category;
  String? subCategory; //for : agri + Comm
  String? product;
  double? quantity;
  double? surface; //for commercant //for: agri + Elv
  String? unit;
  String? service;
  double? price;
  String? description;
  List<Map<String, dynamic>>? comments;
  List<String>? photos;
  List<String>? liked;
  List<String>? disliked;
  String? wilaya;
  String? daira;
  DateTime? date_of_add;
  String? SP;

  Products({
    required this.id,
    required this.ownerId,
    required this.typeItem,
    this.category,
    this.subCategory,
    this.product,
    this.quantity,
    this.surface,
    this.unit,
    this.service,
    required this.SP,
    required this.price,
    required this.description,
    required this.comments,
    required this.photos,
    required this.liked,
    required this.disliked,
    required this.wilaya,
    required this.daira,
    required this.date_of_add,
  });

  // Convert object to a Firestore-compatible map
  Map<String, dynamic> toJson() {
    final data = {
      "id": id,
      "ownerId": ownerId,
      "typeItem": typeItem,
      "category": category,
      "sub_category": subCategory,
      "product": product,
      "quantity": quantity,
      "surface": surface,
      "unit": unit,
      "Service": service,
      "price": price,
      "description": description,
      "comments": comments,
      "photos": photos,
      "liked": liked,
      "disliked": disliked,
      "wilaya": wilaya,
      "daira": daira,
      "date_of_add": Timestamp.fromDate(date_of_add!),
      "SP":SP,
    };
    return data;
  }

  factory Products.fromFirestore(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;

    return Products(
      id: json['id'] ?? doc.id,
      ownerId: json['ownerId'] ?? '',
      typeItem: json['typeItem'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['sub_category'] ?? '',
      product: json['product'] ?? '',
      quantity: (json['quantity'] as num?)?.toDouble(),
      surface: (json['surface'] ?? 0),
      unit: json['unit'],
      service: json['Service'],
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      comments: List<Map<String, dynamic>>.from(json['comments'] ?? []),
      photos: List<String>.from(json['photos'] ?? []),
      liked: List<String>.from(json['liked'] ?? []),
      disliked: List<String>.from(json['disliked'] ?? []),
      date_of_add:
          (json['date_of_add'] as Timestamp?)?.toDate() ?? DateTime.now(),
      wilaya: json['wilaya'],
      daira: json['daira'],
      SP:json['SP'],
    );
  }

  /// 1**Add a new product to Firestore**
  Future<void> addProduct(Products product) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('item')
          .doc(SP=="Product"
              ? 'Products'
              : 'Services')
          .collection(SP=="Product"
              ? 'Products'
              : 'Services')
          .doc();
// توليد وثيقة جديدة أو تحديد وثيقة
      product.id = docRef.id;
      await docRef.set(product.toJson());
      print("✅ Product added successfully!");
    } catch (e) {
      print("❌ Error adding product: $e");
    }
  }



/*
  /// 2**Update an existing product**
  Future<void> updateInFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('Productsss')
          .doc(id) // الوثيقة اللي تحب تحدثها
          .update(toJson());
    } catch (e) {
      print("there is an error in updating an existing product $e");
    }
  }

  /// 3**Delete a product from Firestore**
  Future<void> deleteFromFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('Products').doc(id).delete();
    } catch (e) {
      print("there is an error in deleting a product $e");
    }
  }*/
}
