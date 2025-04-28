import 'package:agriplant/Back_end/ServicesB/ExpertiseService.dart';
import 'package:agriplant/Back_end/ServicesB/RepairService.dart';
import 'package:agriplant/Back_end/ServicesB/TransportService.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:agriplant/Front_end/Item%20detaille/fullscreanimage.dart';
import 'package:agriplant/Front_end/Profile/userprofilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import '../../Back_end/ServicesB/Service.dart';

class ServiceDetailsPage extends StatefulWidget {
  final Service service;
  final VoidCallback? onUnsave;
  const ServiceDetailsPage({super.key, required this.service, this.onUnsave});

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  String? category;
  String? produit;

  late PageController _pageController;
  late TapGestureRecognizer readMoreGestureRecognizer;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode(); // إنشاء كائن التركيز
  bool showMore = false;
  Users user = Users();
  List<Service> services = List.empty();
  final TextEditingController controller = TextEditingController();

  bool isSaved = false;
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
    final service = widget.service;
    if (service is TransportService) {
      category = service.categorie;
    }
    if (service is ExpertiseService) {
      category = service.categorie;
    } else if (service is RepairService) {
      category = service.categorie;
      _checkIfSaved();
    }
  }

  /// Check if the item is saved
  Future<void> _checkIfSaved() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      // Ensure the 'saved' field is a list of strings (IDs)
      final savedList = List<String>.from(userDoc.data()?['saved'] ?? []);

      // Check if the item ID exists in the saved list
      final exists = savedList.contains(widget.service.id);

      if (exists && mounted) {
        setState(() {
          isSaved = true;
        });
      }
    }
  }

  Future<void> signaler(String categoryId, String selectedOption) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final itemId = widget.service.id;

      // Fetch product details
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('Services')
          .doc(widget.service
              .typeService) // 'Transportation' or 'Expertise'or'Repairs'
          .collection(widget.service.typeService)
          .doc(itemId) // The service ID
          .get();

      if (!productSnapshot.exists) {
        print('Service not found');
        return;
      }

      final molLanance = productSnapshot.get('ownerId'); // Get owner of product

      // Now store the signal
      await FirebaseFirestore.instance.collection('Signal').doc(uid).set({
        'li signala': uid,
        'Annonce': {
          'mol lanance : $molLanance':
              FieldValue.arrayUnion(['itemId : $itemId']),
          'itemId : $itemId': FieldValue.arrayUnion([selectedOption]),
          // molLanance as the key, and the array of Annonce as the value
        },
      }, SetOptions(merge: true)); // Important: Merge true!

      print('Signaled by $uid');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thanks for helping us with your signal 🙏'),
          duration: Duration(seconds: 5), // ⏳ 5 seconds
          behavior: SnackBarBehavior.floating, // (optional) makes it float
          backgroundColor:
              Color.fromARGB(255, 47, 114, 38), // (optional) success color
        ),
      );
    } catch (e) {
      print("there is a problem 'service detail page' $e");
    }
  }

  void showReportProblemDialog(BuildContext context) {
    TextEditingController otherController = TextEditingController();
    String selectedOption = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Report a Problem'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                reportOptionButton(
                  context: context,
                  label: 'Wrong Information',
                  selectedOption: selectedOption,
                  onPressed: () {
                    setState(() {
                      selectedOption = 'Wrong Information';
                    });
                  },
                ),
                const SizedBox(height: 10),
                reportOptionButton(
                  context: context,
                  label: 'Spam or Scam',
                  selectedOption: selectedOption,
                  onPressed: () {
                    setState(() {
                      selectedOption = 'Spam or Scam';
                    });
                  },
                ),
                const SizedBox(height: 10),
                reportOptionButton(
                  context: context,
                  label: 'Other',
                  selectedOption: selectedOption,
                  onPressed: () {
                    setState(() {
                      selectedOption = 'Other';
                    });
                  },
                ),
                const SizedBox(height: 10),
                if (selectedOption == 'Other') ...[
                  const SizedBox(height: 20),
                  TextField(
                    controller: otherController,
                    decoration: const InputDecoration(
                      labelText: 'Describe the problem',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ]
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  String reportText = selectedOption == 'Other'
                      ? otherController.text
                      : selectedOption;
                  signaler(widget.service.typeService, selectedOption);
                  print('Reported Problem: $reportText');
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

// Toggle the saved status
  Future<void> _toggleSavedStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userRef = FirebaseFirestore.instance.collection('Users').doc(uid);

    final itemId = widget.service.id; // Ensure item.id exists and is valid

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
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
    _pageController.dispose();
  }

  // دالة للتمرير إلى قسم التعليقات
  void _scrollToComments() {
    final commentsSectionKey = GlobalKey(); // تحديد المفتاح الخاص بالقسم
    if (commentsSectionKey.currentContext != null) {
      // التمرير إلى القسم باستخدام _scrollController
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
      return wilaya ?? 'غير محددة';
    }
  }

  Widget reportOptionButton({
    required BuildContext context,
    required String label,
    required String selectedOption,
    required VoidCallback onPressed,
  }) {
    final bool isSelected = label == selectedOption;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade200,
          foregroundColor:
              isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
          elevation: isSelected ? 4 : 0,
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

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
                title: const Text("Details"),
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
                ]),
            body: ListView(padding: const EdgeInsets.all(8), children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomCenter, // ✅ المؤشر في وسط الأسفل
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: widget.service.photos.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullScreenImageViewer(
                                  photos: widget.service.photos,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            // ❌ لا تستخدم margin bottom هنا حتى لا تدفع المؤشر للخارج
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    NetworkImage(widget.service.photos[index]),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12), // ✅ مسافة بسيطة من الأسفل
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: widget.service.photos.length,
                        effect: const WormEffect(
                          dotColor:
                              Colors.white70, // ✅ أفضل لون للنقاط فوق الصورة
                          activeDotColor: Colors.green,
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ جلب بيانات المستخدم الذي أضاف المنتج
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('Users')
                                .doc(widget.service.ownerId!.trim())
                                .get(),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (!userSnapshot.hasData ||
                                  !userSnapshot.data!.exists) {
                                print(
                                    "User document not found for ID${widget.service.ownerId}"); // ❌ طباعة إذا لم يتم العثور على المستخدم
                                return const Text("User not ");
                              }
                              var userData = userSnapshot.data!;
                              print(
                                  "User Data: ${userData.data()}"); // ✅ طباعة بيانات المستخدم للتحقق منها

                              String username =
                                  userData['first_name'] ?? "Unknown";

                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8, top: 8),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfilePage(
                                                    userId: widget
                                                        .service.ownerId!
                                                        .trim()),
                                          ),
                                        );
                                      },
                                      child: FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .get(),
                                        builder: (context, snapshot) {
                                          String? photoURL;

                                          // حالة حساب Google
                                          if (FirebaseAuth.instance.currentUser
                                                  ?.providerData
                                                  .any((provider) =>
                                                      provider.providerId ==
                                                      "google.com") ==
                                              true) {
                                            photoURL = FirebaseAuth
                                                .instance.currentUser?.photoURL;
                                          }
                                          // حالة التسجيل العادي + صورة من Firestore
                                          else if (snapshot.hasData &&
                                              snapshot.data!.exists) {
                                            photoURL =
                                                snapshot.data!.get('photo') ??
                                                    null;
                                          }

                                          return CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            backgroundImage: photoURL != null
                                                ? NetworkImage(photoURL)
                                                : null,
                                            child: photoURL == null
                                                ? Text(
                                                    FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                ?.displayName
                                                                ?.isNotEmpty ==
                                                            true
                                                        ? FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .displayName!
                                                            .substring(0, 1)
                                                            .toUpperCase()
                                                        : "U",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : null,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            timeago.format(widget.service.date_of_add.toLocal(),
                                locale: 'ar'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    // service information
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.service.typeService,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Type : ${widget.service.categorie}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (widget.service is TransportService) ...[
                            const SizedBox(height: 5),
                            Text(
                              "Moyen de transport : ${(widget.service as TransportService).moyenDeTransport ?? 'غير محدد'}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Wilaya : ${_getWilayaName((widget.service as TransportService).wilaya)}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Daira : ${(widget.service as TransportService).daira ?? 'غير محددة'}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                          if (widget.service is ExpertiseService) ...[
                            const SizedBox(height: 5),
                            Text(
                              "Type D'expertise : ${(widget.service as ExpertiseService).TypeC ?? 'غير محدد'}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Wilaya : ${_getWilayaName((widget.service as ExpertiseService).wilaya)}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Daira : ${(widget.service as ExpertiseService).daira ?? 'غير محددة'}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                          if (widget.service is RepairService) ...[
                            const SizedBox(height: 5),
                            Text(
                              "Wilaya : ${_getWilayaName((widget.service as RepairService).wilaya)}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Daira : ${(widget.service as RepairService).daira ?? 'غير محددة'}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    //description

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Description",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: showMore
                                      ? widget.service.description
                                      : (widget.service.description.length > 100
                                          ? '${widget.service.description.substring(0, 100)}...'
                                          : widget.service.description),
                                ),
                                TextSpan(
                                  recognizer: readMoreGestureRecognizer,
                                  text: showMore ? " Read less" : " Read more",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    //price and lik&dislike

                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // سعر المنتج
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "\DA${widget.service.price}",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),

                            // إضافة التفاعل مع الإعجابات والتعليقات
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Services')
                                  .doc(widget.service
                                      .typeService) // 'Transportation' or 'Expertise'or'Repairs'
                                  .collection(widget.service.typeService)
                                  .doc(widget.service.id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return const SizedBox();
                                }

                                List<dynamic> liked =
                                    snapshot.data!['liked'] ?? [];
                                List<dynamic> disliked =
                                    snapshot.data!['disliked'] ?? [];
                                String userId =
                                    FirebaseAuth.instance.currentUser?.uid ??
                                        "guest";
                                bool isLiked = liked.contains(userId);
                                bool isDisliked = disliked.contains(userId);

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // زر الإعجاب
                                    Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.thumb_up,
                                                size: 20,
                                                color: Users.isGuestUser()
                                                    ? (liked.isNotEmpty
                                                        ? Colors.green
                                                        : Colors
                                                            .grey) // If guest, show green if liked, grey if not
                                                    : (isLiked
                                                        ? Colors.green
                                                        : Colors.grey)),
                                            onPressed: () {
                                              if (Users.isGuestUser()) {
                                                // Show a message or handle the scenario where the guest cannot press the button
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.error_outline,
                                                          color: Colors.black,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            'Please log in to like or dislike items.',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    backgroundColor:
                                                        Color(0xFFFFCC31),
                                                  ),
                                                );
                                              } else {
                                                user.likeItem(widget.service);
                                              }
                                              ;
                                            }),
                                        Text(
                                          "${liked.length}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 5),

                                    // زر عدم الإعجاب
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.thumb_down,
                                              size: 20,
                                              color: Users.isGuestUser()
                                                  ? (disliked.isNotEmpty
                                                      ? Colors.red
                                                      : Colors
                                                          .grey) // If guest, show red if disliked, grey if not
                                                  : (isDisliked
                                                      ? Colors.red
                                                      : Colors.grey)),
                                          onPressed: () {
                                            if (Users.isGuestUser()) {
                                              // Show a message or handle the scenario where the guest cannot press the button
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.error_outline,
                                                        color: Colors.black,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Please log in to like or dislike items.',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor:
                                                      Color(0xFFFFCC31),
                                                ),
                                              );
                                            } else {
                                              // User is not a guest, allow them to dislike the item
                                              user.dislikeItem(widget.service);
                                            }
                                          },
                                        ),
                                        Text(
                                          "${disliked.length}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        )),

                    const SizedBox(height: 10),

                    //contact button :

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton.icon(
                            onPressed: () async {
                              if (!Users.isGuestUser()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        receiverId: widget.service.ownerId!),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.black,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'You need to log in to send a message.',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Color(0xFFFFCC31),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(IconlyLight.message),
                            label: const Text("Contact"),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          FilledButton.icon(
                            onPressed: () async {
                              DocumentSnapshot userDoc = await FirebaseFirestore
                                  .instance
                                  .collection('Users')
                                  .doc(widget.service.ownerId)
                                  .get();

                              String? phoneNumber;

                              if (userDoc.exists) {
                                phoneNumber = userDoc.get('phone');
                              }

                              if (phoneNumber != null &&
                                  phoneNumber.isNotEmpty) {
                                final Uri phoneUri =
                                    Uri(scheme: 'tel', path: phoneNumber);

                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.black,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'تعذر فتح تطبيق الاتصال',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Color(0xFFFFCC31),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.black,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'رقم الهاتف غير متوفر',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Color(0xFFFFCC31),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(IconlyLight.call),
                            label: const Text("Phone"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              //add a comment :

              // Hide the entire Container for guest users
              if (!Users.isGuestUser()) ...[
                // Only show this for logged-in users
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get(),
                        builder: (context, snapshot) {
                          String? photoURL;

                          // حالة حساب Google
                          if (FirebaseAuth.instance.currentUser?.providerData
                                  .any((provider) =>
                                      provider.providerId == "google.com") ==
                              true) {
                            photoURL =
                                FirebaseAuth.instance.currentUser?.photoURL;
                          }
                          // حالة التسجيل العادي + صورة من Firestore
                          else if (snapshot.hasData && snapshot.data!.exists) {
                            photoURL = snapshot.data!.get('photo') ?? null;
                          }

                          return CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: photoURL != null
                                ? NetworkImage(photoURL)
                                : null,
                            child: photoURL == null
                                ? Text(
                                    FirebaseAuth.instance.currentUser
                                                ?.displayName?.isNotEmpty ==
                                            true
                                        ? FirebaseAuth
                                            .instance.currentUser!.displayName!
                                            .substring(0, 1)
                                            .toUpperCase()
                                        : "U",
                                    style: const TextStyle(color: Colors.white),
                                  )
                                : null,
                          );
                        },
                      ),

                      const SizedBox(width: 10),

                      // حقل الإدخال (Input field) and زر الإرسال (Send button)
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          autofocus: false,
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "اكتب تعليقًا...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      // زر الإرسال (Send button)
                      IconButton(
                        icon: const Icon(Icons.send,
                            color: Color.fromARGB(255, 47, 114, 38)),
                        onPressed: () {
                          if (controller.text.isEmpty) {
                            user.showErrorDialog(
                                context, "You can't add an empty comment.");
                          } else {
                            user.addComment(
                              widget.service.id,
                              FirebaseAuth.instance.currentUser?.uid ?? "guest",
                              controller.text,
                              widget.service,
                            );
                            controller.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(
                height: 10,
              ),

              // قسم التعليقات
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text("Comments",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    // ✅ عرض التعليقات من Firestore
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Services')
                          .doc(widget.service
                              .typeService) // 'Transportation' or 'Expertise'or'Repairs'
                          .collection(widget.service.typeService)
                          .doc(widget.service.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Center(
                              child: Text("لا توجد تعليقات بعد."));
                        }

                        var data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        List<Map<String, dynamic>> comments = (data['comments']
                                is List)
                            ? List<Map<String, dynamic>>.from(
                                (data['comments'] as List).where((comment) =>
                                    comment is Map<String, dynamic> &&
                                    comment.containsKey("userId") &&
                                    comment.containsKey("text")))
                            : [];

                        if (comments.isEmpty) {
                          return const Center(
                              child: Text("لا توجد تعليقات بعد."));
                        }

                        return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('Users')
                              .get(),
                          builder: (context, userSnapshot) {
                            if (!userSnapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            // ✅ حفظ معلومات المستخدمين في خريطة واحدة
                            Map<String, Map<String, dynamic>> usersMap = {};
                            for (var doc in userSnapshot.data!.docs) {
                              usersMap[doc.id] =
                                  doc.data() as Map<String, dynamic>;
                            }

                            return ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> comment = comments[index];
                                String userId = comment['userId'];
                                String username = usersMap[userId]
                                        ?['first_name'] ??
                                    "مستخدم غير معروف";
                                String currentUserId =
                                    FirebaseAuth.instance.currentUser?.uid ??
                                        "guest";

                                String? photoURL = usersMap[userId]?['photo'];

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: GestureDetector(
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
                                        backgroundColor: Colors.grey,
                                        backgroundImage: photoURL != null
                                            ? NetworkImage(photoURL)
                                            : null,
                                        child: photoURL == null
                                            ? Text(
                                                username.isNotEmpty
                                                    ? username
                                                        .substring(0, 1)
                                                        .toUpperCase()
                                                    : "U",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            : null,
                                      ),
                                    ),
                                    title: Text(username),
                                    subtitle: Text(comment['text']),
                                    trailing: userId == currentUserId
                                        ? IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.grey),
                                            onPressed: () {
                                              // Assuming `user.showDeleteConfirmationDialog` exists
                                              user.showDeleteConfirmationDialog(
                                                context,
                                                itemId: widget.service.id,
                                                userId: currentUserId,
                                                text: comment['text'],
                                                item: widget.service,
                                              );
                                            },
                                          )
                                        : null,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ])));
  }
}
