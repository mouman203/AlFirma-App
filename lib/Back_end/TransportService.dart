import 'package:cloud_firestore/cloud_firestore.dart';
import 'Service.dart';

class TransportService extends Service {
  String? wilaya;
  String? daira;
  String? commune;
  String? moyenDeTransport; // e.g., Camion, Pickup, etc.
  // Max volume capacity

  TransportService({
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
    this.moyenDeTransport,
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
      "moyenDeTransport": moyenDeTransport,
      "date_of_add": Timestamp.fromDate(date_of_add),
    };
  }

  /// Add a new transport service
  Future<void> addTransportService(TransportService service) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('Services')
          .doc('Transportation')
          .collection('Transportation')
          .doc();
      service.id = docRef.id;
      await docRef.set(service.toJson());
      print("✅ Transport service added successfully!");
    } catch (e) {
      print("❌ Error adding transport service: $e");
    }
  }

  /// Update an existing transport service
  Future<void> updateInFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('Services')
          .doc('Transportation')
          .collection('Transportation')
          .doc(id)
          .update(toJson());
    } catch (e) {
      print("❌ Error updating transport service: $e");
    }
  }

  /// Delete a transport service
  Future<void> deleteFromFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('Services')
          .doc('Transportation')
          .collection('Transportation')
          .doc(id)
          .delete();
    } catch (e) {
      print("❌ Error deleting transport service: $e");
    }
  }
  static Future<List<TransportService>> getTransportServicesOnce() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Services')
      .doc('Transportation')
      .collection('Transportation')
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return TransportService(
      id: doc.id,
      categorie: data['categorie'],
      typeService: data['typeService'],
      price: (data['price'] as num).toDouble(),
      description: data['description'],
      rate: data['rate'],
      ownerId: data['ownerId'],
      comments: List<Map<String, dynamic>>.from(data['comments']),
      photos: List<String>.from(data['photos']),
      liked: List<String>.from(data['liked']),
      disliked: List<String>.from(data['disliked']),
      wilaya: data['wilaya'],
      daira: data['daira'],
      moyenDeTransport: data['moyenDeTransport'],
      date_of_add: (data['date_of_add'] as Timestamp).toDate(),
    );
  }).toList();
}

}
