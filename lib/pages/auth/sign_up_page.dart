import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Wilaya selection variables
  String? _selectedWilaya;
  final List<String> _wilayas = [
    "Adrar",
    "Chlef",
    "Laghouat",
    "Oum El Bouaghi",
    "Batna",
    "Béjaïa",
    "Biskra",
    "Béchar",
    "Blida",
    "Bouira",
    "Tamanrasset",
    "Tébessa",
    "Tlemcen",
    "Tiaret",
    "Tizi Ouzou",
    "Algiers",
    "Djelfa",
    "Jijel",
    "Sétif",
    "Saïda",
    "Skikda",
    "Sidi Bel Abbès",
    "Annaba",
    "Guelma",
    "Constantine",
    "Médéa",
    "Mostaganem",
    "M'Sila",
    "Mascara",
    "Ouargla",
    "Oran",
    "El Bayadh",
    "Illizi",
    "Bordj Bou Arréridj",
    "Boumerdès",
    "El Tarf",
    "Tindouf",
    "Tissemsilt",
    "El Oued",
    "Khenchela",
    "Souk Ahras",
    "Tipaza",
    "Mila",
    "Aïn Defla",
    "Naâma",
    "Aïn Témouchent",
    "Ghardaïa",
    "Relizane"
  ];

  Future<void> addUser() async {
    // ignore: non_constant_identifier_names
    String first_name = _firstNameController.text.trim();
    String last_name = _lastNameController.text.trim();
    String phone = _phoneController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    bool verify = false;

    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: email).get();

    try {
      // Step 0: Check if email exists
      if (querySnapshot.docs.isNotEmpty) {
        // User exists
        print("User with email $email exists in Firestore.");
        AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.scale,
                title: 'E-mail Existing',
                desc: '$email exist already')
            .show();
      } else {
        // User does not exist
        print("User with email $email does not exist in Firestore.");

        // Step 1: Create user in Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Send verification email
        User? user = userCredential.user;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
        }

        String uid = userCredential.user!.uid;

        // Step 2: Add user details to Firestore
        await FirebaseFirestore.instance.collection('Users').doc(uid).set({
          'first_name': first_name,
          'last_name': last_name,
          'phone': phone,
          'email': email,
          'password': password,
          'createdAt': FieldValue.serverTimestamp(),
          'Verify': verify,
        });
        print('User registered successfully');

        Navigator.of(context).pushNamed("login_page");
        AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.scale,
                title: 'Noiiiiice',
                desc:
                    'know you are one of us .. \n last step : plz go to verify your e-mail')
            .show();
        print("Verification E-mail sent successfully");
      }
    } catch (e) {
      print('Registration failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("SIGN UP",
                  style: GoogleFonts.roboto(
                      fontSize: 40, fontWeight: FontWeight.bold)),
              Text("Join our platform and get started",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                  )),
              const SizedBox(height: 20),

              // firstName field
              _buildTextField(
                controller: _firstNameController,
                icon: Icons.person,
                hintText: "First Name",
                errorText: firstNameError,
              ),

              const SizedBox(height: 20),
              // lastName field
              _buildTextField(
                controller: _lastNameController,
                icon: Icons.person,
                hintText: "Last Name",
                errorText: lastNameError,
              ),
              const SizedBox(height: 20),

              // Email field
              _buildTextField(
                controller: _emailController,
                icon: Icons.email,
                hintText: "Email",
                errorText: emailError,
              ),
              const SizedBox(height: 20),

              // Phone number field
              _buildTextField(
                controller: _phoneController,
                icon: Icons.phone,
                hintText: "Phone Number",
                errorText: phoneError,
              ),
              const SizedBox(height: 20),

              // Wilaya dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    hint: const Text("Select your Wilaya"),
                    value: _selectedWilaya,
                    items: _wilayas
                        .map((wilaya) => DropdownMenuItem(
                              value: wilaya,
                              child: Text(wilaya),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedWilaya = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password field
              _buildPasswordField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                hintText: "Password",
                errorText: passwordError,
                toggleObscure: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Confirm Password field
              _buildPasswordField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                hintText: "Confirm Password",
                errorText: confirmPasswordError,
                toggleObscure: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 20),

              // زر التسجيل
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        firstNameError = null;
                        lastNameError = null;
                        emailError = null;
                        passwordError = null;
                        confirmPasswordError = null;
                      });

                      // الحصول على النصوص المدخلة
                      String firstName = _firstNameController.text.trim();
                      String lastName = _lastNameController.text.trim();
                      String email = _emailController.text.trim();
                      String phone = _phoneController.text.trim();
                      String password = _passwordController.text.trim();
                      String confirmPassword =
                          _confirmPasswordController.text.trim();

                      // تعبيرات منتظمة للتحقق من صحة البريد الإلكتروني ورقم الهاتف
                      RegExp emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      RegExp phoneRegex = RegExp(
                          r'^[0-9]{9,10}$'); // التحقق من أن الرقم يحتوي على 9 أو 10 أرقام

                      // التحقق من الحقول

                      // if (test()) {
                      //   emailError = "البريد الإلكتروني موجود مسبقاً";
                      // }

                      if (firstName.isEmpty ||
                          lastName.isEmpty ||
                          email.isEmpty ||
                          phone.isEmpty ||
                          password.isEmpty ||
                          confirmPassword.isEmpty) {
                        setState(() {
                          if (firstName.isEmpty)
                            firstNameError = "يرجى إدخال الاسم";
                          if (lastName.isEmpty)
                            lastNameError = "يرجى إدخال اللقب";
                          if (email.isEmpty)
                            emailError = "يرجى إدخال البريد الإلكتروني";
                          if (phone.isEmpty)
                            phoneError = "يرجى إدخال رقم الهاتف";
                          if (password.isEmpty)
                            passwordError = "يرجى إدخال كلمة المرور";
                          if (confirmPassword.isEmpty)
                            confirmPasswordError = "يرجى تأكيد كلمة المرور";
                        });
                      } else if (!emailRegex.hasMatch(email)) {
                        setState(() {
                          emailError = "البريد الإلكتروني غير صالح";
                        });
                      } else if (!phoneRegex.hasMatch(phone)) {
                        setState(() {
                          phoneError =
                              "رقم الهاتف غير صالح (يجب أن يحتوي على 9 أو 10 أرقام)";
                        });
                      } else if (password.length < 8) {
                        setState(() {
                          passwordError =
                              "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
                        });
                      } else if (password != confirmPassword) {
                        setState(() {
                          confirmPasswordError = "كلمتا المرور غير متطابقتين";
                        });
                      } else {
                        // إذا كان كل شيء صحيحًا
                        /*print("Name: $firstName");
                        print("Last Name: $lastName");
                        print("Email: $email");
                        print("Phone: $phone");
                        print("Wilaya: $_selectedWilaya");
                        print("Password: $password");*/
                        // هنا يمكنك إضافة منطق تسجيل الحساب
                        addUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text("Sign Up",
                        style: GoogleFonts.roboto(
                            fontSize: 18, color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to SignInPage
                  Navigator.pushNamed(context, 'login_page');
                },
                child: Text('Back to Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods for TextField and PasswordField
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    String? errorText,
  }) {
    return Padding(
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
              Icon(icon),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    errorText: errorText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required String hintText,
    String? errorText,
    required VoidCallback toggleObscure,
  }) {
    return Padding(
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
              const Icon(Icons.lock),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    errorText: errorText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: toggleObscure,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
