import 'package:agriplant/Back_end/Products/Product.dart';
import 'package:agriplant/Back_end/Products/ProductAgri.dart';
import 'package:agriplant/Back_end/Products/ProductElev.dart';
import 'package:agriplant/Back_end/ServicesB/Service.dart';
import 'package:agriplant/Back_end/ServicesB/ExpertiseService.dart';
import 'package:agriplant/Back_end/ServicesB/TransportService.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Item%20detaille/product_details_page.dart';
import 'package:agriplant/Front_end/Item%20detaille/service_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ItemCard extends StatefulWidget {
  final dynamic item; // Can be Product or Service
  final Users user = Users();
  final VoidCallback? onUnsave; // Parent callback to update state when unsaved

  ItemCard({super.key, required this.item, this.onUnsave});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  // Check if the item is saved
  Future<void> _checkIfSaved() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      // Ensure the 'saved' field exists and is a list of strings
      final savedList = List<String>.from(userDoc.data()?['saved'] ?? []);

      // Check if the item ID exists in the saved list
      final exists = savedList.contains(widget.item.id);

      if (exists && mounted) {
        setState(() {
          isSaved = true;
        });
      }
    }
  }

  Future<void> _toggleSavedStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userRef = FirebaseFirestore.instance.collection('Users').doc(uid);
    final itemId = widget.item.id; // Ensure item.id exists and is valid

    if (isSaved) {
      // Remove the item ID from the 'saved' list
      await userRef.update({
        'saved': FieldValue.arrayRemove([itemId]) // Only the ID as a string
      });
      setState(() => isSaved = false);
      widget.onUnsave?.call();
    } else {
      // Add the item ID to the 'saved' list (using arrayUnion to prevent duplicates)
      await userRef.update({
        'saved': FieldValue.arrayUnion([itemId]) // Only the ID as a string
      });
      setState(() => isSaved = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        if (item is Service) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailsPage(service: item),
            ),
          );
        } else if (item is Product) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage(product: item),
            ),
          );
        }
      },
      child: Card(
        color: isDarkMode ? scheme.onSecondary : scheme.secondaryFixed,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C),
              width: 1.3),
        ),
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
                    image: item.photos.isNotEmpty
                        ? NetworkImage(item.photos[0])
                        : const AssetImage('assets/nophoto.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Users.isGuestUser()
                    ? const SizedBox() // If guest, show nothing
                    : SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton.filledTonal(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          onPressed: _toggleSavedStatus,
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
            // Texts
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item is Service
                        ? item.categorie
                        : item is Productagri
                            ? item.name.isNotEmpty
                                ? item.name
                                : item.category?.isNotEmpty ?? false
                                    ? item.category!
                                    : item.subcategory ?? ''
                            : item is ProductElev
                                ? item.name.isNotEmpty
                                    ? item.name
                                    : item.category ?? ''
                                : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 5),
                  Text(
                    item is TransportService
                        ? (item.moyenDeTransport ?? 'No Transport Available')
                        : item is ExpertiseService
                            ? (item.TypeC ?? 'No Expertise Type')
                            : item is Productagri
                                ? '${item.quantite?.toString()} ${item.unite ?? ''}'
                                : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 5),
                  // Display price
                  if (item is Product)
                    // If Product, show price and unit (if Productagri)
                    Row(
                      children: [
                        Text("دج${item.price}",
                            style: Theme.of(context).textTheme.bodyLarge),
                        if (item is Productagri)
                          Text(
                            "/${(item).unite}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  if (item is Service)
                    // If Service, show only price
                    Text("دج${item.price}",
                        style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 7),

                  // Reactions for Service and Product
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(item is Service ? 'Services' : 'Products')
                        .doc(item is Service
                            ? item.typeService
                            : item.typeProduct == "AgricolProduct"
                                ? "Agricol_products"
                                : "Eleveur_products")
                        .collection(item is Service
                            ? item.typeService
                            : item.typeProduct == "AgricolProduct"
                                ? "Agricol_products"
                                : "Eleveur_products")
                        .doc(item.id)
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
                      final uid = FirebaseAuth.instance.currentUser?.uid ?? "";

                      return Row(
                        children: [
                          _reactionIcon(
                            context,
                            icon: Icons.thumb_up,
                            count: liked.length,
                            color: Users.isGuestUser()
                                ? (liked.isNotEmpty
                                    ? Colors.green
                                    : Colors
                                        .grey) // If guest, show green if liked, grey if not
                                : (liked.contains(uid)
                                    ? Colors.green
                                    : Colors.grey),
                            onTap: Users.isGuestUser()
                                ? () {}
                                : () {
                                    widget.user.likeItem(item);
                                  },
                          ),
                          const SizedBox(width: 20),
                          _reactionIcon(
                            context,
                            icon: Icons.thumb_down,
                            count: disliked.length,
                            color: Users.isGuestUser()
                                ? (disliked.isNotEmpty
                                    ? Colors.red
                                    : Colors
                                        .grey) // If guest, show red if disliked, grey if not
                                : (disliked.contains(uid)
                                    ? Colors.red
                                    : Colors.grey),
                            onTap: Users.isGuestUser()
                                ? () {}
                                : () {
                                    widget.user.dislikeItem(item);
                                  },
                          ),
                          const SizedBox(width: 20),
                          _reactionIcon(
                            context,
                            icon: IconlyBold.chat,
                            count: comments.length,
                            color: Colors.grey,
                            onTap: () {
                              if (item is Service) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceDetailsPage(service: item),
                                  ),
                                );
                              } else if (item is Product) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailsPage(product: item),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
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
            onTap: onTap, child: Icon(icon, size: 20, color: color)),
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
