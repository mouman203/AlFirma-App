import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Client.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Expert.dart';
import 'package:agriplant/Front_end/Sidebar.dart';
import 'package:agriplant/Front_end/explore_page.dart';
import 'package:agriplant/Front_end/Meseges/messeges.dart';
import 'package:agriplant/Front_end/profile_page.dart';
import 'package:agriplant/Front_end/Services/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Agriculteur.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Eleveur.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Reparateur.dart';
import 'package:agriplant/Front_end/Add%20products%20pages/Add_Product_Transporteur.dart';
import 'package:agriplant/Front_end/user_type_handler.dart';

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
    setState(() {
      selectedType = type;
    });
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
        page = const AddProductExpert();
        print("im $selectedType");
        break;
      case 'Transporteur':
        page = const AddProductTransporteur();
        print("im $selectedType");
        break;
      case 'Réparateur':
        page = const AddProductReparateur();
        print("im $selectedType");
        break;
      default:
        print("🚨 Unknown userType: $selectedType");
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void showMessagePopup(String? value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("⚠️ Access Restricted"),
          content: Text("$value cannot add products."),
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
            isLoading
                ? Text(
                    "⏳ Loading...",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                : Text(
                    userName != null
                        ? "Hi ${userName![0].toUpperCase()}${userName!.substring(1)} 👋🏼"
                        : "Welcome 👋🏼 ",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
            Text("The ${selectedType} ",
                style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
        actions: [
          BecomeTypeAction(onTypeChanged: _loadSelectedType),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(IconlyBroken.notification),
            ),
          ),
        ],
      ),
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
          if (index == 2) {
            // If "Add" icon is clicked
            String? activeType = (await getActiveTypeFromFirestore());

            if (activeType == "Client" ||
                activeType == "Vétérinaire" ||
                activeType == "Entreprise") {
              showMessagePopup(
                  activeType); // Show popup if the user is a client
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
