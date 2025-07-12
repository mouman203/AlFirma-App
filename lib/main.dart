import 'package:agriplant/Front_end/Authentication/LoginPage.dart';
import 'package:agriplant/Front_end/Authentication/sign_up_page.dart';
import 'package:agriplant/Front_end/Profile/Settings/settings.dart';
import 'package:agriplant/Front_end/Profile/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:agriplant/generated/l10n.dart';
import 'package:agriplant/Services/Notification_services.dart';

Future<void> setupFCMToken() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    //  Init foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        NotificationService().showNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
      }
    });

    // Get initial token
    String? token = await messaging.getToken();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && token != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({'fcmToken': token});
      print("FCM token saved to Firestore: $token");
    }

    // Listen for token refresh
    messaging.onTokenRefresh.listen((newToken) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({'fcmToken': newToken});
        print("FCM token updated in Firestore: $newToken");
      }
    });
  } catch (e) {
    print("Error setting up FCM: $e");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );

    // Init local notifications
    await NotificationService().initNotification();

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
      await setupFCMToken();
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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
      supportedLocales: S.delegate.supportedLocales, // <-- Updated
      localizationsDelegates: const [
        S.delegate, 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: FutureBuilder<Widget>(
        future: initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            final colorScheme = Theme.of(context).colorScheme;
            return Scaffold(
              backgroundColor: colorScheme.surface,
              body:  Center(
                child: CircularProgressIndicator(backgroundColor: colorScheme.surface,),
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
