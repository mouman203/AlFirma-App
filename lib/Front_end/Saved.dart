import 'package:agriplant/Back_end/ExpertiseService.dart';
import 'package:agriplant/Back_end/RepairService.dart';
import 'package:agriplant/Back_end/Service.dart';
import 'package:agriplant/Back_end/TransportService.dart';
import 'package:agriplant/widgets_UI/service_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  // Function to load saved services
  Future<List<Service>> _loadSavedServices() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];  // Return empty list if no user is logged in

    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .collection('Saved')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      if (data['typeService'] == 'Expertise') {
        return ExpertiseService(
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
          wilaya: data['wilaya'],
          daira: data['daira'],
          TypeC: data['TypeC'],
          date_of_add: (data['date_of_add'] as Timestamp).toDate(),
        );
      } else if (data['typeService'] == 'Transport') {
        return TransportService(
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
          wilaya: data['wilaya'],
          daira: data['daira'],
          moyenDeTransport: data['moyenDeTransport'],
          date_of_add: (data['date_of_add'] as Timestamp).toDate(),
        );
      } else if (data['typeService'] == 'Repairs') {
        return RepairService(
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
          wilaya: data['wilaya'],
          daira: data['daira'],
          date_of_add: (data['date_of_add'] as Timestamp).toDate(),
        );
      } else {
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
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved '),
        elevation: 5,
      ),
      body: FutureBuilder<List<Service>>(
        future: _loadSavedServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading saved services and products'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No saved services orproducts'));
          } else {
            final services = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return ServiceCard(service: services[index]);  // Your ServiceCard widget
              },
            );
          }
        },
      ),
    );
  }
}
