import 'package:agriplant/pages/auth/LoginPage.dart';
import 'package:agriplant/pages/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();
      final auth _authService = auth();


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
                  onPressed: () async {
                final first_name = _firstNameController.text.trim();
                final last_name = _lastNameController.text.trim();
                final phone = _phoneController.text.trim();
                final email = _emailController.text.trim();
                final password = _passwordController.text;
                final confirmationpassword = _confirmPasswordController.text;

                // استخدام دالة signUp من Auth
                await _authService.signUp(
                  context: context,
                  first_name: first_name,
                  last_name: last_name, 
                  phone: phone,
                  email: email,
                  password: password,
                  confirmationpassword: confirmationpassword,
                  destPage: const LoginPage(),
                  verify: false,
                );
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to SignInPage
                  Navigator.pushNamed(context, 'login_page');
                },
                child: const Text('Back to Sign In'),
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
