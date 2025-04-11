class Product {
// المتغيرات
  String id;
  String name;
  String typeProduct;
  double price;
  String description;
  int rate;
  String ?ownerId;
  List<Map<String, dynamic>> comments;
  List<String> photos;
  List<String> liked;
  List<String> disliked;

  // المُنشئ (Constructor)
  Product({
    required this.id,
     required this.name,
     required this.typeProduct,
     required this.price,
     required this.description,
     required this.rate,
     required this.ownerId,
     required this.comments,
     required this.photos,
     required this.liked,
     required this.disliked,
  });
}
