import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

//google sign in
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //if the googleUser == null we have to go out from the function
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context)
        .pushNamedAndRemoveUntil("home_page", (route) => false);
  }

// i removed from here

  @override
  Widget build(BuildContext context) {
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
                                  color: Colors
                                      .black, // أيقونة العين لتبديل الحالة
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
                        onPressed: () async {
                          // منطق إعادة تعيين كلمة المرور

                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: _emailController.text);
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.scale,
                                    title: 'Hey Yeeeeeeeh',
                                    desc:
                                        'we sent a reset password e-mail .. go to check it ;)')
                                .show();
                          } catch (e) {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.scale,
                                    title: 'Hmmmmmmmm',
                                    desc:
                                        'we faced a problem with your reset password request): => $e ')
                                .show();
                          }
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
                    onPressed: () async {
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

                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          User? user = userCredential.user;

                          if (user != null && user.emailVerified) {
                            Navigator.of(context).pushNamed("home_page");

                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.scale,
                                    title: 'Success',
                                    desc: 'Welcome ${user.email}')
                                .show();

                            print("User signed in: ${user.email}");
                          } else {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.scale,
                                    title: 'Hmmmmmmmm',
                                    desc: 'Your E-mail is not verified ):')
                                .show();
                            print("Email not verified");
                          }
                        } catch (e) {
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.scale,
                                  title: 'Hmmmmmmmm',
                                  desc:
                                      'we faced a problem with your sign in request ): => $e ')
                              .show();
                          print("Error signing in: $e");
                        }
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
                  // هنا يمكنك إضافة منطق التنقل إلى صفحة إنشاء الحساب
                  Navigator.of(context).pushReplacementNamed('sign_up_page');
                },
                child: Text(
                  "SIGN_UP",
                  style: GoogleFonts.roboto(color: Colors.green, fontSize: 16),
                ),
              ),

              // sign in another way

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    icon: Image.asset(
                      'assets/google.png', // مسار الأيقونة
                      width: 25.0, // عرض الصورة
                      height: 25.0, // ارتفاع الصورة
                    ),
                  ),
                  const SizedBox(width: 40), // مسافة بين الأيقونا
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
