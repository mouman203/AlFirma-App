import 'package:cloud_firestore/cloud_firestore.dart';

class ProductElev {
  String? id;
  //String? image;
  String? categorie;
  String? produit;
  double? quantite;
  int? prix;
  String? wilaya;
  String? daira;
  String? description;

  ProductElev(
      {this.id,
      //this.image,
      this.categorie,
      this.produit,
      this.quantite,
      this.prix,
      this.wilaya,
      this.daira,
      this.description});

// Convert object to a Firestore-compatible map
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      //"image": image,
      "categorie": categorie,
      "produit": produit,
      "quantite": quantite,
      "prix": prix,
      "wilaya": wilaya,
      "daira": daira,
      "description": description,
    };
  }

  // Create an object from Firestore document
  factory ProductElev.fromJson(Map<String, dynamic> json, String id) {
    return ProductElev(
      id: json['id'],
     //image: json['image'],
      categorie: json['categorie'],
      produit: json['produit'],
      quantite: (json['quantite'] as num?)?.toDouble(),
      prix: json['prix'] as int?,
      wilaya: json['wilaya'],
      daira: json['daira'],
      description: json['description'],
    );
  }

/// 1**Add a new product to Firestore**
  Future<void> addProduct(ProductElev product) async {
    final docRef = FirebaseFirestore.instance.collection('Produit Elevage').doc();
    product.id = docRef.id; // Auto-generate Firestore document ID
    await docRef.set(product.toJson());
  }

  /// 2**Update an existing product**
  Future<void> updateInFirestore() async {
    if (id == null) return;
    await FirebaseFirestore.instance.collection('Produit Elevage').doc(id).update(toJson());
  }

  /// 3**Delete a product from Firestore**
  Future<void> deleteFromFirestore() async {
    if (id == null) return;
    await FirebaseFirestore.instance.collection('Produit Elevage').doc(id).delete();
  }

  /// 4**Fetch a product by ID**
  static Future<ProductElev?> getById(String productId) async {
    final doc = await FirebaseFirestore.instance.collection('Produit Elevage').doc(productId).get();
    if (doc.exists) {
      return ProductElev.fromJson(doc.data()!, doc.id);
    }
    return null;
  }

  /// 5**Fetch all products in real-time**
  static Stream<List<ProductElev>> getAllProducts() {
    return FirebaseFirestore.instance.collection('Produit Elevage').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProductElev.fromJson(doc.data(), doc.id)).toList();
    });
  }
}
