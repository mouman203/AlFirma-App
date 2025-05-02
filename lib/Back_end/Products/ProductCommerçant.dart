import 'package:cloud_firestore/cloud_firestore.dart';
import 'Product.dart';

class ProductCommercant extends Product {
  String? category;
  String? unite;
  String? subcategory;
  String? serviceType;
  double? quantite; //les lfruits...
  double? surface; //les terrains

  ProductCommercant({
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
    required DateTime date_of_add,
    required String wilaya,
    required String daira,
    this.category,
    this.unite,
    this.subcategory,
    this.serviceType,
    this.quantite,
    this.surface,
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
      "category": category,
      "subcategory": subcategory,
      "quantite": quantite,
      "surface": surface,
      "serviceType": serviceType,
      "wilaya": wilaya,
      "daira": daira,
      "date_of_add": Timestamp.fromDate(date_of_add),
    };
    return data;
  }

  factory ProductCommercant.fromFirestore(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;

    return ProductCommercant(
      id: json['id'] ?? doc.id,
      name: json['name'] ?? '',
      typeProduct: json['typeProduct'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      rate: json['rate'] ?? 0,
      ownerId: json['ownerId'] ?? '',
      comments: List<Map<String, dynamic>>.from(json['comments'] ?? []),
      photos: List<String>.from(json['photos'] ?? []),
      liked: List<String>.from(json['liked'] ?? []),
      disliked: List<String>.from(json['disliked'] ?? []),
      date_of_add:
          (json['date_of_add'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: json['category'],
      unite: json['unite'],
      subcategory: json['subcategory'],
      serviceType:json['serviceType'],
      quantite: (json['quantite'] as num?)?.toDouble(),
      surface: (json['surface'] as num?)?.toDouble(),
      wilaya: json['wilaya'],
      daira: json['daira'],
    );
  }

  /// 1**Add a new product to Firestore**
  Future<void> addProduct(ProductCommercant product) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('Products') // Collection رئيسي
          .doc('Commercant_products') // Document داخلي
          .collection('Commercant_products') // Collection فرعي
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
          .doc('Commercant_products') // Document وسيط
          .collection('Commercant_products') // Collection فرعي
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
          .doc('Commercant_products')
          .collection('Commercant_products')
          .doc(id)
          .delete();
    } catch (e) {
      print("there is an error in deleting a product $e");
    }
  }

  static Future<List<ProductCommercant>> getRentservicesOnce() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc('Commercant_products')
        .collection('Commercant_products')
        .where('serviceType', isEqualTo: 'كراء')
        .get();

    return snapshot.docs.map(ProductCommercant.fromFirestore).toList();
  }
}
