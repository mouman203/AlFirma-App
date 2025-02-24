import 'package:agriplant/pages/auth/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? emailError;
  String? passwordError;
  bool _obscurePassword = true; // التحكم في إخفاء أو إظهار كلمة المرور
  bool _rememberMe = false; // حالة "تذكرني"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SIGN IN")),
      body: SingleChildScrollView(
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
                    fontSize: 40, fontWeight: FontWeight.bold)),
            Text("Welcome to our platform",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                )),
            const SizedBox(height: 20),

            // حقل البريد الإلكتروني
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.email),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
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
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.password),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          obscureText:
                              _obscurePassword, // إخفاء النص المدخل إذا كان true
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            errorText: passwordError,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color:
                                    Colors.black, // أيقونة العين لتبديل الحالة
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

            // خيارات "تذكرني" و "نسيت كلمة المرور"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale:
                              0.8, // النسبة المطلوبة لتكبير أو تصغير حجم الـ Checkbox
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                          ),
                        ),
                        Text(
                          "Remember me",
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // منطق إعادة تعيين كلمة المرور
                        print("Forgot password button pressed!");
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.roboto(
                            fontSize: 16, color: Colors.green.shade700),
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
                  onPressed: () {
                    setState(() {
                      emailError = null;
                      passwordError = null;
                    });

                    // الحصول على النص المدخل
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    // التحقق من صحة البريد الإلكتروني باستخدام تعبير عادي
                    RegExp emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                    if (email.isEmpty || password.isEmpty) {
                      setState(() {
                        if (email.isEmpty) {
                          emailError = "يرجى إدخال البريد الإلكتروني";
                        }
                        if (password.isEmpty) {
                          passwordError = "يرجى إدخال كلمة المرور";
                        }
                      });
                    } else if (!emailRegex.hasMatch(email)) {
                      setState(() {
                        emailError = "البريد الإلكتروني غير صالح";
                      });
                    } else {
                      // إذا كان كل شيء صحيحًا
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700, // لون الزر
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
    // Navigate to the SignUpPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  },
  child: Text(
    "SIGN UP",
    style: GoogleFonts.roboto(color: Colors.green, fontSize: 16),
  ),
),


            // sign in another way

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    print("Facebook button pressed!");
                  },
                  icon: const Icon(
                    Icons.facebook,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                ),
                const SizedBox(width: 40), // مسافة بين الأيقونات
                IconButton(
                  onPressed: () {
                    print("Apple button pressed!");
                  },
                  icon: const Icon(
                    Icons.apple,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ),
                const SizedBox(width: 40), // مسافة بين الأيقونات
                IconButton(
                  onPressed: () {
                    print("Google button pressed!");
                  },
                  icon: Image.asset(
                    'assets/google.png', // مسار الأيقونة
                    width: 25.0, // عرض الصورة
                    height: 25.0, // ارتفاع الصورة
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
