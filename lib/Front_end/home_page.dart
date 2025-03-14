import 'package:agriplant/Front_end/Sidebar.dart';
import 'package:agriplant/Front_end/cart_page.dart';
import 'package:agriplant/Front_end/explore_page.dart';
import 'package:agriplant/Front_end/profile_page.dart';
import 'package:agriplant/Front_end/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [
    const ExplorePage(),
    const ServicesPage(),
    const CartPage(),
    const ProfilePage()
  ];
  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLastSelectedPage();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    String? name = await getUserNameFromFirestore();
    if (mounted) {
      setState(() {
        userName = name;
        isLoading = false;
      });
    }
  }

  Future<String?> getUserNameFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("⚠️ No user is logged in!");
      return null;
    }

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

    return userDoc.exists ? userDoc['first_name'] : null;
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
        leading: IconButton.filledTonal(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? Text(
                    "⏳ Loading...",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                : Text(
                    userName != null ? "Hi $userName 👋🏼" : "⚠️ No name available",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
            Text("Enjoy our services",
                style: Theme.of(context).textTheme.bodyMedium)
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(IconlyBroken.message),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: _refreshPage, child: pages[currentPageIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        currentIndex: currentPageIndex,
        onTap: (index) {
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
            icon: Icon(IconlyLight.buy),
            label: "Cart",
            activeIcon: Icon(IconlyBold.buy),
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
