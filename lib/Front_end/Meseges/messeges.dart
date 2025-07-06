import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:agriplant/Front_end/Meseges/Chat2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:agriplant/generated/l10n.dart';

class MessagesPage extends StatefulWidget {
  final Products? product;
  const MessagesPage({super.key, this.product});
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 4),
              child: Row(
                children: [
                  Text(
                    S.of(context).messages, // Localized string
                    style: const TextStyle(
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

    // Stream for sender offers
    Stream<List<QueryDocumentSnapshot>> sentOffers = _firestore
        .collection('item')
        .doc("offers")
        .collection("offers")
        .where("senderId", isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      print("✅ Sent offers count: ${snapshot.docs.length}");
      return snapshot.docs;
    });

    // Stream for received offers
    Stream<List<QueryDocumentSnapshot>> receivedOffers = _firestore
        .collection('item')
        .doc("offers")
        .collection("offers")
        .where("receiverId", isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      print("📥 Received offers count: ${snapshot.docs.length}");
      return snapshot.docs;
    });

    // Stream for sent messages
    Stream<List<QueryDocumentSnapshot>> sentMessages = _firestore
        .collection('Messages')
        .where("senderId", isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      print("✅ Sent messages count: ${snapshot.docs.length}");
      return snapshot.docs;
    });

    // Stream for received messages
    Stream<List<QueryDocumentSnapshot>> receivedMessages = _firestore
        .collection('Messages')
        .where("receiverId", isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      print("📥 Received messages count: ${snapshot.docs.length}");
      return snapshot.docs;
    });

    // Combine all streams
    return Rx.combineLatest4(
      sentOffers,
      receivedOffers,
      sentMessages,
      receivedMessages,
      (
        List<QueryDocumentSnapshot> sentOffers,
        List<QueryDocumentSnapshot> receivedOffers,
        List<QueryDocumentSnapshot> sentMessages,
        List<QueryDocumentSnapshot> receivedMessages,
      ) {
        print("✅ Sent offers count: ${sentOffers.length}");
        print("📥 Received offers count: ${receivedOffers.length}");
        print("✅ Sent messages count: ${sentMessages.length}");
        print("📥 Received messages count: ${receivedMessages.length}");
        print(
            "🔄 Total combined messages: ${sentOffers.length + receivedOffers.length + sentMessages.length + receivedMessages.length}");

        return [
          ...sentOffers,
          ...receivedOffers,
          ...sentMessages,
          ...receivedMessages
        ];
      },
    );
  }

  Map<String, List<Map<String, dynamic>>> _processMessages(
      List<QueryDocumentSnapshot> messages, String currentUserId) {
    messages.sort((a, b) {
      Timestamp timeA = a['timestamp'] ?? Timestamp(0, 0);
      Timestamp timeB = b['timestamp'] ?? Timestamp(0, 0);
      return timeB.compareTo(timeA);
    });

    Map<String, List<Map<String, dynamic>>> groupedMessages = {};

    for (var doc in messages) {
      var messageData = doc.data() as Map<String, dynamic>;
      String sender = messageData['senderId'];
      String receiver = messageData['receiverId'];
      String? productId =
          messageData['productid']; // Can be null for ChatPage2 messages
      String? content = messageData['content'];

      if (content == null || content.isEmpty) {
        continue; // Skip empty messages
      }

      String otherUserId = sender == currentUserId ? receiver : sender;

      // Create key based on whether productId exists
      String key = productId != null
          ? "${otherUserId}_$productId"
          : "${otherUserId}_direct";

      if (!groupedMessages.containsKey(key)) {
        groupedMessages[key] = [];
      }

      groupedMessages[key]!.add(messageData);
    }

    return groupedMessages;
  }

  Widget _buildUserListTile(String userId, Map<String, dynamic> messageData) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<DocumentSnapshot>(
      // Fetch user data from Firestore
      future: _firestore.collection('Users').doc(userId).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
              title:
                  Text(S.of(context).loading)); // Localized string for loading
        }

        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const SizedBox();
        }

        var userData = userSnapshot.data!;
        String username = userData['first_name'] ?? 'Unknown';
        String lastMessage = messageData['content'] ?? '';

        bool isSeen = messageData['isSeen'] ?? false; // Fetch isSeen status
        Timestamp timestamp = messageData['timestamp'] ?? Timestamp(0, 0);
        DateTime time = timestamp.toDate();
        String formattedTime =
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

        // Check if this is a direct message from ChatPage2 (no productId)
        bool isDirectMessage = messageData['productid'] == null;

        return Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
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
              title: Row(
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: isDarkMode
                          ? const Color(0xFF90D5AE)
                          : const Color(0xFF256C4C),
                    ),
                  ),
                  // Add syringe emoji 💉 only for direct messages from ChatPage2
                  if (isDirectMessage) ...[
                    const SizedBox(width: 6),
                    const Text(
                      '💉',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ],
              ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  // Show the seen indicator icon
                  Icon(
                    Icons.done_all,
                    size: 18,
                    color:
                        isSeen ? const Color(0xFF64B58B) : Colors.transparent,
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () async {
                      bool confirm = await showDialog<bool>(
                            context: context,
                            barrierDismissible: true,
                            builder: (dialogContext) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: Text(
                                  S.of(dialogContext).confirm_delete_title),
                              content: Text(
                                  S.of(dialogContext).confirm_delete_message),
                              actionsPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(dialogContext)
                                                    .brightness ==
                                                Brightness.dark
                                            ? const Color(0xFF90D5AE)
                                            : const Color(0xFF256C4C),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(dialogContext)
                                            .pop(false); // Dialog returns false
                                      },
                                      child: Text(
                                        S.of(dialogContext).cancel,
                                        style: TextStyle(
                                          color: Theme.of(dialogContext)
                                                      .brightness ==
                                                  Brightness.dark
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(dialogContext)
                                            .pop(true); // Dialog returns true
                                      },
                                      child: Text(
                                        S.of(dialogContext).delete,
                                        style: TextStyle(
                                          color: Theme.of(dialogContext)
                                                      .brightness ==
                                                  Brightness.dark
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ) ??
                          false; // If tapped outside dialog

                      if (!context.mounted) return;

                      if (confirm) {
                        await _deleteConversation(userId, messageData);
                      }
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  )
                ],
              ),
              onTap: () => _navigateToChat(userId, messageData),
            ));
      },
    );
  }

  Future<void> _deleteConversation(
      String userId, Map<String, dynamic> messageData) async {
    try {
      String? productId = messageData['productid'];

      if (productId != null) {
        // Delete messages with productid (ChatPage messages)
        final messagesQuery = await _firestore
            .collection("Messages")
            .where("productid", isEqualTo: productId)
            .where(Filter.or(
              Filter.and(
                Filter("senderId", isEqualTo: _auth.currentUser!.uid),
                Filter("receiverId", isEqualTo: userId),
              ),
              Filter.and(
                Filter("senderId", isEqualTo: userId),
                Filter("receiverId", isEqualTo: _auth.currentUser!.uid),
              ),
            ))
            .get();

        for (var doc in messagesQuery.docs) {
          await doc.reference.delete();
        }

        // Delete related offers
        final offersQuery = await _firestore
            .collection('item')
            .doc("offers")
            .collection("offers")
            .where('productid', isEqualTo: productId)
            .where(Filter.or(
              Filter("senderId", isEqualTo: _auth.currentUser!.uid),
              Filter("receiverId", isEqualTo: _auth.currentUser!.uid),
            ))
            .get();

        for (var doc in offersQuery.docs) {
          await doc.reference.delete();
        }
      } else {
        // Delete direct messages without productid (ChatPage2 messages)
        final messagesQuery = await _firestore
            .collection("Messages")
            .where(Filter.or(
              Filter.and(
                Filter("senderId", isEqualTo: _auth.currentUser!.uid),
                Filter("receiverId", isEqualTo: userId),
              ),
              Filter.and(
                Filter("senderId", isEqualTo: userId),
                Filter("receiverId", isEqualTo: _auth.currentUser!.uid),
              ),
            ))
            .get();

        // Filter messages that don't have productid
        for (var doc in messagesQuery.docs) {
          var data = doc.data();
          if (data['productid'] == null) {
            await doc.reference.delete();
          }
        }
      }

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Conversation deleted successfully")),
      );
    } catch (e) {
      print("Error deleting conversation: $e");
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting conversation: $e")),
      );
    }
  }

  void _navigateToChat(String userId, Map<String, dynamic> messageData) async {
    String? productId = messageData['productid'];

    if (productId != null) {
      // This is a product-related chat (ChatPage)
      final firestore = FirebaseFirestore.instance;
      Products? product;

      // Try to get from Products collection
      final productDoc = await firestore
          .collection('item')
          .doc('Products')
          .collection('Products')
          .doc(productId)
          .get();

      if (productDoc.exists) {
        product = Products.fromFirestore(productDoc);
        print("✅ Found in Products: $productId");
      } else {
        // Try Services collection
        final serviceDoc = await firestore
            .collection('item')
            .doc('Services')
            .collection('Services')
            .doc(productId)
            .get();

        if (serviceDoc.exists) {
          product = Products.fromFirestore(serviceDoc);
          print("✅ Found in Services: $productId");
        } else {
          print("❌ Item not found in Products or Services.");
        }
      }

      if (product != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              otherUserId: userId,
              product: product!,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Item not found."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // This is a direct chat (ChatPage2)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage2(
            otherUserId: userId,
          ),
        ),
      );
    }
  }

  Widget _buildMessagesList() {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: _getMessagesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(S
                  .of(context)
                  .noMessages)); // Localized string for no messages
        }

        String currentUserId = _auth.currentUser!.uid;
        Map<String, List<Map<String, dynamic>>> lastMessages =
            _processMessages(snapshot.data!, currentUserId);

        return ListView(
          padding: const EdgeInsets.only(top: 0),
          children: lastMessages.entries.map((entry) {
            Map<String, dynamic> lastMessage = entry.value.first;
            String fullKey =
                entry.key; // example: userId_productId or userId_direct
            String userId = fullKey.split('_').first; // example: userId

            return _buildUserListTile(userId, lastMessage);
          }).toList(),
        );
      },
    );
  }
}
