import 'package:agriplant/pages/auth/LoginPage.dart';
import 'package:agriplant/pages/home_page.dart';
import 'package:agriplant/pages/auth/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//im the new one
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: const LoginPage() ,
      //WHAT IS THIS ???
      routes: {
        'home_page': (context) => const HomePage(),
        'sign_up_page': (context) => const SignUpPage(),
        'login_page': (context) => const LoginPage(),
      },
    );
  }
}
