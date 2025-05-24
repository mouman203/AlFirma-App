import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Profile/userprofilepage.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:agriplant/widgets_UI/Item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatefulWidget {
  final String otherUserId;
  final Products product;

  const ChatPage({super.key, required this.otherUserId, required this.product});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  late String MyID;
  late String otherUserId;
  String? offer;

  String otherUserName = "Loading...";
  String otherUserPhotoUrl = "";

  @override
  void initState() {
    super.initState();

    MyID = _auth.currentUser!.uid;
    otherUserId = widget.otherUserId;
    _UsersInfo();
    _fetchUserNameAndPhoto();
    //fetchUserOffer();
    //_isSold();
  }

  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      //receiver information
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 5,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserProfilePage(userId: widget.otherUserId),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: otherUserPhotoUrl.isNotEmpty
                    ? NetworkImage(otherUserPhotoUrl)
                    : (isDarkMode
                            ? const AssetImage("assets/anonymeD.png")
                            : const AssetImage("assets/anonyme.png"))
                        as ImageProvider,
                radius: 20,
              ),
              const SizedBox(width: 14),
              Text(
                otherUserName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          widget.product.sell!
              ? IconButton(
                  icon: Icon(
                    Icons.phone,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () async {
                    if (Users.isGuestUser()) {
                      showLoginRequiredSnackbar(S.of(context).loginToCall);
                    } else {
                      final callWho =
                          _auth.currentUser!.uid == widget.product.ownerId
                              ? widget.otherUserId
                              : widget.product.ownerId;
                      final ownerDoc = await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(callWho)
                          .get();

                      final phoneNumber = ownerDoc.data()?['phone'];

                      if (phoneNumber != null && phoneNumber.isNotEmpty) {
                        final Uri phoneUri =
                            Uri(scheme: 'tel', path: phoneNumber);
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
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.phone,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )
        ],
      ),

      //The chat box
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDarkMode ? 'assets/background2.png' : 'assets/background1.png',
            ),
            repeat: ImageRepeat.repeat,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product card
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? scheme.onSecondary
                      : scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  // اختياري للتجميل
                ),
                child: ItemCard(item: widget.product),
              ),
            ),
            // Chat messages
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("Messages")
                    .where("productid", isEqualTo: widget.product.id)
                    .where(
                      Filter.or(
                        Filter.and(
                          Filter("senderId", isEqualTo: MyID),
                          Filter("receiverId", isEqualTo: otherUserId),
                        ),
                        Filter.and(
                          Filter("senderId", isEqualTo: otherUserId),
                          Filter("receiverId", isEqualTo: MyID),
                        ),
                      ),
                    )
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child:
                            Text(S.of(context).noMessages)); // localized text
                  }
                  print("📥 Messages: ${snapshot.data!.docs.length}");

                  _markMessagesAsSeen(snapshot.data!);

                  var messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      var msg = messages[index].data() as Map<String, dynamic>;
                      bool isMe = msg["senderId"] == _auth.currentUser!.uid;

                      return Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMe)
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 4.0, bottom: 4),
                              child: CircleAvatar(
                                radius: 16,
                                backgroundImage: otherUserPhotoUrl.isNotEmpty
                                    ? NetworkImage(otherUserPhotoUrl)
                                    : (isDarkMode
                                            ? const AssetImage(
                                                "assets/anonymeD.png")
                                            : const AssetImage(
                                                "assets/anonyme.png"))
                                        as ImageProvider,
                              ),
                            ),
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? (isDarkMode
                                        ? const Color(0xFF90D5AE)
                                        : const Color(0xFF256C4C))
                                    : (isDarkMode
                                        ? const Color(0xFFE6E6E6)
                                        : const Color.fromARGB(
                                            255, 72, 72, 72)),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(isMe ? 16 : 0),
                                  bottomRight: Radius.circular(isMe ? 0 : 16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    msg["content"],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isMe)
                                        Icon(
                                          Icons.done_all,
                                          size: 18,
                                          color: msg["isSeen"]
                                              ? (isDarkMode
                                                  ? const Color(0xFF1B503A)
                                                  : const Color(0xFF64B58B))
                                              : (isDarkMode
                                                  ? Colors.black54
                                                  : Colors.white70),
                                        ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatTimestamp(msg["timestamp"]),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkMode
                                              ? Colors.black54
                                              : Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // Message input field
            (widget.product.sell ?? false)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? scheme.onSecondary
                                  : scheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: S.of(context).messageHint,
                                hintStyle: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 19),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                          radius: 25,
                          child: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ],
                    ),
                  )
                : widget.product.ownerId == _auth.currentUser!.uid
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? scheme.onSecondary
                                : scheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "User proposed: $offer DA",
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      print("✅ Accept button pressed");
                                      _UsersInfo();
                                      print("MyID: $MyID");
                                      print("otherUserId: $otherUserId");
                                      print("Product ID: ${widget.product.id}");
                                      // TODO: Accept logic
                                      final querySnapshot =
                                          await FirebaseFirestore.instance
                                              .collection("item")
                                              .doc("offers")
                                              .collection("offers")
                                              .where("senderId",
                                                  isEqualTo: MyID)
                                              .where("productid",
                                                  isEqualTo: widget.product.id)
                                              .where("receiverId",
                                                  isEqualTo: otherUserId)
                                              .get();
                                      final querySnapshotproduct =
                                          await FirebaseFirestore.instance
                                              .collection("item")
                                              .doc("Products")
                                              .collection("Products")
                                              .where("id",
                                                  isEqualTo: widget.product.id)
                                              .get();

                                      if (querySnapshot.docs.isNotEmpty) {
                                        final doc = querySnapshot.docs.first;
                                        final productdoc =
                                            querySnapshotproduct.docs.first;

                                        // ✅ Update 'accepted' field in Firestore
                                        await doc.reference
                                            .update({'accepted': true});
                                        // ✅ Update 'sell' field in Firestore
                                        await productdoc.reference
                                            .update({'sell': true});

                                        print(
                                            "✅ Offer accepted and updated in Firestore: ${doc.data()['content']}");
                                        setState(() {
                                          widget.product.sell = true;
                                        });
                                      } else {
                                        print("❌ document is empty");
                                      }
                                    },
                                    icon: const Icon(Icons.check),
                                    label: const Text("Accept"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO: Refuse logic
                                    },
                                    icon: const Icon(Icons.close),
                                    label: const Text("Refuse"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? scheme.onSecondary
                              : scheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product Price: ${widget.product.price} DA",
                              style: TextStyle(
                                fontSize: 18,
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _messageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Propose your offer...",
                                hintStyle: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.black54,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  try {
                                    // مرجع للـ Collection الجديد
                                    final offersCollectionRef =
                                        FirebaseFirestore.instance
                                            .collection("item")
                                            .doc("offers")
                                            .collection("offers");
                                    if (widget.product.id == null) {
                                      print("❌ Product ID is null");
                                      return;
                                    }
                                    // التحقق مما إذا كان هناك عرض سابق من نفس المرسل لنفس المنتج
                                    final existingOffersQuery =
                                        await offersCollectionRef
                                            .where("productid",
                                                isEqualTo: widget.product.id)
                                            .where("senderId", isEqualTo: MyID)
                                            .get();

                                    if (existingOffersQuery.docs.isNotEmpty) {
                                      // يوجد عرض سابق → تحديثه
                                      final existingDocRef = existingOffersQuery
                                          .docs.first.reference;

                                      await existingDocRef.update({
                                        "accepted": false,
                                        "content": _messageController.text,
                                        "timestamp": Timestamp.now(),
                                      });

                                      print("🔁 تم تحديث العرض السابق");
                                      print("Product ID: ${widget.product.id}");
                                      print("Sender ID: $MyID");
                                      print(
                                          "Receiver ID: ${widget.otherUserId}");
                                    } else {
                                      // لا يوجد عرض سابق → إنشاء جديد
                                      await offersCollectionRef.add({
                                        "productid": widget.product.id,
                                        "senderId": MyID,
                                        "receiverId": widget.otherUserId,
                                        "content": _messageController.text,
                                        "accepted": false,
                                        "timestamp": Timestamp.now(),
                                      });

                                      print("🆕 تم إضافة عرض جديد");
                                      print("Product ID: ${widget.product.id}");
                                      print("Sender ID: $MyID");
                                      print(
                                          "Receiver ID: ${widget.otherUserId}");
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Offer send successfully.")),
                                    );
                                    _messageController.clear();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Error: $e")),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDarkMode
                                      ? const Color(0xFF90D5AE)
                                      : const Color(0xFF256C4C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                icon: const Icon(Icons.send),
                                label: const Text("Send Offer",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Future<void> _UsersInfo() async {
    try {
      // استعلام لجلب جميع العروض المطابقة للمنتج والمستخدمين
      final querySnapshot = await _firestore
          .collection("item")
          .doc("offers")
          .collection("offers")
          .where("productid", isEqualTo: widget.product.id)
          .where(
            Filter.or(
              Filter.and(
                Filter("senderId", isEqualTo: widget.otherUserId),
                Filter("receiverId", isEqualTo: MyID),
              ),
              Filter.and(
                Filter("senderId", isEqualTo: MyID),
                Filter("receiverId", isEqualTo: widget.otherUserId),
              ),
            ),
          )
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          offer = data['content'];

          // تعيين receiverId و senderId بناءً على كل مستند
          if (data['senderId'] == MyID) {
            setState(() {
              MyID = data['receiverId'];
              otherUserId = data['senderId'];
            });
          } else {
            setState(() {
              MyID = data['senderId'];
              otherUserId = data['receiverId'];
            });
          }

          // إذا كنت تريد فقط حفظ أول تطابق واستخدامه، يمكنك الخروج من الحلقة بعد أول تعيين:
          // break;
        }
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب معلومات المستخدمين: $e");
    }
  }

  // Function to send a message
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String message = _messageController.text.trim();
    _messageController.clear();

    try {
      _UsersInfo();
      await _firestore.collection("Messages").add({
        "senderId": otherUserId,
        "receiverId": MyID,
        "content": message,
        "timestamp": FieldValue.serverTimestamp(),
        "isSeen": false,
        "productid": widget.product.id,
      });
    } catch (e) {
      print("❌ Error sending message: $e");
    }
  }

  // Function to mark messages as seen

  Future<void> _markMessagesAsSeen(QuerySnapshot snapshot) async {
    for (var doc in snapshot.docs) {
      var msg = doc.data() as Map<String, dynamic>;
      _UsersInfo();
      if (msg["receiverId"] == _auth.currentUser!.uid &&
          msg["isSeen"] == false) {
        await doc.reference.update({"isSeen": true});
      }
    }
  }

  // Function to format timestamp
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    DateTime dateTime = timestamp.toDate();
    return DateFormat.Hm('en').format(dateTime); // Force English locale
  }

  // Function to fetch user name and photo URL
  Future<void> _fetchUserNameAndPhoto() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection("Users").doc(widget.otherUserId).get();

      if (userDoc.exists) {
        setState(() {
          otherUserName = userDoc["first_name"] ?? "Unknown";
          otherUserPhotoUrl = userDoc["photo"] ?? "";
        });
      }
    } catch (e) {
      print("❌ Error fetching user info: $e");
    }
  }

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
}
