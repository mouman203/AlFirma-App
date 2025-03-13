import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agriplant/pages/auth/LoginPage.dart';
import 'package:agriplant/pages/home_page.dart';
import 'package:agriplant/pages/auth/sign_up_page.dart';
import 'package:agriplant/pages/settings.dart'; 
import 'package:agriplant/pages/theme_provider.dart';
import 'package:agriplant/pages/language_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    appBarTheme: const AppBarTheme(
      
      foregroundColor: Colors.black, // Light mode text/icons
    ),
  ),
  darkTheme: ThemeData.dark().copyWith(
    textTheme: GoogleFonts.nunitoTextTheme().apply(
      bodyColor: Colors.white, // Ensures text is white in dark mode
      displayColor: Colors.white,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
      brightness: Brightness.dark, // Adjusts colors for dark mode
    ),
    scaffoldBackgroundColor: Color.fromARGB(255, 1, 20, 7), // Ensures dark mode background
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 1, 24, 8), // Dark mode app bar color
      foregroundColor: Colors.white, // Dark mode text/icons
    ),
  ),
  locale: languageProvider.locale,
  supportedLocales: const [
    Locale('en'),
    Locale('fr'),
    Locale('ar'), // Arabic
  ],
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified)
      ? HomePage()
      : LoginPage(),
  routes: {
    'home_page': (context) => const HomePage(),
    'sign_up_page': (context) => const SignUpPage(),
    'login_page': (context) => const LoginPage(),
    'settings_page': (context) =>  Settings(),
  },
    );

  }
}
