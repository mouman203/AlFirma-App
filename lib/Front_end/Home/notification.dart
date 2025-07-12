import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPopup extends StatefulWidget {
  final VoidCallback onClose;
  const NotificationPopup({super.key, required this.onClose});

  @override
  State<NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<NotificationPopup> {
  List<Map<String, dynamic>> notifications = [];
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection("Notifications")
        .doc(userId)
        .collection("items")
        .orderBy("timestamp", descending: true)
        .get();
        if (!mounted) return;

    setState(() {
      notifications = snapshot.docs.map((doc) {
        final data = doc.data();
        data['docId'] = doc.id;
        return data;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF256C4C) : const Color(0xFF90D5AE);

    final filteredNotifications = selectedFilter == null
        ? notifications
        : notifications.where((n) => n['type'] == selectedFilter).toList();

    return Container(
      width: 560,
      height: 700,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onClose,
              )
            ],
          ),

          // Filter Icons
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFilterIcon(Icons.thumb_up, 'like', 'Likes'),
              _buildFilterIcon(Icons.chat_bubble, 'comment', 'Comments'),
              _buildFilterIcon(Icons.person_add, 'follow', 'Follows'),
              _buildFilterIcon(Icons.local_offer, 'offer', 'Offers'),
            ],
          ),
          const Divider(),

          // Notifications List
          Expanded(
            child: filteredNotifications.isEmpty
                ? const Center(child: Text("No notifications available"))
                : ListView.builder(
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notif = filteredNotifications[index];
                      final docId = notif['docId'];
                      final type = notif['type'] ?? '';
                      final name = notif['fromUserName'] ?? 'Someone';
                      final time = (notif['timestamp'] as Timestamp?)?.toDate();
                      final dateStr = time != null ? timeago.format(time) : '';

                      String message;
                      IconData iconData;
                      Color iconColor;

                      switch (type) {
                        case 'like':
                          message = '$name liked your post.';
                          iconData = Icons.thumb_up;
                          iconColor = Colors.grey;
                          break;
                        case 'comment':
                          message = '$name commented on your post.';
                          iconData = Icons.chat_bubble;
                          iconColor = Colors.grey;
                          break;
                        case 'follow':
                          message = '$name started following you.';
                          iconData = Icons.person_add;
                          iconColor = Colors.grey;
                          break;
                        default:
                          message = '$name sent you a notification.';
                          iconData = Icons.notifications;
                          iconColor = Colors.grey;
                      }

                      return Dismissible(
                        key: ValueKey(docId ?? index),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ),
                        onDismissed: (_) async {
                          setState(() {
                            notifications.removeAt(index);
                          });

                          try {
                            final userId =
                                FirebaseAuth.instance.currentUser?.uid;
                            if (userId != null && docId != null) {
                              await FirebaseFirestore.instance
                                  .collection("Notifications")
                                  .doc(userId)
                                  .collection("items")
                                  .doc(docId)
                                  .delete();
                            }
                          } catch (e) {
                            print('Error deleting notification: $e');
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(iconData, color: iconColor),
                            title: Text(message),
                            subtitle: dateStr.isNotEmpty
                                ? Text(dateStr,
                                    style: const TextStyle(fontSize: 12))
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterIcon(IconData icon, String type, String label) {
    final isSelected = selectedFilter == type;
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.black38,
          ),
          onPressed: () {
            setState(() {
              selectedFilter = selectedFilter == type ? null : type;
            });
          },
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ],
    );
  }
}
