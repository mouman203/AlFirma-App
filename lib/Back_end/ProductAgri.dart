import 'package:cloud_firestore/cloud_firestore.dart';
import 'Product.dart';

class Productagri extends Product{
  String? type;
  String? category;
  String? unite;
  String? produit;
  double? quantite; //les lfruits...
  double? surface; //les terrains
  String? wilaya;
  String? daira;

  Productagri({
    required String id,
    required String name,
    required String typeProduct,
    required double price,
    required String description,
    required int rate,
    required String ownerId,
    required List<Map<String, dynamic>> comments,
    required List<String> photos,
    required List<String> liked,
    required List<String> disliked,
    this.type,
    this.category,
    this.unite,
    this.produit,
    this.quantite,
    this.surface,
    this.wilaya,
    this.daira,
  }) : super(
          id: id,
          name: name,
          typeProduct:typeProduct,
          price: price,
          description: description,
          rate: rate,
          ownerId: ownerId,
          comments: comments,
          photos: photos,
          liked: liked,
          disliked: disliked,
        );
      

// Convert object to a Firestore-compatible map
Map<String, dynamic> toJson() {
  final data = {
    "id": id,
    "name": name,
    "typeProduct": typeProduct,
    "price": price,
    "description": description,
    "rate": rate,
    "ownerId": ownerId,
    "comments": comments,
    "unite": unite,
    "photos": photos,
    "liked": liked,
    "disliked": disliked,
    "type": type,
    "category": category,
    "produit": produit,
    "quantite": quantite,
    "surface": surface,
    "wilaya": wilaya,
    "daira": daira,
  };
  return data;
}

  // Create an object from Firestore document
 factory Productagri.fromJson(Map<String, dynamic> json, String id) {
  return Productagri(
    id: id,
    name: json['name'],
    typeProduct: json['typeProduct']?? "AgricolProduct",
    price: (json['price'] as num).toDouble(),
    description: json['description'],
    rate: json['rate'] ?? 0,
    ownerId: json['ownerId'] ?? '',
    comments: List<Map<String, dynamic>>.from(json['comments'] ?? []),
    unite: json['unite'] ?? '',
    photos: List<String>.from(json['photos'] ?? []),
    liked: List<String>.from(json['liked'] ?? []),
    disliked: List<String>.from(json['disliked'] ?? []),
    type: json['type'],
    category: json['category'],
    produit: json['produit'],
    quantite: (json['quantite'] as num?)?.toDouble(),
    surface: (json['surface'] as num?)?.toDouble(),
    wilaya: json['wilaya'],
    daira: json['daira'],
  );
}


/// 1**Add a new product to Firestore**
  Future<void> addProduct(Productagri product) async {
  try {
    final docRef =
          FirebaseFirestore.instance
    .collection('Products') // Collection رئيسي
    .doc('Agricol_products') // Document داخلي
    .collection('Agricol_products') // Collection فرعي
    .doc(); // توليد وثيقة جديدة أو تحديد وثيقة
    product.id = docRef.id;
    await docRef.set(product.toJson());
    print("✅ Product added successfully!");
  } catch (e) {
    print("❌ Error adding product: $e");
  }
}

  /// 2**Update an existing product**
  Future<void> updateInFirestore() async {
    try {
      await FirebaseFirestore.instance
  .collection('Products') // Collection رئيسي
  .doc('Agricol_products') // Document وسيط
  .collection('Agricol_products') // Collection فرعي
  .doc(id) // الوثيقة اللي تحب تحدثها
  .update(toJson());

    } catch (e) {
      print("there is an error in updating an existing product $e");
    }
  }

  /// 3**Delete a product from Firestore**
  Future<void> deleteFromFirestore() async {
    try {
      await FirebaseFirestore.instance
      .collection('Products')
      .doc('Agricol_products')
      .collection('Agricol_products')
      .doc(id)
      .delete();

    } catch (e) {
      print("there is an error in deleting a product $e");
    }
  }

  /// 4**Fetch a product by ID**

  /// 5**Fetch all products in real-time**
  static Stream<List<Productagri>> getAllProducts() {
    return FirebaseFirestore.instance
        .collection('Products')
        .doc('Agricol_products')
        .collection('Agricol_products')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Productagri.fromJson(doc.data(), doc.id))
          .toList();
    });
  }
}
