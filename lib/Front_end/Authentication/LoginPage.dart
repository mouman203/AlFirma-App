import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Home/home_page.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final String? frompage;

  const LoginPage({super.key, this.frompage});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Users user = Users(); // كائن من كلاس Auth
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool _obscurePassword = true; // التحكم في إخفاء أو إظهار كلمة المرور

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30.0), // Set your desired height
          child: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 28,
                  color: isDarkMode
                      ? const Color(0xFF90D5AE)
                      : const Color(0xFF256C4C),
                ),
                onPressed: () async {
                  try {
                    // Sign in anonymously
                    await FirebaseAuth.instance.signInAnonymously();

                    // Navigate to HomePage after successful anonymous login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } catch (e) {
                    // Handle errors (e.g., show a dialog or snackbar)
                    print("Anonymous sign-in failed: $e");
                  }
                }),
            backgroundColor: Colors.transparent, // Transparent background
            elevation: 0, // Remove shadow
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // الصورة
                Image.asset(
                  "assets/onboarding.png",
                  height: 300,
                ),
                const SizedBox(height: 10),

                // النص الترحيبي
                Text(S.of(context).signIn,
                    style: GoogleFonts.roboto(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? Colors.white // white in dark mode
                          : Colors.black,
                    )),
                Text(S.of(context).welcomeMessage2,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: isDarkMode
                          ? Colors.white // white in dark mode
                          : Colors.black,
                    )),
                const SizedBox(height: 20),

                // حقل البريد الإلكتروني
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color.fromARGB(
                              255, 39, 57, 48) // Dark green in dark mode
                          : Theme.of(context)
                              .colorScheme
                              .secondaryContainer, // Light green in light mode
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(Icons.email,
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF256C4C)),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white // white in dark mode
                                      : const Color(0xFF256C4C),
                                  fontSize: 16),
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: S.of(context).email,
                                hintStyle: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white // white in dark mode
                                        : const Color(0xFF256C4C)),
                                errorText: emailError,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // حقل كلمة المرور مع إمكانية إظهارها أو إخفائها
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color.fromARGB(
                              255, 39, 57, 48) // Dark green in dark mode
                          : Theme.of(context)
                              .colorScheme
                              .secondaryContainer, // Light green in light mode
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(Icons.password,
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF256C4C)),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white // white in dark mode
                                      : const Color(0xFF256C4C),
                                  fontSize: 16),
                              controller: _passwordController,
                              obscureText:
                                  _obscurePassword, // إخفاء النص المدخل إذا كان true
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: S.of(context).passwordHint,
                                hintStyle: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white // white in dark mode
                                      : const Color(0xFF256C4C),
                                ),
                                errorText: passwordError,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(
                                            0xFF256C4C), // أيقونة العين لتبديل الحالة
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword =
                                          !_obscurePassword; // تغيير الحالة عند النقر على الأيقونة
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                //  و "نسيت كلمة المرور؟"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode
                                  ? const Color(0xFF90D5AE)
                                  : const Color(0xFF256C4C),
                            ),
                            children: [
                              TextSpan(
                                text: S.of(context).forgotPassword,
                                style: const TextStyle(
                                  decoration: TextDecoration
                                      .underline, // Underline the text
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    // Logic for resetting password
                                    user.resetPassword(
                                      context: context,
                                      email: _emailController.text,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                // زر تسجيل الدخول
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        user.signInWithHandling(
                          context: context,
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                          homePage: const HomePage(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C), // لون الزر
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(S.of(context).login,
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: isDarkMode ? Colors.black : Colors.white)),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                RichText(
                  text: TextSpan(
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: S.of(context).noAccount,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: S.of(context).signup,
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context)
                                .pushReplacementNamed('sign_up_page');
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // sign in another way

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        user.signInWithGoogle(context, const HomePage());
                      },
                      icon: Image.asset(
                        'assets/google.png', // مسار الأيقونة
                        width: 45, // عرض الصورة
                        height: 40, // ارتفاع الصورة
                      ),
                    ),
                    const SizedBox(width: 45), // مسافة بين الأيقونا
                    IconButton(
                      onPressed: () {
                        print("Facebook button pressed!");
                      },
                      icon: const Icon(
                        Icons.facebook,
                        color: Colors.blue,
                        size: 48,
                      ),
                    ),
                    const SizedBox(width: 40), // مسافة بين الأيقونات
                    IconButton(
                      onPressed: () {
                        print("Apple button pressed!");
                      },
                      icon: const Icon(
                        Icons.apple,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: 59,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}
