import 'package:cloud_firestore/cloud_firestore.dart';

class Productagri {
  String? id;
  String? image;
  String? type;
  String? categorie;
  String? produit;
  double? quantite; //les lfruits...
  double? surface; //les terrains
  int? prix;
  String? wilaya;
  String? daira;
  String? description;

  Productagri(
      {this.id,
      this.image,
      this.type,
      this.categorie,
      this.produit,
      this.quantite,
      this.surface,
      this.prix,
      this.wilaya,
      this.daira,
      this.description});

// Convert object to a Firestore-compatible map
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
      "type": type,
      "categorie": categorie,
      "produit": produit,
      "quantite": quantite,
      "surface": surface,
      "prix": prix,
      "wilaya": wilaya,
      "daira": daira,
      "description": description,
    };
  }

  // Create an object from Firestore document
  factory Productagri.fromJson(Map<String, dynamic> json, String id) {
    return Productagri(
      id: json['id'],
     image: json['image'],
      type: json['type'],
      categorie: json['categorie'],
      produit: json['produit'],
      quantite: (json['quantite'] as num?)?.toDouble(),
      surface: (json['surface'] as num?)?.toDouble(),
      prix: json['prix'] as int?,
      wilaya: json['wilaya'],
      daira: json['daira'],
      description: json['description'],
    );
  }

/// 1**Add a new product to Firestore**
  Future<void> addProduct(Productagri product) async {
    final docRef = FirebaseFirestore.instance.collection('Produit Agricole').doc();
    product.id = docRef.id; // Auto-generate Firestore document ID
    await docRef.set(product.toJson());
  }

  /// 2**Update an existing product**
  Future<void> updateInFirestore() async {
    if (id == null) return;
    await FirebaseFirestore.instance.collection('Produit Agricole').doc(id).update(toJson());
  }

  /// 3**Delete a product from Firestore**
  Future<void> deleteFromFirestore() async {
    if (id == null) return;
    await FirebaseFirestore.instance.collection('Produit Agricole').doc(id).delete();
  }

  /// 4**Fetch a product by ID**
  static Future<Productagri?> getById(String productId) async {
    final doc = await FirebaseFirestore.instance.collection('Produit Agricole').doc(productId).get();
    if (doc.exists) {
      return Productagri.fromJson(doc.data()!, doc.id);
    }
    return null;
  }

  /// 5**Fetch all products in real-time**
  static Stream<List<Productagri>> getAllProducts() {
    return FirebaseFirestore.instance.collection('Produit Agricole').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Productagri.fromJson(doc.data(), doc.id)).toList();
    });
  }
}
