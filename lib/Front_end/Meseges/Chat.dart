import 'package:agriplant/Front_end/Profile/userprofilepage.dart';
import 'package:agriplant/generated/l10n.dart';
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
        "isSeen": false,
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
    return DateFormat.Hm().format(dateTime);
  }

  Future<void> _markMessagesAsSeen(QuerySnapshot snapshot) async {
    for (var doc in snapshot.docs) {
      var msg = doc.data() as Map<String, dynamic>;
      if (msg["receiverId"] == currentUserId &&
          msg["senderId"] == widget.receiverId &&
          msg["isSeen"] == false) {
        await doc.reference.update({"isSeen": true});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
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
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("Messages")
                    .where(
                      Filter.or(
                        Filter.and(
                          Filter("senderId", isEqualTo: currentUserId),
                          Filter("receiverId", isEqualTo: widget.receiverId),
                        ),
                        Filter.and(
                          Filter("senderId", isEqualTo: widget.receiverId),
                          Filter("receiverId", isEqualTo: currentUserId),
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

                  _markMessagesAsSeen(snapshot.data!);

                  var messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      var msg = messages[index].data() as Map<String, dynamic>;
                      bool isMe = msg["senderId"] == currentUserId;

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
                                backgroundImage: receiverPhotoUrl.isNotEmpty
                                    ? NetworkImage(receiverPhotoUrl)
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
                                        : const Color(0xFF3A3A3A)),
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
                                    msg["message"],
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
                          hintText: S.of(context).messageHint, // localized hint
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
