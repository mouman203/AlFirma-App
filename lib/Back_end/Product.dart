class Product {
  // المتغيرات
  String name;
  String productId;
  String category;
  double price;
  String description;
  int rate;
  List<String> comments;
  String unite;
  List<String> photos;

  // المُنشئ (Constructor)
  Product({
     required this.name,
     required this.productId,
     required this.category,
     required this.price,
     required this.description,
     required this.rate,
     required this.comments,
     required this.unite,
     required this.photos,
  });
}
