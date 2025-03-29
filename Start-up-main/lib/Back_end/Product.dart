class Product {
// المتغيرات
  String id;
  String name;
  String productId;
  String category;
  double price;
  String description;
  int rate;
  String ?ownerId;
  List<Map<String, dynamic>> comments;  String unite;
  List<String> photos;
  List<String> liked;
  List<String> disliked;

  // المُنشئ (Constructor)
  Product({
    required this.id,
     required this.name,
     required this.productId,
     required this.category,
     required this.price,
     required this.description,
     required this.rate,
     required this.ownerId,
     required this.comments,
     required this.unite,
     required this.photos,
     required this.liked,
     required this.disliked,
  });
}
