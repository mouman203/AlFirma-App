

class Service {
// المتغيرات
  String id;
  String categorie;
  String typeService;
  double price;
  String description;
  int rate;
  String ?ownerId;
  List<Map<String, dynamic>> comments;
  List<String> photos;
  List<String> liked;
  List<String> disliked;
  DateTime date_of_add;

  // المُنشئ (Constructor)
  Service({
     required this.id,
     required this.categorie,
     required this.typeService,
     required this.price,
     required this.description,
     required this.rate,
     required this.ownerId,
     required this.comments,
     required this.photos,
     required this.liked,
     required this.disliked,
     required this.date_of_add,
  });
}
