import 'package:agriplant/Back_end/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductElev extends Product {
  String? category;
  String? produit;
  double? quantite;
  String? wilaya;
  String? daira;

  ProductElev({
    required String id,
    required String name,
    required String typeProduct,
    required double price,
    required String description,
    required int rate,
    required String? ownerId,
    required List<Map<String, dynamic>> comments,
    required List<String> photos,
    required List<String> liked,
    required List<String> disliked,
    required DateTime date_of_add,
    this.category,
    this.produit,
    this.quantite,
    this.wilaya,
    this.daira,
  }) : super(
          id: id,
          name: name,
          typeProduct: typeProduct,
          price: price,
          description: description,
          rate: rate,
          ownerId: ownerId,
          comments: comments,
          photos: photos,
          liked: liked,
          disliked: disliked,
          date_of_add: date_of_add
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "description": description,
      "rate": rate,
      "ownerId": ownerId,
      "comments": comments,
      "photos": photos,
      "liked": liked,
      "disliked": disliked,
      "category": category,
      "produit": produit,
      "quantite": quantite,
      "wilaya": wilaya,
      "daira": daira,
      "date_of_add": Timestamp.fromDate(date_of_add),
    };
  }



 /// 1**Add a new product to Firestore**
  Future<void> addProduct(ProductElev product) async {
    try {
      final docRef =
          FirebaseFirestore.instance
          .collection("Products")
          .doc("Eleveur_products")
          .collection('Eleveur_products').doc();
      product.id = docRef.id;
      await docRef.set(product.toJson());
      print("Product added successfully!");
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  /// 2**Update an existing product**
  Future<void> updateInFirestore() async {
    try {
     
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
     
      await FirebaseFirestore.instance
          .collection('Produit_Elevage')
          .doc(id)
          .delete();
    } catch (e) {
      print("there is an error in deleting a product $e");
    }
  }
}
