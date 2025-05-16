import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Item%20detaille/product_details_page.dart';
import 'package:agriplant/Front_end/Item%20detaille/service_details_page.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ItemCard extends StatefulWidget {
  final Products item; // Can be Product or Service
  final Users user = Users();
  final VoidCallback? onUnsave; // Parent callback to update state when unsaved

  ItemCard({super.key, required this.item, this.onUnsave});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool isSaved = false;

  // Translation maps
  Map<String, String> typeItemTranslations = {};
  Map<String, String> categoryTranslations = {};
  Map<String, String> subCategoryTranslations = {};
  Map<String, String> productTranslations = {};
  Map<String, String> unitTranslations = {};
  Map<String, String> serviceTypeTranslations = {};
  Map<String, String> wilayaTranslations = {};
  Map<String, String> dairaTranslations = {};

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize translation maps when context is available
    _initTranslationMaps();
  }

  // Initialize translation maps
  void _initTranslationMaps() {
    // Initialize typeItem translations
    typeItemTranslations = {
      // Arabic to localized
      "منتج زراعي": S.of(context).agriculturalProduct,
      "منتج حيواني": S.of(context).animalProduct,
      "منتج تجاري": S.of(context).commercialProduct,
      "الخبرة": S.of(context).expertise,
      "النقل": S.of(context).transportation,
      "الإصلاحات": S.of(context).repairs,
    };

    // Initialize units translations
    unitTranslations = {
      "كلغ": S.of(context).kg,
      "طن": S.of(context).ton,
      "لتر": S.of(context).liter,
      "صندوق": S.of(context).box,
      "م²": S.of(context).squareMeter,
      "هكتار": S.of(context).hectare,
      "قطعة": S.of(context).piece,
      "مجموعة": S.of(context).set,
      "رأس": S.of(context).head,
      "عبوة": S.of(context).pack,
      "وحدة": S.of(context).unit,
    };

    serviceTypeTranslations = {
      "بيع": S.of(context).sell,
      "الإيجار": S.of(context).rent,
    };

    // Use the provided method to build the location translation maps
    // This includes both wilaya and daira translations in a single map
    Map<String, String> locationTranslations =
        ProductData.buildDairaTranslationMap(context);
    wilayaTranslations = locationTranslations;
    dairaTranslations = locationTranslations;

    final typeItem = widget.item.typeItem;
    if (typeItem.isNotEmpty) {
      _initCategoryTranslationsForType(typeItem);
    }
  }

  void _initCategoryTranslationsForType(String typeItem) {
    switch (typeItem) {
      case "منتج زراعي":
        _mapCategoryAndProducts(
            ProductData.agriCategories,
            ProductData.agriCategoriesT(context),
            ProductData.agriSubCategories,
            ProductData.agriSubCategoriesT(context));
        break;
      case "منتج حيواني":
        _mapCategoryAndProducts(ProductData.produitsElevages,
            ProductData.produitsElevagesT(context));
        break;
      case "منتج تجاري":
        _mapCategoryAndProducts(
            ProductData.commercantCategories,
            ProductData.commercantCategoriesT(context),
            ProductData.equipmentCategories,
            ProductData.equipmentCategoriesT(context));
        break;
      case "الخبرة":
        ProductData.ExpertProducts.forEach((category, arabicList) {
          // Get the corresponding localized list for the category
          List<String> localizedList =
              ProductData.ExpertProductsT(context)[category] ?? [];

          // Call _mapSimpleList for each category and its lists
          _mapSimpleList(arabicList, localizedList, categoryTranslations);
        });
        break;
      case "النقل":
        final transportCategories = ["نقل المواشي", "نقل المحاصيل", "نقل عام"];
        final localizedTransportCategories = [
          S.of(context).livestockTransport,
          S.of(context).cropTransport,
          S.of(context).generalTransport,
        ];
        _mapSimpleList(transportCategories, localizedTransportCategories,
            categoryTranslations);
        _mapSimpleList(ProductData.moyensDeTransport,
            ProductData.moyensDeTransportT(context), productTranslations);
        break;
      case "الإصلاحات":
        _mapSimpleList(ProductData.ReparationType,
            ProductData.reparationTypeT(context), categoryTranslations);
        break;
    }
  }

  // Map simple lists
  void _mapSimpleList(List<String> arabicList, List<String> localizedList,
      Map<String, String> targetMap) {
    for (int i = 0; i < arabicList.length && i < localizedList.length; i++) {
      targetMap[arabicList[i]] = localizedList[i];
    }
  }

  // Map categories and products from maps
  void _mapCategoryAndProducts(Map<String, List<String>> arabicCategoryMap,
      Map<String, List<String>> localizedCategoryMap,
      [Map<String, List<String>>? arabicSubMap,
      Map<String, List<String>>? localizedSubMap]) {
    // Map categories
    arabicCategoryMap.keys.toList().asMap().forEach((index, arabicKey) {
      if (index < localizedCategoryMap.keys.length) {
        String localizedKey = localizedCategoryMap.keys.toList()[index];
        categoryTranslations[arabicKey] = localizedKey;

        // Map products for this category
        List<String> arabicProducts = arabicCategoryMap[arabicKey] ?? [];
        List<String> localizedProducts =
            localizedCategoryMap[localizedKey] ?? [];

        for (int i = 0;
            i < arabicProducts.length && i < localizedProducts.length;
            i++) {
          productTranslations[arabicProducts[i]] = localizedProducts[i];
        }
      }
    });

    // Map subcategories if provided
    if (arabicSubMap != null && localizedSubMap != null) {
      arabicSubMap.keys.toList().asMap().forEach((index, arabicKey) {
        if (index < localizedSubMap.keys.length) {
          String localizedKey = localizedSubMap.keys.toList()[index];
          subCategoryTranslations[arabicKey] = localizedKey;

          // Map products for this subcategory
          List<String> arabicProducts = arabicSubMap[arabicKey] ?? [];
          List<String> localizedProducts = localizedSubMap[localizedKey] ?? [];

          for (int i = 0;
              i < arabicProducts.length && i < localizedProducts.length;
              i++) {
            productTranslations[arabicProducts[i]] = localizedProducts[i];
          }
        }
      });
    }
  }

  // Helper function to get localized value
  String getLocalizedValue(
      Map<String, String> translationMap, String? arabicValue) {
    if (arabicValue == null || arabicValue.isEmpty) return '';
    return translationMap[arabicValue] ?? arabicValue;
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

  // Create a new translated product from the original one
  Products getTranslatedItem() {
    final item = widget.item;

    // Create a new Products instance with the same properties but translated text fields
    Products translatedItem = Products(
      id: item.id,
      ownerId: item.ownerId,
      typeItem: getLocalizedValue(typeItemTranslations, item.typeItem),
      category: getLocalizedValue(categoryTranslations, item.category),
      subCategory: getLocalizedValue(subCategoryTranslations, item.subCategory),
      product: getLocalizedValue(productTranslations, item.product),
      quantity: item.quantity,
      surface: item.surface,
      unit: getLocalizedValue(unitTranslations, item.unit),
      service: getLocalizedValue(serviceTypeTranslations, item.service),
      price: item.price,
      description: item.description,
      comments: item.comments,
      photos: item.photos,
      liked: item.liked,
      disliked: item.disliked,
      date_of_add: item.date_of_add,
      wilaya: getLocalizedValue(wilayaTranslations, item.wilaya),
      daira: getLocalizedValue(dairaTranslations, item.daira),
      SP: item.SP,
    );

    return translatedItem;
  }

  // Method to navigate to detail page with translated item
  void navigateToDetailPage() {
    Products translatedItem = getTranslatedItem();

    if (widget.item.SP == "Service") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceDetailsPage(service: translatedItem),
        ),
      );
    } else if (widget.item.SP == "Product") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsPage(product: translatedItem),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    // Get localized values for display
    String? localizedCategory =
        getLocalizedValue(categoryTranslations, item.category);
    String? localizedSubCategory =
        getLocalizedValue(subCategoryTranslations, item.subCategory);
    String? localizedProduct =
        getLocalizedValue(productTranslations, item.product);
    String? localizedUnit = getLocalizedValue(unitTranslations, item.unit);
    String? localizedService =
        getLocalizedValue(serviceTypeTranslations, item.service);

    return GestureDetector(
      onTap: navigateToDetailPage, // Use the new navigation method
      child: Card(
        color: isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
                    image: item.photos!.isNotEmpty
                        ? NetworkImage(item.photos![0])
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
                    item.SP == "Service"
                        ? localizedCategory
                        : item.typeItem == "منتج زراعي"
                            ? localizedProduct != ""
                                ? localizedProduct
                                : localizedCategory != ""
                                    ? localizedCategory
                                    : localizedSubCategory
                            : item.typeItem == "منتج حيواني"
                                ? localizedProduct.isNotEmpty
                                    ? localizedProduct
                                    : localizedCategory
                                : item.typeItem == "منتج تجاري"
                                    ? localizedProduct
                                    : localizedCategory,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 5),
                  Text(
                    item.typeItem == "النقل" ||
                            item.typeItem == "الخبرة" ||
                            item.typeItem == "الإصلاحات"
                        ? S.of(context).available
                        : item.typeItem == "منتج زراعي" ||
                                item.typeItem == "منتج حيواني"
                            ? '${item.quantity?.toString()} ${localizedUnit}'
                            : item.typeItem == "منتج تجاري" &&
                                    item.category == "أراضي"
                                ? '${item.surface} ${localizedUnit}'
                                : item.typeItem == "منتج تجاري" &&
                                        item.category == "معدات"
                                    ? '${localizedService}'
                                    : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 5),
                  // Display price
                  if (item.SP == "Product")
                    Row(children: [
                      Text(
                        "${item.price}${S.of(context).dinar}/${localizedUnit}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ]),
                  (item.SP == "Service" && item.category == "أراضي")
                      ? Row(
                          children: [
                            Text(
                              "${item.price}${S.of(context).dinar}/${localizedUnit}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        )
                      : Text(
                          '${S.of(context).dinar} ${item.price}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                  const SizedBox(height: 7),

                  // Reactions for Service and Product
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("item")
                        .doc(item.SP == "Service" ? "Services" : "Products")
                        .collection(
                            item.SP == "Service" ? "Services" : "Products")
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
                            onTap:
                                navigateToDetailPage, // Use the translated item navigation
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
