import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Profile/userprofilepage.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:agriplant/widgets_UI/Item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isOfferAccepted = false;

  String otherUserName = "Loading...";
  String otherUserPhotoUrl = "";

  @override
  void initState() {
    super.initState();

    MyID = _auth.currentUser!.uid;
    otherUserId = widget.otherUserId;
    _UsersInfo();
    _fetchUserNameAndPhoto();
    _checkOfferStatus();
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
      resizeToAvoidBottomInset:
          false, // Prevent background zoom when keyboard appears
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
          widget.product.sell! || isOfferAccepted
              ? IconButton(
                  icon: Icon(
                    Icons.phone_enabled,
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
                              backgroundColor: Colors.red,
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
                            backgroundColor: Colors.red,
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
              : IconButton(
                  icon: Icon(
                    Icons.phone_disabled,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor:
                            const Color.fromARGB(255, 247, 234, 117),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        content: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.black),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                S.of(context).cantUsePhoneUntilOfferAccepted,
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
                  },
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
            // Product card - full width, same height
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 250,
                width: double.infinity, // Full width
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? scheme.onSecondary
                      : scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
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
                    ));
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
                      );
                    },
                  );
                },
              ),
            ),

            // Message input field or offer handling
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
                : StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection("offers")
                        .where("productid", isEqualTo: widget.product.id)
                        .where("senderId", isEqualTo: otherUserId)
                        .where("receiverId", isEqualTo: MyID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (widget.product.ownerId == _auth.currentUser!.uid) {
                        // Owner view - show accept/refuse buttons
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          var offerDoc = snapshot.data!.docs.first;
                          var offerData =
                              offerDoc.data() as Map<String, dynamic>;
                          bool isAccepted = offerData['accepted'] ?? false;

                          if (isAccepted) {
                            return _buildRegularMessageInput(
                                isDarkMode, scheme);
                          }

                          return Padding(
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
                                    "${otherUserName} ${S.of(context).proposed} ${offerData['content']} ${S.of(context).dinar}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
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
                                          await _acceptOffer(offerDoc.id);
                                        },
                                        icon: Icon(Icons.check,color: Colors.white,),
                                        label: Text(
                                          S.of(context).accept,
                                          style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDarkMode
                                              ? const Color(0xFF90D5AE)
                                              : const Color(0xFF256C4C),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          await _refuseOffer(offerDoc.id);
                                        },
                                        icon: const Icon(Icons.close,color: Colors.white,),
                                        label: Text(
                                          S.of(context).refuse,
                                          style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return _buildRegularMessageInput(isDarkMode, scheme);
                      } else {
                        // Buyer view - show offer input
                        return StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection("offers")
                              .where("productid", isEqualTo: widget.product.id)
                              .where("senderId", isEqualTo: MyID)
                              .where("receiverId", isEqualTo: otherUserId)
                              .snapshots(),
                          builder: (context, offerSnapshot) {
                            bool hasOffer = offerSnapshot.hasData &&
                                offerSnapshot.data!.docs.isNotEmpty;
                            bool isRefused = false;
                            bool isAccepted = false;

                            if (hasOffer) {
                              var offerData = offerSnapshot.data!.docs.first
                                  .data() as Map<String, dynamic>;
                              isRefused = offerData['refused'] ?? false;
                              isAccepted = offerData['accepted'] ?? false;
                            }

                            if (isAccepted) {
                              return _buildRegularMessageInput(
                                  isDarkMode, scheme);
                            }

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? scheme.onSecondary
                                    : scheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode
                                        ? Colors.black.withOpacity(0.2)
                                        : Colors.grey.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                    spreadRadius: 1,
                                  ),
                                ],
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.black.withOpacity(0.05),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Section
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isDarkMode
                                            ? [
                                                const Color(0xFF90D5AE)
                                                    .withOpacity(0.2),
                                                const Color(0xFF256C4C)
                                                    .withOpacity(0.1),
                                              ]
                                            : [
                                                const Color(0xFF256C4C)
                                                    .withOpacity(0.1),
                                                const Color(0xFF90D5AE)
                                                    .withOpacity(0.2),
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? const Color(0xFF90D5AE)
                                                : const Color(0xFF256C4C),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.monetization_on,
                                            color: isDarkMode
                                                ? Colors.black
                                                : Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                S.of(context).productPrice,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: isDarkMode
                                                      ? Colors.white70
                                                      : Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "${widget.product.price} ${S.of(context).dinar}",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Error Message with Animation
                                  if (isRefused)
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      margin: const EdgeInsets.only(top: 16),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.red.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            S.of(context).giveAnotherOffer,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  const SizedBox(height: 14),

                                  // Input Section
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.of(context).makeYourOffer,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isDarkMode
                                                  ? Colors.black
                                                      .withOpacity(0.2)
                                                  : Colors.grey
                                                      .withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: TextField(
                                          controller: _messageController,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*$')),
                                          ],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: InputDecoration(
                                            hintText:
                                                S.of(context).proposeYourOffer,
                                            hintStyle: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white54
                                                  : Colors.black54,
                                            ),
                                            prefixIcon: Container(
                                              margin: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: isDarkMode
                                                    ? const Color(0xFF90D5AE)
                                                        .withOpacity(0.2)
                                                    : const Color(0xFF256C4C)
                                                        .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Icon(
                                                Icons.attach_money,
                                                color: isDarkMode
                                                    ? const Color(0xFF90D5AE)
                                                    : const Color(0xFF256C4C),
                                              ),
                                            ),
                                            suffixText: S.of(context).dinar,
                                            suffixStyle: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white70
                                                  : Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            filled: true,
                                            fillColor: isDarkMode
                                                ? Colors.white.withOpacity(0.05)
                                                : Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              borderSide: BorderSide(
                                                color: isDarkMode
                                                    ? const Color(0xFF90D5AE)
                                                    : const Color(0xFF256C4C),
                                                width: 2,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? const Color(0xFF90D5AE)
                                                  .withOpacity(0.1)
                                              : const Color(0xFF256C4C)
                                                  .withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              size: 14,
                                              color: isDarkMode
                                                  ? const Color(0xFF90D5AE)
                                                  : const Color(0xFF256C4C),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "${S.of(context).minimumPrice} ${(widget.product.price! * 0.8).toStringAsFixed(0)} ${S.of(context).dinar}",
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white70
                                                    : Colors.black54,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Send Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        await _sendOffer();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDarkMode
                                            ? const Color(0xFF90D5AE)
                                            : const Color(0xFF256C4C),
                                        foregroundColor: isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                        elevation: 8,
                                        shadowColor: (isDarkMode
                                                ? const Color(0xFF90D5AE)
                                                : const Color(0xFF256C4C))
                                            .withOpacity(0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      icon: Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Icon(
                                          Icons.send_rounded,
                                          size: 20,
                                        ),
                                      ),
                                      label: Text(
                                        S.of(context).sendOffer,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularMessageInput(bool isDarkMode, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:
                    isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor:
                isDarkMode ? const Color(0xFF90D5AE) : const Color(0xFF256C4C),
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
    );
  }

  Future<void> _sendOffer() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  S.of(context).pleaseEnterOfferAmount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    double? offerAmount = double.tryParse(_messageController.text.trim());
    if (offerAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  S.of(context).pleaseEnterValidNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    double productPrice = widget.product.price?.toDouble() ?? 0;
    double minOffer = productPrice * 0.8; // 20% less than product price

    if (offerAmount < minOffer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              const Color.fromARGB(255, 247, 234, 117), // yellow warning
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.black), // Better warning icon
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Offer cannot be lower than 20% of product price (${minOffer.toStringAsFixed(0)} ${S.of(context).dinar})",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          duration: const Duration(seconds: 2),
        ),
      );

      return;
    }

    try {
      final offersCollectionRef = _firestore.collection("offers");

      // Check if offer already exists
      final existingOffersQuery = await offersCollectionRef
          .where("productid", isEqualTo: widget.product.id)
          .where("senderId", isEqualTo: MyID)
          .where("receiverId", isEqualTo: otherUserId)
          .get();

      if (existingOffersQuery.docs.isNotEmpty) {
        // Update existing offer
        final existingDocRef = existingOffersQuery.docs.first.reference;
        await existingDocRef.update({
          "accepted": false,
          "refused": false,
          "content": _messageController.text.trim(),
          "timestamp": Timestamp.now(),
        });
      } else {
        // Create new offer
        await offersCollectionRef.add({
          "productid": widget.product.id,
          "senderId": MyID,
          "receiverId": otherUserId,
          "content": _messageController.text.trim(),
          "accepted": false,
          "refused": false,
          "timestamp": Timestamp.now(),
        });
      }

      // Send message to chat
      await _firestore.collection("Messages").add({
        "senderId": MyID,
        "receiverId": otherUserId,
        "content": "I offer ${_messageController.text.trim()} DA",
        "timestamp": FieldValue.serverTimestamp(),
        "isSeen": false,
        "productid": widget.product.id,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  S.of(context).offerSent,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          // No `behavior: SnackBarBehavior.floating`
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white), // ⚠️ Icon
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${S.of(context).error} : $e",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red, // 🔴 Red background

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _acceptOffer(String offerId) async {
    try {
      // Update offer status
      await _firestore.collection("offers").doc(offerId).update({
        "accepted": true,
        "refused": false,
      });

      // Update product status
      await _firestore
          .collection("item")
          .doc("Products")
          .collection("Products")
          .where("id", isEqualTo: widget.product.id)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference.update({'sell': true});
        }
      });

      // Send message to chat
      await _firestore.collection("Messages").add({
        "senderId": MyID,
        "receiverId": otherUserId,
        "content": "Accepted",
        "timestamp": FieldValue.serverTimestamp(),
        "isSeen": false,
        "productid": widget.product.id,
      });

      setState(() {
        widget.product.sell = true;
        isOfferAccepted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.white), // ✅ Icon
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  S.of(context).offerAccepted,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green, // ✅ Green background

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white), // ⚠️ Icon
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${S.of(context).error} : $e",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red, // 🔴 Red background

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _refuseOffer(String offerId) async {
    try {
      // Update offer status
      await _firestore.collection("offers").doc(offerId).update({
        "accepted": false,
        "refused": true,
      });

      // Send message to chat
      await _firestore.collection("Messages").add({
        "senderId": MyID,
        "receiverId": otherUserId,
        "content": "Refused",
        "timestamp": FieldValue.serverTimestamp(),
        "isSeen": false,
        "productid": widget.product.id,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white), // ⚠️ Icon
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  S.of(context).offerRefused,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red, // 🔴 Red background

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white), // ⚠️ Icon
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${S.of(context).error} : $e",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red, // 🔴 Red background

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _checkOfferStatus() async {
    try {
      final querySnapshot = await _firestore
          .collection("offers")
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
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          if (data['accepted'] == true) {
            setState(() {
              isOfferAccepted = true;
            });
            break;
          }
        }
      }
    } catch (e) {
      print("❌ Error checking offer status: $e");
    }
  }

  Future<void> _UsersInfo() async {
    try {
      final querySnapshot = await _firestore
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
          break;
        }
      }
    } catch (e) {
      print("❌ Error fetching user info: $e");
    }
  }

  // Function to send a message
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String message = _messageController.text.trim();
    _messageController.clear();

    try {
      await _firestore.collection("Messages").add({
        "senderId": _auth.currentUser!.uid,
        "receiverId": widget.otherUserId,
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
