import 'package:agriplant/Back_end/ExpertiseService.dart';
import 'package:agriplant/Back_end/Product.dart';
import 'package:agriplant/Back_end/ProductAgri.dart';
import 'package:agriplant/Back_end/ProductElev.dart';
import 'package:agriplant/Back_end/RepairService.dart';
import 'package:agriplant/Back_end/Service.dart';
import 'package:agriplant/Back_end/TransportService.dart';
import 'package:agriplant/widgets_UI/Item_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  Future<List<dynamic>> _loadSavedItems() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .collection('Saved')
        .get();

    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          final type = data['typeService'] ?? data['typeProduct'];

          if (type == 'Expertise') {
            return ExpertiseService(
              id: data['id'],
              categorie: data['categorie'],
              typeService: type,
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
              TypeC: data['TypeC'],
              date_of_add: (data['date_of_add'] as Timestamp).toDate(),
            );
          } else if (type == 'Transport') {
            return TransportService(
              id: data['id'],
              categorie: data['categorie'],
              typeService: type,
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
          } else if (type == 'Repairs') {
            return RepairService(
              id: data['id'],
              categorie: data['categorie'],
              typeService: type,
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
              date_of_add: (data['date_of_add'] as Timestamp).toDate(),
            );
          } else if (data['typeProduct'] == 'AgricolProduct') {
            return Productagri(
              id: data['id'] ?? '',
              name: data['name'] ?? '',
              typeProduct: data['typeProduct'] ?? '',
              price: (data['price'] ?? 0).toDouble(),
              description: data['description'] ?? '',
              rate: data['rate'] ?? 0,
              ownerId: data['ownerId'] ?? '',
              comments: List<Map<String, dynamic>>.from(data['comments'] ?? []),
              photos: List<String>.from(data['photos'] ?? []),
              liked: List<String>.from(data['liked'] ?? []),
              disliked: List<String>.from(data['disliked'] ?? []),
              category: data['category'],
              unite: data['unite'],
              subcategory: data['subcategory'],
              quantite: (data['quantite'] as num?)?.toDouble(),
              surface: (data['surface'] as num?)?.toDouble(),
              wilaya: data['wilaya'],
              daira: data['daira'],
              date_of_add: (data['date_of_add'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
            );
          } else if (data['typeProduct'] == 'EleveurProduct') {
            return ProductElev(
              id: data['id'] ?? '',
              name: data['name'] ?? '',
              typeProduct: data['typeProduct'] ?? '',
              price: (data['price'] ?? 0).toDouble(),
              description: data['description'] ?? '',
              rate: data['rate'] ?? 0,
              ownerId: data['ownerId'],
              comments: List<Map<String, dynamic>>.from(data['comments'] ?? []),
              photos: List<String>.from(data['photos'] ?? []),
              liked: List<String>.from(data['liked'] ?? []),
              disliked: List<String>.from(data['disliked'] ?? []),
              category: data['category'],
              quantite: (data['quantite'] as num?)?.toDouble(),
              wilaya: data['wilaya'],
              daira: data['daira'],
              date_of_add: (data['date_of_add'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
            );
          } else if (data['typeService'] != null) {
            return Service(
              id: data['id'],
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
              date_of_add: (data['date_of_add'] as Timestamp).toDate(),
            );
          } else if (data['typeProduct'] != null) {
            return Product(
              id: data['id'],
              name: data['name'],
              typeProduct: data['typeProduct'],
              price: (data['price'] as num).toDouble(),
              description: data['description'],
              rate: data['rate'],
              ownerId: data['ownerId'],
              comments: List<Map<String, dynamic>>.from(data['comments']),
              photos: List<String>.from(data['photos']),
              liked: List<String>.from(data['liked']),
              disliked: List<String>.from(data['disliked']),
              date_of_add: (data['date_of_add'] as Timestamp).toDate(),
              wilaya: data['wilaya'],
              daira: data['daira'],
            );
          }
        })
        .whereType<dynamic>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
        elevation: 5,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _loadSavedItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading saved items'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No saved items'));
          } else {
            final items = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return ItemCard(
                  item: item,
                  onUnsave: () {
                    setState(() {
                      items.remove(item);
                    });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
