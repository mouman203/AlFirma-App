import 'package:agriplant/Back_end/Products/Product.dart';
import 'package:agriplant/Back_end/Products/ProductAgri.dart';
import 'package:agriplant/Back_end/Products/ProductElev.dart';
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

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  final VoidCallback? onUnsave;
  const ProductDetailsPage({super.key, required this.product, this.onUnsave});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? category;
  String? produit;

  late PageController _pageController;
  late TapGestureRecognizer readMoreGestureRecognizer;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode(); // إنشاء كائن التركيز
  bool showMore = false;
  Users user = Users();
  List<Product> products = List.empty();
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
    final product = widget.product;
    if (product is Productagri) {
      category = product.category;
    } else if (product is ProductElev) {
      category = product.category;
    }
    _checkIfSaved();
  }

 // Check if the item is saved
Future<void> _checkIfSaved() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid != null) {
    final userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    
    // Ensure the 'saved' field is a list of strings (IDs)
    final savedList = List<String>.from(userDoc.data()?['saved'] ?? []);

    // Check if the item ID exists in the saved list
    final exists = savedList.contains(widget.product.id);

    if (exists && mounted) {
      setState(() {
        isSaved = true;
      });
    }
  }
}

// Toggle the saved status
Future<void> _toggleSavedStatus() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  final userRef = FirebaseFirestore.instance.collection('Users').doc(uid);

  final itemId = widget.product.id; // Ensure item.id exists and is valid

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
                IconButton(
                  onPressed: _toggleSavedStatus,
                  icon: Icon(
                    isSaved ? IconlyBold.bookmark : IconlyLight.bookmark,
                    color: isSaved ? colorScheme.primary : null,
                  ),
                ),
              ],
            ),
            body: ListView(padding: const EdgeInsets.all(8), children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomCenter, // ✅ المؤشر في وسط الأسفل
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: widget.product.photos.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullScreenImageViewer(
                                  photos: widget.product.photos,
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
                                    NetworkImage(widget.product.photos[index]),
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
                        count: widget.product.photos.length,
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
                                .doc(widget.product.ownerId!)
                                .get(),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (!userSnapshot.hasData ||
                                  !userSnapshot.data!.exists) {
                                print(
                                    "User document not found for ID${widget.product.ownerId}"); // ❌ طباعة إذا لم يتم العثور على المستخدم
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
                                                        .product.ownerId!
                                                        .trim()),
                                          ),
                                        );
                                      },
                                      child: FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(widget.product.ownerId!)
                                            .get(),
                                        builder: (context, snapshot) {
                                          String? photoURL;

                                           if (snapshot.hasData &&
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
                            timeago.format(widget.product.date_of_add.toLocal(),
                                locale: 'ar'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    // product information
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name : ${widget.product.name}",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Type : ${widget.product.typeProduct}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Category : ${category}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Wilaya : ${_getWilayaName(widget.product.wilaya)}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
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
                                      ? widget.product.description
                                      : (widget.product.description.length > 100
                                          ? '${widget.product.description.substring(0, 100)}...'
                                          : widget.product.description),
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
                                    text: "\DA${widget.product.price}",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),

                            // إضافة التفاعل مع الإعجابات والتعليقات
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Products') // اسم المجموعة
                                  .doc(widget.product.typeProduct ==
                                          "AgricolProduct"
                                      ? "Agricol_products"
                                      : "Eleveur_products")
                                  .collection(widget.product.typeProduct ==
                                          "AgricolProduct"
                                      ? "Agricol_products"
                                      : "Eleveur_products")
                                  .doc(widget.product.id)
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
                                              color: isLiked
                                                  ? const Color.fromARGB(
                                                      255, 47, 114, 38)
                                                  : Colors.grey),
                                          onPressed: () {
                                            user.likeItem(widget.product);
                                          },
                                        ),
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
                                              color: isDisliked
                                                  ? Colors.red
                                                  : Colors.grey),
                                          onPressed: () {
                                            user.dislikeItem(widget.product);
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
                                    const SizedBox(width: 5),

                                    // زر التعليق
                                    IconButton(
                                      icon: const Icon(Icons.comment,
                                          size: 20, color: Colors.grey),
                                      onPressed: () {
                                        print("Comment Clicked!");
                                      },
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        receiverId: widget.product.ownerId!),
                                  ),
                                );
                              },
                              icon: const Icon(IconlyLight.message),
                              label: const Text("Contact")),
                          const SizedBox(
                            width: 50,
                          ),
                          FilledButton.icon(
                            onPressed: () async {
                              DocumentSnapshot userDoc = await FirebaseFirestore
                                  .instance
                                  .collection('Users')
                                  .doc(widget.product.ownerId)
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
                                        content:
                                            Text('تعذر فتح تطبيق الاتصال')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('رقم الهاتف غير متوفر')),
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
                        if (FirebaseAuth.instance.currentUser?.providerData.any(
                                (provider) =>
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
                          backgroundImage:
                              photoURL != null ? NetworkImage(photoURL) : null,
                          child: photoURL == null
                              ? Text(
                                  FirebaseAuth.instance.currentUser?.displayName
                                              ?.isNotEmpty ==
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

                    // حقل الإدخال
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

                    // زر الإرسال
                    IconButton(
                      icon: const Icon(Icons.send,
                          color: Color.fromARGB(255, 47, 114, 38)),
                      onPressed: () {
                        if (controller.text.isEmpty) {
                          user.showErrorDialog(
                              context, "You can't add an empty comment");
                        } else {
                          user.addComment(
                              widget.product.id,
                              FirebaseAuth.instance.currentUser?.uid ?? "guest",
                              controller.text,
                              widget.product);
                          controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),

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
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Products')
                          .doc(widget.product.typeProduct == "AgricolProduct"
                              ? "Agricol_products"
                              : "Eleveur_products")
                          .collection(
                              widget.product.typeProduct == "AgricolProduct"
                                  ? "Agricol_products"
                                  : "Eleveur_products")
                          .doc(widget.product.id)
                          .snapshots(), // Ensure correct doc path here
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

                        // Use StreamBuilder for users to get real-time updates on users
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .snapshots(),
                          builder: (context, userSnapshot) {
                            if (!userSnapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            // Create a map of users for easy lookup
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
                                                itemId: widget.product.id,
                                                userId: currentUserId,
                                                text: comment['text'],
                                                item: widget.product,
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
