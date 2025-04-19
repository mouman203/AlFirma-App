import 'package:agriplant/Back_end/ExpertiseService.dart';
import 'package:agriplant/Back_end/RepairService.dart';
import 'package:agriplant/Back_end/Service.dart';
import 'package:agriplant/Back_end/TransportService.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:agriplant/Front_end/Product%20detaille/fullscreanimage.dart';
import 'package:agriplant/Front_end/userprofilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

class ServiceDetailsPage extends StatefulWidget {
  final Service service;
  const ServiceDetailsPage({super.key, required this.service});

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  String? category;
  String? service;

  late PageController _pageController;
  late TapGestureRecognizer readMoreGestureRecognizer;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
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

    final Service service = widget.service;
    if (service is TransportService) {
      category = service.categorie;
      this.service = service.service;
    }

    checkIfSaved();
  }

  Future<void> checkIfSaved() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Saved')
          .doc(widget.service.id)
          .get();

      setState(() {
        isSaved = doc.exists;
      });
    }
  }

  Future<void> toggleSave() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Saved')
        .doc(widget.service.id);

    if (isSaved) {
      await docRef.delete();
    } else {
      final service = widget.service;
      final serviceData = {
        'id': service.id,
        'categorie': service.categorie,
        'typeService': service.typeService,
        'price': service.price,
        'description': service.description,
        'rate': service.rate,
        'ownerId': service.ownerId,
        'comments': service.comments,
        'photos': service.photos,
        'liked': service.liked,
        'disliked': service.disliked,
        'date_of_add': Timestamp.fromDate(service.date_of_add),
      };

      if (service is ExpertiseService) {
        serviceData['TypeC'] = service.TypeC;
        serviceData['wilaya'] = service.wilaya;
        serviceData['daira'] = service.daira;
      } else if (service is TransportService) {
        serviceData['moyenDeTransport'] = service.moyenDeTransport;
        serviceData['wilaya'] = service.wilaya;
        serviceData['daira'] = service.daira;
      } else if (service is RepairService) {
        serviceData['wilaya'] = service.wilaya;
        serviceData['daira'] = service.daira;
      }

      await docRef.set(serviceData);
    }

    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
    _pageController.dispose();
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
      return wilaya ?? 'غير محددة';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      onTapCancel: () => _focusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Details"),
          backgroundColor: isDarkMode ? colorScheme.surface : colorScheme.surface,
          elevation: 5,
          actions: [
            IconButton(
              onPressed: toggleSave,
              icon: Icon(
                isSaved ? IconlyBold.bookmark : IconlyLight.bookmark,
                color: isSaved ? colorScheme.primary : null,
              ),
            ),
          ],
        ),
            body: ListView(padding: const EdgeInsets.all(16), children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomCenter,
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
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: widget.service.photos.length,
                        effect: const WormEffect(
                          dotColor: Colors.white70,
                          activeDotColor: Colors.green,
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // User Info
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
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
                            return const Text("User not found");
                          }
                          var userData = userSnapshot.data!;
                          String username = userData['first_name'] ?? "Unknown";
                          String userProfilePic = userData['photo'] ?? '';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserProfilePage(
                                            userId:
                                                widget.service.ownerId!.trim()),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: userProfilePic.isNotEmpty
                                        ? NetworkImage(userProfilePic)
                                        : null,
                                    child: userProfilePic.isEmpty
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(username,
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
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
              ),

              const SizedBox(height: 10),
              // Service info
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.service.typeService}",
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
                      if  (widget.service is ExpertiseService) ...[
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
                      if  (widget.service is RepairService) ...[
                       
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
              ),

              const SizedBox(height: 10),
              // Description
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              // Price and likes/dislikes
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "\DA${widget.service.price}",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        // Likes/Dislikes
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
                              return const SizedBox();
                            }

                            List<dynamic> liked = snapshot.data!['liked'] ?? [];
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
                                              ? Color.fromARGB(255, 47, 114, 38)
                                              : Colors.grey),
                                      onPressed: () {
                                        user.likeService(widget.service);
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
                                        user.dislikeService(widget.service);
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
              ),

              const SizedBox(height: 10),

              //contact button :

              FilledButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatPage(receiverId: widget.service.ownerId!),
                      ),
                    );
                  },
                  icon: const Icon(IconlyLight.message),
                  label: const Text("Contact")),

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
                    // أيقونة المستخدم (أول حرف من الاسم)
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          FirebaseAuth.instance.currentUser?.photoURL != null
                              ? NetworkImage(
                                  FirebaseAuth.instance.currentUser!.photoURL!)
                              : null,
                      child: FirebaseAuth.instance.currentUser?.photoURL == null
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
                          user.addSComment(
                              widget.service.id,
                              FirebaseAuth.instance.currentUser?.uid ?? "guest",
                              controller.text,
                              widget.service.typeService);
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
                    return const Center(child: Text("لا توجد تعليقات بعد."));
                  }

                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  List<Map<String, dynamic>> comments =
                      (data['comments'] is List)
                          ? List<Map<String, dynamic>>.from(
                              (data['comments'] as List).where((comment) =>
                                  comment is Map<String, dynamic> &&
                                  comment.containsKey("userId") &&
                                  comment.containsKey("text")))
                          : [];

                  if (comments.isEmpty) {
                    return const Center(child: Text("لا توجد تعليقات بعد."));
                  }

                  return FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance.collection('Users').get(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // ✅ حفظ معلومات المستخدمين
                      Map<String, Map<String, dynamic>> usersMap = {};
                      for (var doc in userSnapshot.data!.docs) {
                        usersMap[doc.id] = doc.data() as Map<String, dynamic>;
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> comment = comments[index];
                          String userId = comment['userId'];
                          String username = usersMap[userId]?['first_name'] ??
                              "مستخدم غير معروف";
                          String userPhoto = usersMap[userId]?['photo'] ?? "";
                          String currentUserId =
                              FirebaseAuth.instance.currentUser?.uid ?? "guest";

                          return Card(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            margin: const EdgeInsets.only(bottom: 10),
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
                                  radius: 20,
                                  backgroundImage: userPhoto.isNotEmpty
                                      ? NetworkImage(userPhoto)
                                      : null,
                                  child: userPhoto.isEmpty
                                      ? const Icon(Icons.person)
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
                                        user.showDeleteConfirmationDialogS(
                                          context,
                                          widget.service.id,
                                          currentUserId,
                                          comment['text'],
                                          widget.service.typeService,
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
            ])));
  }
}
