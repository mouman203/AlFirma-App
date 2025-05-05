import 'package:agriplant/Front_end/Profile/userprofilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(userId: widget.receiverId),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    DateTime dateTime = timestamp.toDate();
    return DateFormat.jm().format(dateTime); // Example: 2:43 AM
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.brightness == Brightness.dark
            ? scheme.surface
            : scheme.surface,
        elevation: 5,
        title: GestureDetector(
          onTap: _goToProfile,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: receiverPhotoUrl.isNotEmpty
                    ? NetworkImage(receiverPhotoUrl)
                    : (isDarkMode
                            ? const AssetImage("assets/anonymeD.png")
                            : const AssetImage("assets/anonyme.png"))
                        as ImageProvider,
                radius: 20,
              ),
              const SizedBox(width: 14),
              Text(
                receiverName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_chats.png"),
            repeat: ImageRepeat.repeat,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("Messages")
                    .where(
                      Filter.or(
                        Filter.and(Filter("senderId", isEqualTo: currentUserId),
                            Filter("receiverId", isEqualTo: widget.receiverId)),
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
                      var msg = messages[index].data() as Map<String, dynamic>;
                      bool isMe = msg["senderId"] == currentUserId;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isMe)
                            GestureDetector(
                              onTap: _goToProfile,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 6.0, bottom: 6),
                                child: CircleAvatar(
                                  backgroundImage: receiverPhotoUrl.isNotEmpty
                                      ? NetworkImage(receiverPhotoUrl)
                                      : (isDarkMode
                                              ? const AssetImage(
                                                  "assets/anonymeD.png")
                                              : const AssetImage(
                                                  "assets/anonyme.png"))
                                          as ImageProvider,
                                  radius: 18,
                                ),
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 14),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? (isDarkMode
                                      ? const Color(0xFF90D5AE)
                                      : const Color(0xFF256C4C))
                                  : (isDarkMode
                                      ? const Color.fromARGB(255, 178, 178, 178)
                                      : const Color.fromARGB(255, 95, 94, 94)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  msg["message"],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTimestamp(msg["timestamp"]),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: isDarkMode
                                          ? Colors.black54
                                          : Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
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
                          hintText: "Message...",
                          hintStyle: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
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
            ),
          ],
        ),
      ),
    );
  }
}
