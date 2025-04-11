import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRep_Trans {
  String? id;
  //String? image;
  String? type;
  String? categorie;
  int? prix;
  String? wilaya;
  String? daira;
  String? description;

  ProductRep_Trans(
      {this.id,
      //this.image,
      this.type,
      this.categorie,
      this.prix,
      this.wilaya,
      this.daira,
      this.description});

// Convert object to a Firestore-compatible map
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      //"image": image,
      "type":type,
      "categorie": categorie,
      "prix": prix,
      "wilaya": wilaya,
      "daira": daira,
      "description": description,
    };
  }

  // Create an object from Firestore document
  factory ProductRep_Trans.fromJson(Map<String, dynamic> json, String id) {
    return ProductRep_Trans(
      id: json['id'],
      //image: json['image'],
      type:json['type'],
      categorie: json['categorie'],
      prix: json['prix'] as int?,
      wilaya: json['wilaya'],
      daira: json['daira'],
      description: json['description'],
    );
  }

  /// 1**Add a new product to Firestore**
  Future<void> addProduct(ProductRep_Trans product) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('Produit_Rep_Trans').doc();
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
          .collection('Produit_Rep_Trans')
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
          .collection('Produit_Rep_Trans')
          .doc(id)
          .delete();
    } catch (e) {
      print("there is an error in deleting a product $e");
    }
  }

  /// 4**Fetch a product by ID**


  /// 5**Fetch all products in real-time**
  static Stream<List<ProductRep_Trans>> getAllProducts() {
    return FirebaseFirestore.instance
        .collection('Produit_Rep_Trans')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductRep_Trans.fromJson(doc.data(), doc.id))
          .toList();
    });
  }
}
