import 'package:agriplant/Back_end/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductElev extends Product {
  String? category;
  double? quantite;


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
    required String wilaya,
    required String daira,
    this.category,
    this.quantite,

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
          date_of_add: date_of_add,
          wilaya: wilaya,
          daira: daira,
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "typeProduct":"EleveurProduct",
      "price": price,
      "description": description,
      "rate": rate,
      "ownerId": ownerId,
      "comments": comments,
      "photos": photos,
      "liked": liked,
      "disliked": disliked,
      "category": category,
      "quantite": quantite,
      "wilaya": wilaya,
      "daira": daira,
      "date_of_add": Timestamp.fromDate(date_of_add),
    };
  }
factory ProductElev.fromFirestore(DocumentSnapshot doc) {
  final json = doc.data() as Map<String, dynamic>;

  return ProductElev(
    id: json['id'] ?? doc.id,
    name: json['name'] ?? '',
    typeProduct: json['typeProduct'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    description: json['description'] ?? '',
    rate: json['rate'] ?? 0,
    ownerId: json['ownerId'],
    comments: List<Map<String, dynamic>>.from(json['comments'] ?? []),
    photos: List<String>.from(json['photos'] ?? []),
    liked: List<String>.from(json['liked'] ?? []),
    disliked: List<String>.from(json['disliked'] ?? []),
    date_of_add: (json['date_of_add'] as Timestamp?)?.toDate() ?? DateTime.now(),
    category: json['category'],
    quantite: (json['quantite'] as num?)?.toDouble(),
    wilaya: json['wilaya'],
    daira: json['daira'],
  );
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
