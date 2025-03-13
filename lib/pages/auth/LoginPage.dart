import 'package:agriplant/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agriplant/pages/auth/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth _authService = auth(); // كائن من كلاس Auth
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool _obscurePassword = true; // التحكم في إخفاء أو إظهار كلمة المرور
 


// i removed from here

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      //appBar: AppBar(title: const Text("SIGN IN")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // الصورة
              Image.asset(
                "assets/onboarding.png",
                height: 350,
              ),
              const SizedBox(height: 10),

              // النص الترحيبي
              Text("SIGN IN",
                  style: GoogleFonts.roboto(
                      fontSize: 40, fontWeight: FontWeight.bold,color: isDarkMode
            ?  Colors.white  // white in dark mode
            :  Colors.black,)),
              Text("Welcome to our platform",
                  style: GoogleFonts.roboto(
                    fontSize: 18,color: isDarkMode
            ?  Colors.white  // white in dark mode
            :  Colors.black,
                  )),
              const SizedBox(height: 20),

              // حقل البريد الإلكتروني
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
            ? const Color.fromARGB(255, 55, 72, 56)  // Dark green in dark mode
            : Colors.green.shade50, // Light green in light mode
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.email,color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(color:isDarkMode
                            ? Colors.white // white in dark mode
                            : const Color.fromARGB(255, 42, 103, 34),
                            fontSize: 16
                            ),
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color:isDarkMode
                            ? Colors.white // white in dark mode
                            : const Color.fromARGB(255, 42, 103, 34)),
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
            ? const Color.fromARGB(255, 55, 72, 56)  // Dark green in dark mode
            : Colors.green.shade50, // Light green in light mode
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                       Icon(Icons.password, color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(color:isDarkMode
                            ? Colors.white // white in dark mode
                            : const Color.fromARGB(255, 42, 103, 34),
                            fontSize: 16
                            ),
                            controller: _passwordController,
                            obscureText:
                                _obscurePassword, // إخفاء النص المدخل إذا كان true
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color:isDarkMode
                            ? Colors.white // white in dark mode
                            : const Color.fromARGB(255, 42, 103, 34)),
                              errorText: passwordError,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color:  isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34) // أيقونة العين لتبديل الحالة
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

              //  و "نسيت كلمة المرور؟"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          // منطق إعادة تعيين كلمة المرور
                          _authService.resetPassword(context: context, email: _emailController.text);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.roboto(
                              fontSize: 16, color:isDarkMode
            ? Colors.white 
            : const Color.fromARGB(255, 42, 103, 34)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // زر تسجيل الدخول
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                     _authService.signInWithHandling(
                      context: context,
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                      homePage: const HomePage(),
                    );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 55, 72, 56)  // Dark green in dark mode
            : const Color.fromARGB(255, 44, 107, 36), // لون الزر
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text("Login",
                        style: GoogleFonts.roboto(
                            fontSize: 18, color: Colors.white)),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // زر إنشاء حساب جديد
              TextButton(
                onPressed: () {
                  // هنا يمكنك إضافة منطق التنقل إلى صفحة إنشاء الحساب
                  Navigator.of(context).pushReplacementNamed('sign_up_page');
                },
                child: Text(
                  "SIGN_UP",
                  style: GoogleFonts.roboto(color: isDarkMode
            ? Colors.white // white in dark mode
            : const Color.fromARGB(255, 42, 103, 34), fontSize: 16),
                ),
              ),

              // sign in another way

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                     _authService.signInWithGoogle( context,const HomePage());
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
            ],
          ),
        ),
      ),
    );
  }
}
