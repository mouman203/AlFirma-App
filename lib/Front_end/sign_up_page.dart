import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/home_page.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Users user = Users();
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
  String? wilayaError;
  String? dairaError;
  String? passwordError;
  String? confirmPasswordError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Wilaya selection variables
  String? _selectedWilaya;
  String? _selectedDaira;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: isDarkMode ? colorScheme.surface : colorScheme.surface,
        elevation: 8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(
              context, 'login_page'), // Back button functionality
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("WELCOME",
                  style: GoogleFonts.roboto(
                      fontSize: 40, fontWeight: FontWeight.bold)),
              Text("Join our platform and get started",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                  )),

              //profile pic

              /*GestureDetector(
            onTap: ,
            child: Padding(
              padding: const EdgeInsets.only(top: 54, bottom: 16),
              child: CircleAvatar(
                radius: 90,
                backgroundColor: Colors.grey[500],
                backgroundImage:
                   _imageFile != null
      ? FileImage(_imageFile!)
      : (imagePath != null
          ? NetworkImage(imagePath!) as ImageProvider<Object>
          : null),
              
                child: _imageFile == null
                    ? const Icon(Icons.camera_alt,
                        size: 30, color: Colors.black54)
                    : null,
              ),
            ),
          ),*/

              const SizedBox(height: 46),

              // firstName field
              _buildTextField(
                controller: _firstNameController,
                keyType: TextInputType.name,
                icon: Icons.person,
                hintText: "First Name",
                errorText: firstNameError,
              ),

              const SizedBox(height: 20),
              // lastName field
              _buildTextField(
                controller: _lastNameController,
                keyType: TextInputType.name,
                icon: Icons.person,
                hintText: "Last Name",
                errorText: lastNameError,
              ),
              const SizedBox(height: 20),

              // Email field
              _buildTextField(
                controller: _emailController,
                keyType: TextInputType.emailAddress,
                icon: Icons.email,
                hintText: "Email",
                errorText: emailError,
              ),
              const SizedBox(height: 20),

              // Phone number field
              _buildTextField(
                controller: _phoneController,
                keyType: TextInputType.number,
                icon: Icons.phone,
                hintText: "Phone Number",
                errorText: phoneError,
              ),
              const SizedBox(height: 20),

              // Wilaya dropdown
              buildLocationDropdown(
                selectedValue: _selectedWilaya,
                items: ProductData.wilayas.keys.toList(),
                label: "wilaya",
                errorText: wilayaError,
                onChanged: (value) {
                  setState(() {
                    _selectedWilaya = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              //Daira dropdown
              buildLocationDropdown(
                selectedValue: _selectedDaira,
                items: ProductData.wilayas[_selectedWilaya] ?? [],
                label: "daira",
                errorText: dairaError,
                onChanged: (value) {
                  setState(() {
                    _selectedDaira = value;
                  });
                },
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
              const SizedBox(height: 70),

              // زر التسجيل
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_firstNameController.text.isEmpty ||
                            _lastNameController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _phoneController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _confirmPasswordController.text.isEmpty ||
                            _selectedDaira == null ||
                            _selectedWilaya == null) {
                          if (_firstNameController.text.isEmpty) {
                            firstNameError = "يرجى إدخال الاسم";
                          }
                          if (_lastNameController.text.isEmpty) {
                            lastNameError = "يرجى إدخال اللقب";
                          }
                          if (_emailController.text.isEmpty) {
                            emailError = "يرجى إدخال البريد الإلكتروني";
                          }
                          if (_phoneController.text.isEmpty) {
                            phoneError = "يرجى إدخال رقم الهاتف";
                          }
                          if (_selectedWilaya == null) {
                            wilayaError = 'يرجى اختيار الولاية';
                          }
                          if (_selectedDaira == null) {
                            dairaError = 'يرجى اختيار الدائرة';
                          }
                          if (_passwordController.text.isEmpty) {
                            passwordError = "يرجى إدخال كلمة المرور";
                          }
                          if (_confirmPasswordController.text.isEmpty) {
                            confirmPasswordError = "يرجى تأكيد كلمة المرور";
                          }
                          return;
                        } else if (!user.isEmailValid(_emailController.text)) {
                          emailError = "البريد الإلكتروني غير صالح";
                        } else if (!user
                            .isPasswordValid(_passwordController.text)) {
                          passwordError =
                              "كلمة المرور يجب أن تحتوي على 6 أحرف على الأقل";
                        } else if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          confirmPasswordError = "كلمة المرور غير متطابقة";
                        } else if (!user.isPhoneValid(_phoneController.text)) {
                          phoneError = "رقم الهاتف غير صالح";
                        } else {
                          user.signUp(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text,
                            confirmationpassword:
                                _confirmPasswordController.text,
                            phone: _phoneController.text,
                            wilaya: _selectedWilaya ?? '',
                            daira: _selectedDaira ?? '',
                            destPage:
                                const HomePage(), // Assuming HomePage is a Widget
                            first_name: _firstNameController.text,
                            last_name: _lastNameController.text,
                            verify: false,
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? const Color(0xFF90D5AE)
                          : const Color(0xFF256C4C),
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
      ),
    );
  }

  // Helper methods for TextField and PasswordField
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required TextInputType keyType,
    String? errorText,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color.fromARGB(255, 39, 57, 48) // Dark green in dark mode
              : Theme.of(context)
                  .colorScheme
                  .secondaryContainer, // Light green in light mode
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  inputFormatters: hintText == "Phone Number"
                      ? [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ]
                      : null,
                  keyboardType: keyType,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF256C4C),
                    ),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color.fromARGB(255, 39, 57, 48) // Dark green in dark mode
              : Theme.of(context)
                  .colorScheme
                  .secondaryContainer, // Light green in light mode,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(
                Icons.lock,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: TextStyle(
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF256C4C)),
                  controller: controller,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF256C4C)),
                    errorText: errorText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF256C4C),
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

  Widget buildLocationDropdown({
    required String? selectedValue,
    required List<String> items,
    required String label,
    String? errorText,
    required void Function(String?) onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color.fromARGB(255, 39, 57, 48)
                : Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Icon(
                  Icons.add_location_alt_sharp,
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorText: errorText,
                    ),
                    hint: Text(
                      "Select your $label",
                      style: TextStyle(
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF256C4C),
                      ),
                    ),
                    dropdownColor: isDarkMode
                        ? const Color.fromARGB(255, 55, 72, 56)
                        : Theme.of(context).colorScheme.secondaryContainer,
                    value: selectedValue,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF256C4C),
                    ),
                    items: items
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF256C4C),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: onChanged,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
