import 'package:cloud_firestore/cloud_firestore.dart';
import 'Service.dart';

class ExpertiseService extends Service {
  String? wilaya;
  String? daira;
  String? commune;
  String? TypeC;

  ExpertiseService({
    required String id,
    required String categorie,
    required String typeService,
    required double price,
    required String description,
    required int rate,
    required String? ownerId,
    required List<Map<String, dynamic>> comments,
    required List<String> photos,
    required List<String> liked,
    required List<String> disliked,
    required DateTime date_of_add,
    this.wilaya,
    this.daira,
    this.TypeC,
  }) : super(
          id: id,
          categorie: categorie,
          typeService: typeService,
          price: price,
          description: description,
          rate: rate,
          ownerId: ownerId,
          comments: comments,
          photos: photos,
          liked: liked,
          disliked: disliked,
          date_of_add: date_of_add,
        );

  String? get service => null;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "categorie": categorie,
      "typeService": typeService,
      "price": price,
      "description": description,
      "rate": rate,
      "ownerId": ownerId,
      "comments": comments,
      "photos": photos,
      "liked": liked,
      "disliked": disliked,
      "wilaya": wilaya,
      "daira": daira,
      "TypeC": TypeC,
      "date_of_add": Timestamp.fromDate(date_of_add),
    };
  }

  /// Add a new transport service
  Future<void> addExpertiseService(ExpertiseService service) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('Services')
          .doc('Expertise')
          .collection('Expertise')
          .doc();
      service.id = docRef.id;
      await docRef.set(service.toJson());
      print("✅ Expertise service added successfully!");
    } catch (e) {
      print("❌ Error adding Expertise service: $e");
    }
  }

  /// Update an existing transport service
  Future<void> updateInFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('Services')
          .doc('Expertise')
          .collection('Expertise')
          .doc(id)
          .update(toJson());
    } catch (e) {
      print("❌ Error updating expertise service: $e");
    }
  }

  /// Delete a transport service
  Future<void> deleteFromFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('Services')
          .doc('Expertise')
          .collection('Expertise')
          .doc(id)
          .delete();
    } catch (e) {
      print("❌ Error deleting expertise service: $e");
    }
  }

 factory ExpertiseService.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ExpertiseService(
      id: doc.id,
      categorie: data['categorie'],
      typeService: data['typeService'],
      price: (data['price'] as num?)?.toDouble() ?? 0,
      description: data['description'] ?? '',
      rate: data['rate'] ?? 0,
      ownerId: data['ownerId'] ?? '',
      comments: List<Map<String, dynamic>>.from(data['comments'] ?? []),
      photos: List<String>.from(data['photos'] ?? []),
      liked: List<String>.from(data['liked'] ?? []),
      disliked: List<String>.from(data['disliked'] ?? []),
      wilaya: data['wilaya'],
      daira: data['daira'],
      TypeC: data['TypeC'] ?? '',
      date_of_add: (data['date_of_add'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  static Future<List<ExpertiseService>> getExpertiseServicesOnce() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Services')
      .doc('Expertise')
      .collection('Expertise')
      .get();

  return snapshot.docs.map(ExpertiseService.fromFirestore).toList();
}
}
