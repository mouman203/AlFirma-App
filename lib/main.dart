import 'package:agriplant/Front_end/Authentication/LoginPage.dart';
import 'package:agriplant/Front_end/Authentication/sign_up_page.dart';
import 'package:agriplant/Front_end/Profile/Settings/settings.dart';
import 'package:agriplant/Front_end/Profile/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agriplant/Front_end/Home/home_page.dart';
import 'package:agriplant/Front_end/Providers/theme_provider.dart';
import 'package:agriplant/Front_end/Providers/language_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );

    print("Firebase initialized successfully.");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

Future<bool> fetchUserVerificationStatus() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is signed in.");
      return false;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      var verifyValue = userDoc.get('Verify');
      return verifyValue == true;
    } else {
      print('User document does not exist.');
      return false;
    }
  } catch (e) {
    print('Error fetching user verification status: $e');
    return false;
  }
}

Future<Widget> initializeApp() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      bool isVerified = await fetchUserVerificationStatus();
      if (isVerified) {
        return const HomePage();
      }
      if (user.isAnonymous) {
        return const HomePage();
      }
    }

    if (user == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }

    return const HomePage();
  } catch (e) {
    print('Error during app initialization: $e');
    return const LoginPage();
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.isAnonymous) {
        try {
          await user.delete();
          debugPrint("Anonymous user deleted on app close.");
        } catch (e) {
          debugPrint("Error deleting anonymous user on app close: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.nunitoTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 53, 120, 88),
        ),
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.nunitoTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 16, 24, 20),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 16, 24, 20),
          foregroundColor: Colors.white,
          elevation: 5,
        ),
      ),
      locale: languageProvider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: FutureBuilder<Widget>(
        future: initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return snapshot.data!;
          }
        },
      ),
      routes: {
        'home_page': (context) => const HomePage(),
        'sign_up_page': (context) => const SignUpPage(),
        'login_page': (context) => const LoginPage(),
        'settings_page': (context) => const SettingsPage(),
        'profile_page': (context) => const ProfilePage(),
      },
    );
  }
}
