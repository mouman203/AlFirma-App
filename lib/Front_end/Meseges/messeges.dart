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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("Messages"),
      backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 39, 57, 48) // Dark green in dark mode
            : Theme.of(context).colorScheme.secondaryContainer),// Light 
      body: _buildMessagesList(),
    );
  }

 /// 🟢 **وظيفة 1: جلب بيانات الرسائل المرسلة والمستلمة**
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
      print("Total Messages Combined: ${sent.length + received.length}");
      return [...sent, ...received];
    },
  );
}




  /// 🔵 **وظيفة 2: فرز وتجميع الرسائل**
  Map<String, Map<String, dynamic>> _processMessages(List<QueryDocumentSnapshot> messages, String currentUserId) {
    messages.sort((a, b) {
      Timestamp timeA = a['timestamp'] ?? Timestamp(0, 0);
      Timestamp timeB = b['timestamp'] ?? Timestamp(0, 0);
      return timeB.compareTo(timeA); // ترتيب تنازلي (الأحدث أولًا)
    });

    Map<String, Map<String, dynamic>> lastMessages = {};
    for (var doc in messages) {
      var messageData = doc.data() as Map<String, dynamic>;
      String sender = messageData['senderId'] ?? "Unknown Sender";
String receiver = messageData['receiverId'] ?? "Unknown Receiver";
      String otherUserId = sender == currentUserId ? receiver : sender;

      if (!lastMessages.containsKey(otherUserId)) {
        lastMessages[otherUserId] = messageData;
      }
    }
    return lastMessages;
  }

  /// 🟠 **وظيفة 3: جلب معلومات المستخدم وعرضها**
  Widget _buildUserListTile(String userId, Map<String, dynamic> messageData) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('Users').doc(userId).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(title: Text("Loading..."));
        }
        print("userid$userId");
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const Text("moumane makach");
        }

        var userData = userSnapshot.data!;
        String username = userData['first_name'] ?? 'Unknown';
        String lastMessage = messageData['message'] ?? '';

        return ListTile(
          leading: CircleAvatar(
  backgroundImage: userData['photo'] != null
      ? NetworkImage(userData['photo'])
      : null,
  child: userData['photo'] == null 
      ? Text(username[0].toUpperCase(), style: const TextStyle(fontSize: 20))
      : null,
),

          title: Text(username),
          subtitle: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(receiverId: userId),
              ),
            );
          },
        );
      },
    );
  }

  /// 🔴 **وظيفة 4: بناء واجهة عرض الرسائل**
  Widget _buildMessagesList() {
  return StreamBuilder<List<QueryDocumentSnapshot>>(
    stream: _getMessagesStream(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        print("No messages found!");
        return const Center(child: Text("No messages yet"));
      }

      String currentUserId = _auth.currentUser!.uid;
      Map<String, Map<String, dynamic>> lastMessages = _processMessages(snapshot.data!, currentUserId);

      return ListView(
        children: lastMessages.entries.map((entry) {
          return _buildUserListTile(entry.key, entry.value);
        }).toList(),
      );
    },
  );
}


}
