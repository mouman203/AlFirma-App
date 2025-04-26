import 'package:agriplant/Front_end/Profile/userprofilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;

  const ChatPage({super.key, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  late String currentUserId;
  String receiverName = "Loading...";
  String receiverPhotoUrl = "";

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser!.uid;
    _getReceiverData();
  }

  /// 🟢 **جلب بيانات المستخدم الآخر**
  Future<void> _getReceiverData() async {
    DocumentSnapshot userDoc =
        await _firestore.collection("Users").doc(widget.receiverId).get();

    if (userDoc.exists) {
      setState(() {
        receiverName = userDoc["first_name"];
        receiverPhotoUrl = userDoc["photo"];
      });
    }
  }

  /// 🟢 **إرسال الرسالة إلى Firestore**
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String message = _messageController.text.trim();
    _messageController.clear();

    try {
      await _firestore.collection("Messages").add({
        "senderId": currentUserId,
        "receiverId": widget.receiverId,
        "message": message,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("❌ Error sending message: $e");
    }
  }

  /// 🟢 **الانتقال إلى صفحة الملف الشخصي**
  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(userId: widget.receiverId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.brightness == Brightness.dark
              ? colorScheme.surface
              : colorScheme.surface,
          elevation: 5,
          title: GestureDetector(
            onTap: _goToProfile,
            child: Row(
              children: [
                /// 🟠 **دائرة صورة المستخدم**
                CircleAvatar(
                  backgroundImage: receiverPhotoUrl.isNotEmpty
                      ? NetworkImage(receiverPhotoUrl)
                      : null, // صورة المستخدم
                  backgroundColor:
                      Colors.grey[300], // لون افتراضي إذا لم تكن هناك صورة
                  radius: 18,
                  child: receiverPhotoUrl.isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null, // أيقونة بديلة عند عدم وجود صورة
                ),
                const SizedBox(width: 10),

                /// 🟠 **اسم المستخدم**
                Text(
                  receiverName,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage("assets/background_chats.png"), // your image path
              repeat: ImageRepeat.repeat,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              /// 🔵 **عرض الرسائل باستخدام StreamBuilder**
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection("Messages")
                      .where(
                        Filter.or(
                          Filter.and(
                              Filter("senderId", isEqualTo: currentUserId),
                              Filter("receiverId",
                                  isEqualTo: widget.receiverId)),
                          Filter.and(
                              Filter("senderId", isEqualTo: widget.receiverId),
                              Filter("receiverId", isEqualTo: currentUserId)),
                        ),
                      )
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No messages yet"));
                    }

                    var messages = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: messages.length,
                      reverse: true,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        var msg =
                            messages[index].data() as Map<String, dynamic>;
                        bool isMe = msg["senderId"] == currentUserId;

                        return Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            /// 🟠 **عرض صورة المستخدم بجانب رسائله**
                            if (!isMe)
                              GestureDetector(
                                onTap: _goToProfile,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    backgroundImage: receiverPhotoUrl.isNotEmpty
                                        ? NetworkImage(receiverPhotoUrl)
                                        : null,
                                    backgroundColor: Colors.grey[300],
                                    radius: 16,
                                    child: receiverPhotoUrl.isEmpty
                                        ? const Icon(Icons.person,
                                            color: Colors.white)
                                        : null,
                                  ),
                                ),
                              ),

                            /// 🟢 **رسالة الدردشة**
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.green : Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Text(
                                msg["message"],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isMe ? Colors.white : Colors.black87,
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

              /// 🟠 **حقل إدخال الرسالة وزر الإرسال**
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? colorScheme.secondaryContainer
                              : colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: "Type a message...",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
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
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
