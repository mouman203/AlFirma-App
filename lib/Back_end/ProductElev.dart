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
    try {
      final docRef =
          FirebaseFirestore.instance.collection('Produit_Elevage').doc();
      product.id = docRef.id; // Auto-generate Firestore document ID
      await docRef.set(product.toJson());
      print("Product added successfully!");
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  /// 2**Update an existing product**
  Future<void> updateInFirestore() async {
    try {
      if (id == null) {
        print("id $id is null");
        return;
      }
      await FirebaseFirestore.instance
          .collection('Produit_Elevage')
          .doc(id)
          .update(toJson());
    } catch (e) {
      print("there is an error in updating an existing product $e");
    }
  }

  /// 3**Delete a product from Firestore**
  Future<void> deleteFromFirestore() async {
    try {
      if (id == null) {
        print("id $id is null");
        return;
      }
      await FirebaseFirestore.instance
          .collection('Produit_Elevage')
          .doc(id)
          .delete();
    } catch (e) {
      print("there is an error in deleting a product $e");
    }
  }

  /// 4**Fetch a product by ID**
  static Future<ProductElev?> getById(String productId) async {
    try{final doc = await FirebaseFirestore.instance
        .collection('Produit_Elevage')
        .doc(productId)
        .get();
    if (doc.exists) {
      return ProductElev.fromJson(doc.data()!, doc.id);
    }
    return null;}
    catch (e) {
      print("there is an error in fetching a product $e");
    }

  }

  /// 5**Fetch all products in real-time**
  static Stream<List<ProductElev>> getAllProducts() {
    return FirebaseFirestore.instance
        .collection('Produit_Elevage')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductElev.fromJson(doc.data(), doc.id))
          .toList();
    });
  }
}
