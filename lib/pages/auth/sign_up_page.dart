import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? nameError;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SIGN UP")),
      body: SingleChildScrollView(
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

            // Name field
            _buildTextField(
              controller: _nameController,
              icon: Icons.person,
              hintText: "Name",
              errorText: nameError,
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
          nameError = null;
          emailError = null;
          passwordError = null;
          confirmPasswordError = null;
        });

        // الحصول على النصوص المدخلة
        String name = _nameController.text.trim();
        String email = _emailController.text.trim();
        String phone = _phoneController.text.trim();
        String password = _passwordController.text.trim();
        String confirmPassword = _confirmPasswordController.text.trim();

        // تعبيرات منتظمة للتحقق من صحة البريد الإلكتروني ورقم الهاتف
        RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        RegExp phoneRegex = RegExp(r'^[0-9]{9,10}$'); // التحقق من أن الرقم يحتوي على 9 أو 10 أرقام

        // التحقق من الحقول
        if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
          setState(() {
            if (name.isEmpty) nameError = "يرجى إدخال الاسم";
            if (email.isEmpty) emailError = "يرجى إدخال البريد الإلكتروني";
            if (phone.isEmpty) phoneError = "يرجى إدخال رقم الهاتف";
            if (password.isEmpty) passwordError = "يرجى إدخال كلمة المرور";
            if (confirmPassword.isEmpty) confirmPasswordError = "يرجى تأكيد كلمة المرور";
          });
        } else if (!emailRegex.hasMatch(email)) {
          setState(() {
            emailError = "البريد الإلكتروني غير صالح";
          });
        } else if (!phoneRegex.hasMatch(phone)) {
          setState(() {
            phoneError = "رقم الهاتف غير صالح (يجب أن يحتوي على 9 أو 10 أرقام)";
          });
        } else if (password.length < 8) {
          setState(() {
            passwordError = "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
          });
        } else if (password != confirmPassword) {
          setState(() {
            confirmPasswordError = "كلمتا المرور غير متطابقتين";
          });
        } else {
          // إذا كان كل شيء صحيحًا
          print("Name: $name");
          print("Email: $email");
          print("Phone: $phone");
          print("Wilaya: $_selectedWilaya");
          print("Password: $password");
          // هنا يمكنك إضافة منطق تسجيل الحساب
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

          ],
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
                        obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
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