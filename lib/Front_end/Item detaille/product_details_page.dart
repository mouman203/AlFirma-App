import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:agriplant/Front_end/Item%20detaille/fullscreanimage.dart';
import 'package:agriplant/Front_end/Profile/userprofilepage.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsPage extends StatefulWidget {
  final Products product;
  final VoidCallback? onUnsave;

  const ProductDetailsPage({super.key, required this.product, this.onUnsave});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  // ====== State variables ======
  String? category;
  late PageController _pageController;
  late TapGestureRecognizer readMoreGestureRecognizer;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool showMore = false;
  Users user = Users();
  List<Products> products = List.empty();
  final TextEditingController controller = TextEditingController();
  bool isSaved = false;

  // ====== Lifecycle methods ======
  @override
  void initState() {
    super.initState();
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showMore = !showMore;
        });
      };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToComments();
    });

    _pageController = PageController();
    category = widget.product.category;
    _checkIfSaved();

    // Configure timeago locales
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('ar', timeago.ArMessages());
  }

  @override
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
    _pageController.dispose();
    controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
  }

  // ====== Helper methods ======
  Future<void> _checkIfSaved() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      final savedList = List<String>.from(userDoc.data()?['saved'] ?? []);
      final exists = savedList.contains(widget.product.id);

      if (exists && mounted) {
        setState(() {
          isSaved = true;
        });
      }
    }
  }

  void _scrollToComments() {
    final commentsSectionKey = GlobalKey();
    if (commentsSectionKey.currentContext != null) {
      _scrollController.animateTo(
        commentsSectionKey.currentContext!
            .findRenderObject()!
            .getTransformTo(null)
            .getTranslation()
            .y,
        duration: const Duration(seconds: 1),
        curve: Curves.ease,
      );
    }
  }

  String _getWilayaName(String? wilaya) {
    if (wilaya != null && wilaya.contains(" - ")) {
      return wilaya.split(" - ")[1];
    } else {
      return wilaya ?? S.of(context).unspecified;
    }
  }

  // ====== Action methods ======
  Future<void> _toggleSavedStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userRef = FirebaseFirestore.instance.collection('Users').doc(uid);
    final itemId = widget.product.id;

    if (isSaved) {
      await userRef.update({
        'saved': FieldValue.arrayRemove([itemId])
      });
      setState(() => isSaved = false);
      widget.onUnsave?.call();
    } else {
      await userRef.update({
        'saved': FieldValue.arrayUnion([itemId])
      });
      setState(() => isSaved = true);
    }
  }

  Future<void> signaler(String categoryId, String selectedOption) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final itemId = widget.product.id;

      // Fetch product details
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('item')
          .doc('Products')
          .collection('Products')
          .doc(itemId)
          .get();

      if (!productSnapshot.exists) {
        print('Product not found');
        return;
      }

      final target = productSnapshot.get('ownerId');

      // Map for Arabic values
      final Map<String, String> reportOptionsArabic = {
        S.of(context).reportWrongInfo: 'معلومات خاطئة',
        S.of(context).reportSpam: 'بريد عشوائي أو احتيال',
        S.of(context).reportOther: 'أخرى',
      };

      final selectedOptionArabic =
          reportOptionsArabic[selectedOption] ?? selectedOption;

      // Save signal
      await FirebaseFirestore.instance.collection('Signal').doc(uid).set({
        'Signaler': uid,
        'post': {
          'Target  : $target': FieldValue.arrayUnion(['itemId : $itemId']),
          'itemId : $itemId': FieldValue.arrayUnion([selectedOptionArabic]),
        },
      }, SetOptions(merge: true));

      print('Signaled by $uid');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
         content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  S.of(context).reportConfirmation,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Color.fromARGB(255, 54, 126, 44),
        ),
      );
    } catch (e) {
      print("there is a problem 'product detail page' $e");
    }
  }

  // ====== UI components ======
  Widget reportOptionButton({
    required BuildContext context,
    required String label,
    required String selectedOption,
    required VoidCallback onPressed,
  }) {
    final bool isSelected = label == selectedOption;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor: isSelected
              ? isDarkMode
                  ? Colors.black
                  : Colors.white
              : Theme.of(context).colorScheme.primary,
          elevation: isSelected ? 4 : 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: TextStyle(fontSize: 18)),
      ),
    );
  }

  void showReportProblemDialog(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    TextEditingController otherController = TextEditingController();
    String selectedOption = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(S.of(context).reportAProblem,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                reportOptionButton(
                  context: context,
                  label: S.of(context).reportWrongInfo,
                  selectedOption: selectedOption,
                  onPressed: () {
                    setState(() {
                      selectedOption = S.of(context).reportWrongInfo;
                    });
                  },
                ),
                const SizedBox(height: 12),
                reportOptionButton(
                  context: context,
                  label: S.of(context).reportSpam,
                  selectedOption: selectedOption,
                  onPressed: () {
                    setState(() {
                      selectedOption = S.of(context).reportSpam;
                    });
                  },
                ),
                const SizedBox(height: 12),
                reportOptionButton(
                  context: context,
                  label: S.of(context).reportOther,
                  selectedOption: selectedOption,
                  onPressed: () {
                    setState(() {
                      selectedOption = S.of(context).reportOther;
                    });
                  },
                ),
                const SizedBox(height: 12),
                if (selectedOption == S.of(context).reportOther) ...[
                  const SizedBox(height: 6),
                  TextField(
                    controller: otherController,
                    decoration: InputDecoration(
                      labelText: S.of(context).describeProblem,
                      labelStyle: TextStyle(
                        color:
                            isDarkMode ? Color(0xFF90D5AE) : Color(0xFF256C4C),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: isDarkMode
                              ? Color(0xFF90D5AE)
                              : Color(0xFF256C4C),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: isDarkMode
                                ? Color(0xFF90D5AE)
                                : Color(0xFF256C4C),
                            width: 2),
                      ),
                    ),
                    maxLines: 4,
                  ),
                ]
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  children: [
                    // Cancel Button (Red, Left)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor:
                              isDarkMode ? Colors.white : Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          S.of(context).cancel,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14), // Space between buttons

                    // Submit Button (Green, Right)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          String reportText =
                              selectedOption == S.of(context).reportOther
                                  ? otherController.text
                                  : selectedOption;
                          signaler(widget.product.typeItem, selectedOption);
                          print('Reported Problem: $reportText');
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                          foregroundColor:
                              isDarkMode ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          S.of(context).submit,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // ====== Main build method ======
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        onTapCancel: () {
          _focusNode.unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).details,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor:
                  isDarkMode ? colorScheme.surface : colorScheme.surface,
              elevation: 5,
              actions: [
                if (!Users.isGuestUser()) ...[
                  IconButton(
                    onPressed: () async {
                      showReportProblemDialog(context);
                    },
                    icon: Icon(
                      Icons.report_problem_outlined,
                      size: 29,
                      color: isDarkMode
                          ? colorScheme.onSurface
                          : colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleSavedStatus,
                    icon: Icon(
                      isSaved ? IconlyBold.bookmark : IconlyLight.bookmark,
                      color: isSaved ? colorScheme.primary : null,
                    ),
                  ),
                ]
              ],
            ),
            body: ListView(padding: const EdgeInsets.all(16), children: [
              // Product Image Gallery
              _buildProductImageGallery(isDarkMode, colorScheme),

              const SizedBox(height: 16),

              // Product Info Card
              _buildProductInfoCard(isDarkMode, theme),

              const SizedBox(height: 16),

              // Comment Input (Only for logged-in users)
              if (!Users.isGuestUser()) _buildCommentInput(isDarkMode),

              const SizedBox(height: 16),

              // Comments Section
              _buildCommentsSection(isDarkMode),
            ])));
  }

  // ====== Component build methods ======
  Widget _buildProductImageGallery(bool isDarkMode, ColorScheme colorScheme) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.product.photos!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewer(
                          photos: widget.product.photos!,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: "product_image_${widget.product.id}_$index",
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.product.photos![index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: widget.product.photos!.length,
                effect: WormEffect(
                  dotColor: Colors.grey.shade300,
                  activeDotColor: isDarkMode
                      ? const Color(0xFF90D5AE)
                      : const Color(0xFF256C4C),
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfoCard(bool isDarkMode, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User profile section
          _buildUserProfileSection(isDarkMode),

          const Divider(height: 1, thickness: 1),

          // Product details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.typeItem != S.of(context).commercialProduct
                      ? "${S.of(context).productLabel} ${widget.product.product}"
                      : widget.product.product ?? "",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  isDarkMode,
                  Icons.category_outlined,
                  "${S.of(context).categoryLabel} $category",
                ),
                if (widget.product.subCategory != "") ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    isDarkMode,
                    Icons.tag_outlined,
                    "${S.of(context).subCategoryLabel} ${widget.product.subCategory}",
                  ),
                ],
                if (widget.product.service != "") ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    isDarkMode,
                    Icons.sell,
                    " ${widget.product.service}",
                  ),
                ],
                const SizedBox(height: 8),
                _buildInfoRow(
                  isDarkMode,
                  Icons.location_on_outlined,
                  "${S.of(context).locationLabel} ${_getWilayaName(widget.product.wilaya)} (${widget.product.daira})",
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // Description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).description,
                    style: theme.textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyLarge,
                    children: [
                      TextSpan(
                        text: showMore
                            ? widget.product.description
                            : (widget.product.description!.length > 100
                                ? '${widget.product.description!.substring(0, 100)}...'
                                : widget.product.description),
                      ),
                      TextSpan(
                        recognizer: readMoreGestureRecognizer,
                        text: widget.product.description!.length > 100
                            ? (showMore
                                ? S.of(context).readLess
                                : S.of(context).readMore)
                            : "",
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // Price and interactions
          _buildPriceAndInteractions(isDarkMode, theme),

          const Divider(height: 1, thickness: 1),

          // Contact buttons
          _buildContactButtons(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.product.ownerId!)
            .get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Text("User not found");
          }

          var userData = userSnapshot.data!;
          String username = userData['first_name'] ?? S.of(context).unknown;
          String? photoURL = userData['photo'];

          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(
                          userId: widget.product.ownerId!.trim()),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: (photoURL != null && photoURL.isNotEmpty)
                      ? NetworkImage(photoURL)
                      : (isDarkMode
                              ? const AssetImage("assets/anonymeD.png")
                              : const AssetImage("assets/anonyme.png"))
                          as ImageProvider,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // 👈 Key line
                  children: [
                    Text(
                      username,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      timeago.format(
                        widget.product.date_of_add!.toLocal(),
                        locale: Localizations.localeOf(context).languageCode,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(bool isDarkMode, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: isDarkMode ? const Color(0xFF90D5AE) : const Color(0xFF256C4C),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndInteractions(bool isDarkMode, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF90D5AE).withOpacity(0.2)
                  : const Color(0xFF256C4C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${widget.product.price}${S.of(context).dinar}/ ${widget.product.unit}",
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Like/Dislike
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('item')
                .doc("Products")
                .collection("Products")
                .doc(widget.product.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const SizedBox();
              }

              List<dynamic> liked = snapshot.data!['liked'] ?? [];
              List<dynamic> disliked = snapshot.data!['disliked'] ?? [];
              String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";
              bool isLiked = liked.contains(userId);
              bool isDisliked = disliked.contains(userId);

              return Row(
                children: [
                  // Like button with count
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.thumb_up,
                          size: 22,
                          color: Users.isGuestUser()
                              ? (liked.isNotEmpty ? Colors.green : Colors.grey)
                              : (isLiked ? Colors.green : Colors.grey),
                        ),
                        onPressed: () {
                          if (Users.isGuestUser()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.black),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        S.of(context).loginToLike,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 247, 234, 117),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          } else {
                            user.likeItem(widget.product);
                          }
                        },
                      ),
                      Text(
                        "${liked.length}",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // Dislike button with count
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.thumb_down,
                          size: 22,
                          color: Users.isGuestUser()
                              ? (disliked.isNotEmpty ? Colors.red : Colors.grey)
                              : (isDisliked ? Colors.red : Colors.grey),
                        ),
                        onPressed: () {
                          if (Users.isGuestUser()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.black),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        S.of(context).loginToLike,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 210, 75),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          } else {
                            user.dislikeItem(widget.product);
                          }
                        },
                      ),
                      Text(
                        "${disliked.length}",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactButtons(bool isDarkMode) {
    void showLoginRequiredSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.black),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.black, fontSize: 19),
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 255, 210, 75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Chat button
          Expanded(
            child: FilledButton.icon(
              onPressed: () {
                if (!Users.isGuestUser()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatPage(receiverId: widget.product.ownerId!),
                    ),
                  );
                } else {
                  showLoginRequiredSnackbar(S.of(context).loginToMessage);
                }
              },
              icon: const Icon(IconlyLight.message, size: 20),
              label: Text(
                S.of(context).chat,
                style: const TextStyle(fontSize: 16),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
                foregroundColor: isDarkMode ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Call button
          Expanded(
            child: FilledButton.icon(
              onPressed: () async {
                if (Users.isGuestUser()) {
                  showLoginRequiredSnackbar(S.of(context).loginToCall);
                } else {
                  final ownerDoc = await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(widget.product.ownerId)
                      .get();

                  final phoneNumber = ownerDoc.data()?['phone'];

                  if (phoneNumber != null && phoneNumber.isNotEmpty) {
                    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
                    try {
                      await launchUrl(phoneUri);
                    } catch (e) {
                      print('Could not launch phone: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red, // Red background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          content: Row(
                            children: [
                              const Icon(Icons.report_problem_outlined,
                                  color: Colors.black),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  S.of(context).cannotOpenDialer,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red, // Red background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        content: Row(
                          children: [
                            const Icon(Icons.report_problem_outlined,
                                color: Colors.black),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                S.of(context).noPhoneNumber,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(IconlyLight.call, size: 20),
              label: Text(
                S.of(context).call,
                style: const TextStyle(fontSize: 16),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
                foregroundColor: isDarkMode ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(bool isDarkMode) {
    final user = FirebaseAuth.instance.currentUser;
    final photoURL = user?.photoURL ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// CircleAvatar
              CircleAvatar(
                radius: 20,
                backgroundImage: (photoURL.isNotEmpty)
                    ? NetworkImage(photoURL)
                    : (isDarkMode
                            ? const AssetImage("assets/anonymeD.png")
                            : const AssetImage("assets/anonyme.png"))
                        as ImageProvider,
              ),
              const SizedBox(width: 8),

              /// TextField
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: _focusNode,
                  onChanged: (_) => setState(() {}), // Rebuild on text change
                  decoration: InputDecoration(
                    hintText: S.of(context).writeComment,
                    hintStyle: TextStyle(
                        color: isDarkMode
                            ? Colors.grey.shade500
                            : const Color.fromARGB(255, 120, 120, 120)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                  minLines: 1,
                ),
              ),
              const SizedBox(width: 8),

              /// Send Button - only shown if there's text
              if (controller.text.trim().isNotEmpty)
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      try {
                        if (user == null) return;

                        final commentText = controller.text.trim();
                        final productRef = FirebaseFirestore.instance
                            .collection('item')
                            .doc('Products')
                            .collection('Products')
                            .doc(widget.product.id);

                        final newComment = {
                          'userId': user.uid,
                          'text': commentText,
                          'timestamp': Timestamp.now(),
                        };

                        await productRef.update({
                          'comments': FieldValue.arrayUnion([newComment])
                        });

                        controller.clear();
                        _focusNode.unfocus();

                        // Make sure to call setState after clearing
                        setState(() {});
                      } catch (e) {
                        print('Error adding comment: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              S.of(context).errorAddingComment,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      IconlyLight.send,
                      color: isDarkMode ? Colors.black : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).comments,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('item')
                .doc('Products')
                .collection('Products')
                .doc(widget.product.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(IconlyLight.chat,
                            size: 48,
                            color: isDarkMode
                                ? Colors.grey
                                : const Color.fromARGB(255, 94, 94, 94)),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).noCommentsYet,
                          style: TextStyle(
                              fontSize: 18,
                              color: isDarkMode
                                  ? Colors.grey
                                  : const Color.fromARGB(255, 94, 94, 94)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              var productData = snapshot.data!.data() as Map<String, dynamic>;
              List<dynamic> comments = productData['comments'] ?? [];

              // Sort comments by timestamp (newest first)
              comments.sort((a, b) {
                Timestamp? timestampA = a['timestamp'] as Timestamp?;
                Timestamp? timestampB = b['timestamp'] as Timestamp?;
                if (timestampA == null && timestampB == null) return 0;
                if (timestampA == null) return 1;
                if (timestampB == null) return -1;
                return timestampB.compareTo(timestampA);
              });

              if (comments.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(IconlyLight.chat,
                            size: 48,
                            color: isDarkMode
                                ? Colors.grey
                                : const Color.fromARGB(255, 94, 94, 94)),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).noCommentsYet,
                          style: TextStyle(
                              fontSize: 18,
                              color: isDarkMode
                                  ? Colors.grey
                                  : const Color.fromARGB(255, 94, 94, 94)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                separatorBuilder: (context, index) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  var commentData = comments[index];
                  String userId = commentData['userId'] ?? '';
                  String text = commentData['text'] ?? '';
                  Timestamp? timestamp = commentData['timestamp'] as Timestamp?;

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(userId)
                        .get(),
                    builder: (context, userSnapshot) {
                      String username = S.of(context).unknown;
                      String? photoURL;

                      if (userSnapshot.hasData && userSnapshot.data!.exists) {
                        var userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        username =
                            userData['first_name'] ?? S.of(context).unknown;
                        photoURL = userData['photo'];
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserProfilePage(userId: userId),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage:
                                  (photoURL != null && photoURL.isNotEmpty)
                                      ? NetworkImage(photoURL)
                                      : (isDarkMode
                                              ? const AssetImage(
                                                  "assets/anonymeD.png")
                                              : const AssetImage(
                                                  "assets/anonyme.png"))
                                          as ImageProvider,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      username,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          timestamp != null
                                              ? timeago.format(
                                                  timestamp.toDate(),
                                                  locale:
                                                      Localizations.localeOf(
                                                              context)
                                                          .languageCode,
                                                )
                                              : "",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isDarkMode
                                                ? Colors.grey
                                                : const Color.fromARGB(
                                                    255, 94, 94, 94),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (userId ==
                                            FirebaseAuth
                                                .instance.currentUser?.uid)
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                size: 20, color: Colors.red),
                                            onPressed: () {
                                              user.showDeleteConfirmationDialog(
                                                context,
                                                itemId: widget.product.id!,
                                                userId: userId,
                                                text: text,
                                                item: widget.product,
                                              );
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    text,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
