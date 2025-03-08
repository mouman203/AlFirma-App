import 'package:agriplant/pages/cart_page.dart';
import 'package:agriplant/pages/explore_page.dart';
import 'package:agriplant/pages/profile_page.dart';
import 'package:agriplant/pages/services_page.dart';
import 'package:badges/badges.dart' as badges;
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
     const ExplorePage1(),
    const ServicesPage(),
    const CartPage(),
    const ProfilePage()
  ];
  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // يستخدم هذا الدالة للحصول على اسم المستخدم الحالي

  Future<String?> getUserNameFromFirestore() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null){print("⚠️ لا يوجد مستخدم مسجل الدخول!");return null;}  // لا يوجد مستخدم مسجل

  DocumentSnapshot userDoc = 
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

  if (userDoc.exists) {
    return userDoc['first_name']; // جلب الاسم من Firestore
  } else {
    return null; // لا يوجد بيانات للمستخدم
  }
}
 
 // يستخدم هذا الدالة للتحقق من تسجيل الدخول
 bool isUserSignedIn() {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null; // إذا كان هناك مستخدم مسجل، تعود true
}

    //  
    Future<void> _loadLastSelectedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(mounted){
    setState(() {
      currentPageIndex = prefs.getInt('lastPageIndex') ?? 0;
    });}
  }

  Future<void> _saveLastSelectedPage(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastPageIndex', index);
  }

  Future<void> _refreshPage() async {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, _, __) => const HomePage(),
      transitionDuration: Duration.zero,
    ),
  );
}



   @override
  void initState() {
    super.initState();
    _loadLastSelectedPage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(),
      appBar: AppBar(
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
            FutureBuilder<String?>(
                future: getUserNameFromFirestore(), // استدعاء الدالة التي تجلب الاسم
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("⏳ جاري التحميل...",style: Theme.of(context).textTheme.titleMedium,); // أثناء جلب البيانات
                  }
                  if (snapshot.hasError || snapshot.data == null) {
                    return Text("⚠️ لا يوجد اسم متاح",style: Theme.of(context).textTheme.titleMedium,); // عند حدوث خطأ أو عدم العثور على اسم
                  }
                  return Text(
                    "Hi! ${snapshot.data}", // عرض الاسم بعد جلبه بنجاح
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                },
                ),  
            Text("Enjoy our services",
                style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {},
              icon: badges.Badge(
                badgeContent: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: -15, end: -12),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.green,
                ),
                child: const Icon(IconlyBroken.notification),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: pages[currentPageIndex]),






      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
          _saveLastSelectedPage(index); // Save selected page
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.home),
            label: "Home",
            activeIcon: Icon(IconlyBold.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.call),
            label: "Services",
            activeIcon: Icon(IconlyBold.call),
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

