import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
              child: Row(
                children: [
                  Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildMessagesList()),
          ],
        ),
      ),
    );
  }

  Stream<List<QueryDocumentSnapshot>> _getMessagesStream() {
    String currentUserId = _auth.currentUser!.uid;

    Stream<List<QueryDocumentSnapshot>> sentMessages = _firestore
        .collection('Messages')
        .where("senderId", isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docs);

    Stream<List<QueryDocumentSnapshot>> receivedMessages = _firestore
        .collection('Messages')
        .where("receiverId", isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docs);

    return Rx.combineLatest2(
      sentMessages,
      receivedMessages,
      (List<QueryDocumentSnapshot> sent, List<QueryDocumentSnapshot> received) {
        return [...sent, ...received];
      },
    );
  }

  Map<String, Map<String, dynamic>> _processMessages(
      List<QueryDocumentSnapshot> messages, String currentUserId) {
    messages.sort((a, b) {
      Timestamp timeA = a['timestamp'] ?? Timestamp(0, 0);
      Timestamp timeB = b['timestamp'] ?? Timestamp(0, 0);
      return timeB.compareTo(timeA);
    });

    Map<String, Map<String, dynamic>> lastMessages = {};
    for (var doc in messages) {
      var messageData = doc.data() as Map<String, dynamic>;
      String sender = messageData['senderId'] ?? "";
      String receiver = messageData['receiverId'] ?? "";
      String otherUserId = sender == currentUserId ? receiver : sender;

      if (!lastMessages.containsKey(otherUserId)) {
        lastMessages[otherUserId] = messageData;
      }
    }
    return lastMessages;
  }

  Widget _buildUserListTile(String userId, Map<String, dynamic> messageData) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('Users').doc(userId).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(title: Text("Loading..."));
        }

        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const SizedBox();
        }

        var userData = userSnapshot.data!;
        String username = userData['first_name'] ?? 'Unknown';
        String lastMessage = messageData['message'] ?? '';
        Timestamp timestamp = messageData['timestamp'] ?? Timestamp(0, 0);
        DateTime time = timestamp.toDate();
        String formattedTime =
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          decoration: BoxDecoration(
            color: isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: userData['photo'] != null
                  ? NetworkImage(userData['photo'])
                  : (isDarkMode
                          ? const AssetImage("assets/anonymeD.png")
                          : const AssetImage("assets/anonyme.png"))
                      as ImageProvider,
            ),
            title: Text(
              username,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
              ),
            ),
            subtitle: Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 15,
              ),
            ),
            trailing: Text(
              formattedTime,
              style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black54),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(receiverId: userId),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: _getMessagesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No messages yet."));
        }

        String currentUserId = _auth.currentUser!.uid;
        Map<String, Map<String, dynamic>> lastMessages =
            _processMessages(snapshot.data!, currentUserId);

        return ListView(
          padding: const EdgeInsets.only(top: 0),
          children: lastMessages.entries.map((entry) {
            return _buildUserListTile(entry.key, entry.value);
          }).toList(),
        );
      },
    );
  }
}
