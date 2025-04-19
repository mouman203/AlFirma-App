import 'package:agriplant/Back_end/ExpertiseService.dart';
import 'package:agriplant/Back_end/RepairService.dart';
import 'package:agriplant/Back_end/Service.dart';
import 'package:agriplant/Back_end/TransportService.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Service details A/service_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ServiceCard extends StatefulWidget {
  final Service service;
  final Users user = Users();

  ServiceCard({super.key, required this.service});

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isSaved = false; // Track whether the service is saved

  @override
  void initState() {
    super.initState();
    _checkIfSaved(); // Check if the service is already saved when the widget is initialized
  }

  // Check if the service is saved in the user's "Saved" collection
  Future<void> _checkIfSaved() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Saved')
          .doc(widget.service.id)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          isSaved = true; // If the document exists, the service is saved
        });
      }
    }
  }

  // Function to save or remove the service from the "Saved" collection
  Future<void> _toggleSavedStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        if (isSaved) {
          // Remove from saved
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .collection('Saved')
              .doc(widget.service.id)
              .delete();
          setState(() {
            isSaved = false; // Update the UI to reflect the service is no longer saved
          });
          print("✅ Service removed from saved list!");
        } else {
          // Save to the "Saved" collection
          final serviceData = {
            'id': widget.service.id,
            'categorie': widget.service.categorie,
            'typeService': widget.service.typeService,
            'price': widget.service.price,
            'description': widget.service.description,
            'rate': widget.service.rate,
            'ownerId': widget.service.ownerId,
            'comments': widget.service.comments,
            'photos': widget.service.photos,
            'liked': widget.service.liked,
            'disliked': widget.service.disliked,
            'date_of_add': Timestamp.fromDate(widget.service.date_of_add),
          };

          // Conditionally add specific fields based on service type
          if (widget.service is ExpertiseService) {
            serviceData['TypeC'] = (widget.service as ExpertiseService).TypeC;
            serviceData['wilaya'] = (widget.service as ExpertiseService).wilaya;
            serviceData['daira'] = (widget.service as ExpertiseService).daira;
          } else if (widget.service is TransportService) {
            serviceData['moyenDeTransport'] =
                (widget.service as TransportService).moyenDeTransport;
            serviceData['wilaya'] = (widget.service as TransportService).wilaya;
            serviceData['daira'] = (widget.service as TransportService).daira;
          } else if (widget.service is RepairService) {
            serviceData['wilaya'] = (widget.service as RepairService).wilaya;
            serviceData['daira'] = (widget.service as RepairService).daira;
          }

          // Save the service in the user's "Saved" collection
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .collection('Saved')
              .doc(widget.service.id)
              .set(serviceData); // Save the service data

          setState(() {
            isSaved = true; // Update the UI to reflect the service is saved
          });
          print("✅ Service saved successfully!");
        }
      } catch (e) {
        print("❌ Error updating saved status: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsPage(service: widget.service),
          ),
        );
      },
      child: Card(
        color:
            isDarkMode ? colorScheme.onSecondary : colorScheme.secondaryFixed,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        elevation: 0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.service.photos.isNotEmpty
                        ? NetworkImage(widget.service.photos[0])
                        : const AssetImage('assets/nophoto.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: IconButton.filledTonal(
                    padding: EdgeInsets.zero,
                    onPressed: _toggleSavedStatus, // Toggle save/remove
                    iconSize: 18,
                    icon: isSaved
                        ? const Icon(IconlyBold.bookmark)
                        : const Icon(IconlyLight.bookmark),
                    color: isSaved
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    widget.service.categorie,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.service is TransportService
                        ? (widget.service as TransportService)
                                .moyenDeTransport ??
                            "No transport type"
                        : widget.service is ExpertiseService
                            ? (widget.service as ExpertiseService).TypeC ??
                                "No type specified"
                            : widget.service is RepairService
                                ? ""
                                : "",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  // Price
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(text: "دج${widget.service.price}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Reactions
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Services')
                        .doc(widget.service.typeService)
                        .collection(widget.service.typeService)
                        .doc(widget.service.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const SizedBox();
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>? ?? {};
                      final liked = List<String>.from(data['liked'] ?? []);
                      final disliked =
                          List<String>.from(data['disliked'] ?? []);
                      final comments = List<Map<String, dynamic>>.from(
                          data['comments'] ?? []);
                      final userId =
                          FirebaseAuth.instance.currentUser?.uid ?? "guest";

                      final isLiked = liked.contains(userId);
                      final isDisliked = disliked.contains(userId);

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            _reactionIcon(
                              context,
                              icon: Icons.thumb_up,
                              count: liked.length,
                              color: isLiked ? Colors.green : Colors.grey,
                              onTap: () => widget.user.likeService(widget.service),
                            ),
                            const SizedBox(width: 20),
                            _reactionIcon(
                              context,
                              icon: Icons.thumb_down,
                              count: disliked.length,
                              color: isDisliked ? Colors.red : Colors.grey,
                              onTap: () => widget.user.dislikeService(widget.service),
                            ),
                            const SizedBox(width: 20),
                            _reactionIcon(
                              context,
                              icon: Icons.comment,
                              count: comments.length,
                              color: Colors.grey,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceDetailsPage(service: widget.service),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reactionIcon(
    BuildContext context, {
    required IconData icon,
    required int count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 5),
        Text(
          "$count",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ],
    );
  }
}
