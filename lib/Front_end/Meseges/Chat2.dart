import 'package:agriplant/Front_end/Profile/userprofilepage.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class ChatPage2 extends StatefulWidget {
  final String otherUserId;

  const ChatPage2({super.key, required this.otherUserId});

  @override
  State<ChatPage2> createState() => _ChatPage2State();
}

class _ChatPage2State extends State<ChatPage2> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  late String myId;
  late String otherUserId;

  String otherUserName = "Loading...";
  String otherUserPhotoUrl = "";

  // Timer to debounce the mark as seen operations
  Timer? _markAsSeenTimer;
  final Set<String> _processedMessages = <String>{};

  // Stream subscription to better control the stream
  StreamSubscription<QuerySnapshot>? _messagesSubscription;

  @override
  void initState() {
    super.initState();
    myId = _auth.currentUser!.uid;
    otherUserId = widget.otherUserId;
    _fetchUserNameAndPhoto();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _markAsSeenTimer?.cancel();
    _messagesSubscription?.cancel();
    super.dispose();
  }

  // Create a separate method for the chat ID to ensure consistency
  String get chatId {
    List<String> ids = [myId, otherUserId];
    ids.sort(); // This ensures the same chat ID regardless of who initiated
    return ids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Receiver information
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
      ),

      // The chat box
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
            // Chat messages
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getMessagesStream(),
                builder: (context, snapshot) {
                  // Handle different connection states
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print("❌ Stream error: ${snapshot.error}");
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48),
                          const SizedBox(height: 16),
                          Text(S.of(context).errorLoadingMessages),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => setState(() {}),
                            child: Text(S.of(context).retry),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Center(
                            child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.8)
                            : Colors.white
                                .withOpacity(0.8), // White with transparency
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                      child: Text(
                        S.of(context).noMessages,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDarkMode
                              ? Colors.white
                              : Colors.black, // Keep readable contrast
                        ),
                      ),
                    )));
                  }

                  var messages = snapshot.data!.docs;

                  // Schedule mark as seen with a delay to avoid conflicts
                  _scheduleMarkAsSeen(snapshot.data!);

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    padding: const EdgeInsets.all(10),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var doc = messages[index];
                      var msg = doc.data() as Map<String, dynamic>;
                      bool isMe = msg["senderId"] == _auth.currentUser!.uid;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isMe)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 4.0, bottom: 4),
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
                                      msg["content"] ?? "",
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
                                            color: (msg["isSeen"] == true)
                                                ? (isDarkMode
                                                    ? Colors.lightGreen.shade700
                                                    : Colors.lightGreen)
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Message input field
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
                          hintText: S.of(context).messageHint,
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

  // Separate method to get the messages stream with better error handling
  Stream<QuerySnapshot> _getMessagesStream() {
    try {
      return _firestore
          .collection("Vet Messages")
          .where(
            Filter.or(
              Filter.and(
                Filter("senderId", isEqualTo: myId),
                Filter("receiverId", isEqualTo: otherUserId),
              ),
              Filter.and(
                Filter("senderId", isEqualTo: otherUserId),
                Filter("receiverId", isEqualTo: myId),
              ),
            ),
          )
          .orderBy("timestamp", descending: true)
          .snapshots();
    } catch (e) {
      print("❌ Error creating stream: $e");
      // Return empty stream in case of error
      return const Stream.empty();
    }
  }

  // Schedule the mark as seen operation with debouncing
  void _scheduleMarkAsSeen(QuerySnapshot snapshot) {
    _markAsSeenTimer?.cancel();
    _markAsSeenTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _markMessagesAsSeenSafely(snapshot);
      }
    });
  }

  // Function to send a message
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String message = _messageController.text.trim();
    _messageController.clear();

    try {
      await _firestore.collection("Vet Messages").add({
        "senderId": _auth.currentUser!.uid,
        "receiverId": otherUserId,
        "content": message,
        "timestamp": FieldValue.serverTimestamp(),
        "isSeen": false,
        "chatId": chatId, // Add chatId for better querying if needed
      });
    } catch (e) {
      print("❌ Error sending message: $e");
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).failedToSendMessage),
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  // Safer function to mark messages as seen
  Future<void> _markMessagesAsSeenSafely(QuerySnapshot snapshot) async {
    if (!mounted) return;

    try {
      List<Future<void>> updateFutures = [];

      for (var doc in snapshot.docs) {
        var msg = doc.data() as Map<String, dynamic>;

        // Only update if message is for current user, not already seen, and not already processed
        if (msg["receiverId"] == _auth.currentUser!.uid &&
            msg["isSeen"] != true &&
            !_processedMessages.contains(doc.id)) {
          _processedMessages.add(doc.id);

          // Add to futures list instead of awaiting immediately
          updateFutures
              .add(doc.reference.update({"isSeen": true}).catchError((error) {
            print("❌ Error updating message ${doc.id}: $error");
            // Remove from processed list if update failed
            _processedMessages.remove(doc.id);
          }));
        }
      }

      // Execute all updates in parallel
      if (updateFutures.isNotEmpty) {
        await Future.wait(updateFutures);
      }
    } catch (e) {
      print("❌ Error marking messages as seen: $e");
    }
  }

  // Function to format timestamp
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      DateTime dateTime = timestamp.toDate();
      return DateFormat.Hm('en').format(dateTime);
    } catch (e) {
      print("❌ Error formatting timestamp: $e");
      return '';
    }
  }

  // Function to fetch user name and photo URL
  Future<void> _fetchUserNameAndPhoto() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection("Users").doc(otherUserId).get();

      if (userDoc.exists && mounted) {
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
