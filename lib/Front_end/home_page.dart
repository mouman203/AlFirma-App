import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Client.dart';
import 'package:agriplant/Front_end/Sidebar.dart';
import 'package:agriplant/Front_end/explore_page.dart';
import 'package:agriplant/Front_end/Meseges/messeges.dart';
import 'package:agriplant/Front_end/profile_page.dart';
import 'package:agriplant/Front_end/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Agriculteur.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Commercant.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Eleveur.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Entreprise.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Reparateur.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Transporteur.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Veterinaire.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [
    const ExplorePage(),
    const ServicesPage(),
    const AddProductClient(),
    const MessagesPage(),
    const ProfilePage(),
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

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

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

  Future<String?> getUserTypeFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("⚠️ No user is logged in!");
      return null;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    return userDoc.exists ? userDoc['userType'] : null; // Fetch 'userType'
  }

  void navigateToUserPage(BuildContext context) async {
    String? selectedType = await getUserTypeFromFirestore();

    if (selectedType == null) {
      print("🚨 User type not found!");
      return;
    }

    Widget page;
    switch (selectedType) {
      case 'Agriculteur':
        page = const AddProductAgriculteur();
        print("im $selectedType");
        break;
      case 'Éleveur':
        page = const AddProductEleveur();
        print("im $selectedType");
        break;
      case 'Expert Agri':
        page = const AddProductClient();
        print("im $selectedType");
        break;
      case 'Vétérinaire':
        page = const AddProductVeterinaire();
        print("im $selectedType");
        break;
      case 'Entreprise':
        page = const AddProductEntreprise();
        print("im $selectedType");
        break;
      case 'Commerçant':
        page = const AddProductCommercant();
        print("im $selectedType");
        break;
      case 'Transporteur':
        page = const AddProductTransporteur();
        print("im $selectedType");
        break;
      case 'Reparateur':
        page = const AddProductReparateur();
        print("im $selectedType");
        break;
      default:
        print("🚨 Unknown userType: $selectedType");
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void showMessagePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("⚠️ Access Restricted"),
          content: const Text("Clients cannot add products."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
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
                    userName != null
                        ? "Hi $userName 👋🏼"
                        : "⚠️ No name available",
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
        onTap: (index) async {
          if (index == 2) {
            // If "Add" icon is clicked
            String? userType = await getUserTypeFromFirestore();

            if (userType == "Client") {
              showMessagePopup(); // Show popup if the user is a client
            } else {
              navigateToUserPage(context);
            }
          } else {
            setState(() {
              currentPageIndex = index;
            });
          }

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
