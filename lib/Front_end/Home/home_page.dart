import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Add_Product.dart';
import 'package:agriplant/Front_end/Home/Sidebar.dart';
import 'package:agriplant/Front_end/Home/explore_page.dart';
import 'package:agriplant/Front_end/Meseges/messeges.dart';
import 'package:agriplant/Front_end/Profile/profile_page.dart';
import 'package:agriplant/Front_end/ServicesF/services_page.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agriplant/Front_end/Home/user_type_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [
    const ExplorePage(),
    const ServicesPage(),
    const AddProducts(),
    const MessagesPage(),
    const ProfilePage(),
  ];
  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? userName;
  String? selectedType;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLastSelectedPage();
    _fetchUserName();
    _loadSelectedType();
  }

  Future<void> _loadSelectedType() async {
    final type = await getActiveTypeFromFirestore();

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        selectedType = type;
      });
    }
  }

  Future<void> _fetchUserName() async {
    String? name = await getUserNameFromFirestore();
    if (mounted) {
      setState(() {
        userName = name;
        isLoading = false;
        currentPageIndex = 0;
      });
    }
  }

  Future<String?> getUserNameFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("⚠️ No user is logged in!");
      return null;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    return userDoc.exists ? userDoc['first_name'] : null;
  }

  Future<List<String>> getUserTypesFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final docRef = FirebaseFirestore.instance.collection("Users").doc(user.uid);
    final doc = await docRef.get();

    List<String> types = [];

    if (doc.exists && doc.data()?['userType'] != null) {
      types = List<String>.from(doc['userType']);
    }

    // Default fallback to "Client"
    if (types.isEmpty) {
      types = ["Client"];
      await docRef.set({
        "userType": types,
        "activeType": "Client",
      }, SetOptions(merge: true));
    }

    return types;
  }

  Future<void> _loadLastSelectedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        currentPageIndex = prefs.getInt('lastPageIndex') ?? 0;
      });
    }
  }

  Future<void> _saveLastSelectedPage(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastPageIndex', index);
  }

  Future<void> _refreshPage() async {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomePage(),
        transitionDuration: Duration.zero, // بدون تأثيرات انتقال
      ),
    );
  }

  Future<String?> getActiveTypeFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      return data?['activeType'] ?? "Client";
    }

    return "Client"; // Default fallback
  }

  void navigateToUserPage(BuildContext context) async {
    String? selectedType = await getActiveTypeFromFirestore();

    if (selectedType == null) {
      print("🚨 User type not found!");
      return;
    }
  }

  void showMessagePopup(String? value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).accessRestricted),
          content: Text(
            "${value ?? ''} ${S.of(context).cannotAddProducts}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).ok),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const Sidebar(),
      appBar: AppBar(
          backgroundColor: theme.brightness == Brightness.dark
              ? colorScheme.surface
              : colorScheme.surface,
          centerTitle: false,
          elevation: 3,
          leading: IconButton.filledTonal(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Users.isGuestUser()) ...[
                Text(
                  S.of(context).welcomeMessage,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  S.of(context).guestSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ] else ...[
                isLoading
                    ? Text(
                        S.of(context).loading,
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    : Text(
                        userName != null
                            ? "${S.of(context).hi} ${userName![0].toUpperCase()}${userName!.substring(1)} 👋🏼"
                            : S.of(context).welcomeMessage,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                Text(
                  selectedType != null
                      ? "${S.of(context).the}$selectedType"
                      : S.of(context).guestSubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Users.isGuestUser()
                  ? FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        fixedSize: const Size.fromHeight(40),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    S.of(context).guestAccessLimited,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 247, 234, 117),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          S.of(context).become,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : BecomeTypeAction(onTypeChanged: _loadSelectedType),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton.filledTonal(
                onPressed: () {
                  if (Users.isGuestUser()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                S.of(context).guestAccessLimited,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 247, 234, 117),
                      ),
                    );
                  } else {
                    // navigate to notifications page or whatever you want
                  }
                },
                icon: const Icon(
                  IconlyBroken.notification,
                ),
              ),
            ),
          ]),
      body: RefreshIndicator(
          onRefresh: _refreshPage, child: pages[currentPageIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        elevation: 20,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        currentIndex: currentPageIndex,
        onTap: (index) async {
          // Block guest users from accessing "Add"  and "messages" and  "Profile"
          if (Users.isGuestUser() && (index == 2 || index == 3 || index == 4)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: Text(
                        S.of(context).guestAccessLimited,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color.fromARGB(255, 247, 234, 117),
              ),
            );
            return;
          }

          
            setState(() {
              currentPageIndex = index;
            });
          
          _saveLastSelectedPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.home),
            label: "Home",
            activeIcon: Icon(IconlyBold.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.work),
            label: "Services",
            activeIcon: Icon(IconlyBold.work),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.plus),
            label: "Add",
            activeIcon: Icon(IconlyBold.plus),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.message),
            label: "Messeges",
            activeIcon: Icon(IconlyBold.message),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.profile),
            label: "Profile",
            activeIcon: Icon(IconlyBold.profile),
          ),
        ],
      ),
    );
  }
}
