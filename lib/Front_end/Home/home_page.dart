import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Home/Add_Product.dart';
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
    AddProducts(),
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

  // Map to translate Arabic type names to the current language
  Map<String, String> arabicToTranslatedMap(BuildContext context) {
    return {
      'فلاح': S.of(context).agriculteur,
      'مربي الماشية': S.of(context).eleveur,
      'خبير زراعي': S.of(context).expertAgri,
      'بيطري': S.of(context).veterinaire,
      'شركة': S.of(context).entreprise,
      'ناقل': S.of(context).transporteur,
      'مصلح': S.of(context).reparateur,
      'تاجر': S.of(context).commercant,
      'عميل': S.of(context).client, // Adding "Client" translation
    };
  }

  // Translate a single Arabic type to the current language
  String translateType(String arabicType, BuildContext context) {
    final translations = arabicToTranslatedMap(context);
    return translations[arabicType] ?? arabicType;
  }

  Future<void> _loadSelectedType() async {
    final arabicType = await getActiveTypeArabicOnly();

    if (!mounted) return;

    setState(() {
      selectedType = translateType(arabicType, context);
      isLoading = false;
    });

    currentPageIndex = 0;
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

    List<String> arabicTypes = [];
    List<String> translatedTypes = [];

    if (doc.exists && doc.data()?['userType'] != null) {
      arabicTypes = List<String>.from(doc['userType']);

      // Translate each type to the current language
      translatedTypes =
          arabicTypes.map((type) => translateType(type, context)).toList();
    }

    // Default fallback to "Client"
    if (arabicTypes.isEmpty) {
      arabicTypes = ["عميل"]; // Default is "عميل" in Arabic
      translatedTypes = [S.of(context).client]; // Translate to current language

      await docRef.set({
        "userType": arabicTypes,
        "activeType": "عميل",
      }, SetOptions(merge: true));
    }

    return translatedTypes;
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
        transitionDuration: Duration.zero,
      ),
    );
  }

  Future<String> getActiveTypeArabicOnly() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "عميل";

    final doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .get();
    if (doc.exists) {
      final data = doc.data();
      return data?['activeType'] ?? "عميل";
    }

    return "عميل";
  }

  void navigateToUserPage(BuildContext context) async {
    String? arabicType = await getActiveTypeArabicOnly();

    String translatedType = translateType(arabicType, context);

    print("✅ Active user type: $translatedType");
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
    final locale = Localizations.localeOf(context).languageCode;

// List of types that need "l’" in French
    final lAList = [
      "agriculteur",
      "entreprise",
      "expert Agricole",
      "éleveur de bétail"
    ];

    final startsWithL = selectedType != null &&
        lAList.any((term) => selectedType!.contains(term));

    final article = locale == 'fr'
        ? (startsWithL ? "L’" : S.of(context).the)
        : S.of(context).the;

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
                // Wrap the selectedType text in a Row + Flexible + FittedBox
                if (selectedType != null)
                  Row(
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "$article $selectedType",
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    S.of(context).guestSubtitle,
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
                            borderRadius: BorderRadius.circular(12)),
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
          final isGuest = Users.isGuestUser();
          final isRestrictedIndex = index == 2 || index == 3 || index == 4;

          // Convert restricted types to their translated equivalents for comparison
          final restrictedTypesArabic = ["بيطري", "شركة", "عميل"];
          final restrictedTypes = restrictedTypesArabic
              .map((type) => translateType(type, context))
              .toList();

          final isRestrictedType =
              !isGuest && index == 2 && restrictedTypes.contains(selectedType);

          if ((isGuest && isRestrictedIndex) || isRestrictedType) {
            final message = isGuest
                ? S.of(context).guestAccessLimited
                : "$selectedType ${S.of(context).userTypeCannotAdd}";

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.black),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.home),
            label: S.of(context).nav_home,
            activeIcon: Icon(IconlyBold.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.work),
            label: S.of(context).nav_services,
            activeIcon: Icon(IconlyBold.work),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.plus),
            label: S.of(context).nav_add,
            activeIcon: Icon(IconlyBold.plus),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.message),
            label: S.of(context).nav_messages,
            activeIcon: Icon(IconlyBold.message),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.profile),
            label: S.of(context).nav_profile,
            activeIcon: Icon(IconlyBold.profile),
          ),
        ],
      ),
    );
  }
}
