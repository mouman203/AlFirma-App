import 'package:cloud_firestore/cloud_firestore.dart';
import 'Service.dart';

class RepairService extends Service {
  String? wilaya;
  String? daira;
  String? commune;


  RepairService({
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
      "date_of_add": Timestamp.fromDate(date_of_add),
    };
  }

  /// Add a new transport service
  Future<void> addRepairService(RepairService service) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('Services')
          .doc('Repairs')
          .collection('Repairs')
          .doc();
      service.id = docRef.id;
      await docRef.set(service.toJson());
      print("✅ Repairs service added successfully!");
    } catch (e) {
      print("❌ Error adding Repair service: $e");
    }
  }

  /// Update an existing transport service
  Future<void> updateInFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('Services')
          .doc('Repairs')
          .collection('Repairs')
          .doc(id)
          .update(toJson());
    } catch (e) {
      print("❌ Error updating Repair service: $e");
    }
  }

  /// Delete a transport service
  Future<void> deleteFromFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('Maintenance')
          .doc('Repairs')
          .collection('Repairs')
          .doc(id)
          .delete();
    } catch (e) {
      print("❌ Error deleting Repair service: $e");
    }
  }

 factory RepairService.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RepairService(
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
      date_of_add: (data['date_of_add'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  static Future<List<RepairService>> getRepairServicesOnce() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Services')
      .doc('Repairs')
      .collection('Repairs')
      .get();

  return snapshot.docs.map(RepairService.fromFirestore).toList();
}
}
