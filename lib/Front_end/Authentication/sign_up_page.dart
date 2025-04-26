import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Authentication/LoginPage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agriplant/data/ProductData.dart';

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
  String? passwordError;
  String? confirmPasswordError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Wilaya selection variables
  String? _selectedWilaya;
  String? _selectedDaira;

  // List to store Dairas based on selected Wilaya
  List<String> availableDairas = [];
  void updateDairaList(String wilaya) {
    setState(() {
      availableDairas = ProductData.wilayas[wilaya] ?? [];
    });
  }

  String getWilayaName(String wilayaWithNumber) {
    return wilayaWithNumber
        .split(" - ")
        .last; // Remove the number and return only the name
  }

  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Back arrow button at the top left
          Padding(
            padding: const EdgeInsets.only(top: 60, right: 350),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                size: 40,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }, // Back button functionality
            ),
          ),

          // Centered content in the body
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10), // Space for the back button
                    Text("WELCOME",
                        style: GoogleFonts.roboto(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                    Text("Join our platform and get started",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                        )),

                    const SizedBox(height: 46),

                    // First Name field
                    _buildTextField(
                      controller: _firstNameController,
                      icon: Icons.person,
                      hintText: "First Name",
                      errorText: firstNameError,
                    ),

                    const SizedBox(height: 20),
                    // Last Name field
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
                      hintText: "Phone Number ",
                      errorText: phoneError,
                    ),
                    const SizedBox(height: 20),

                    // Wilaya Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color.fromARGB(255, 39, 57, 48)
                              : Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            value: _selectedWilaya,
                            hint: Text(
                              "Select Wilaya",
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF256C4C),
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 300,
                              offset: const Offset(0, 0),
                              width: MediaQuery.of(context).size.width -
                                  100, // 50 padding left + right
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? const Color.fromARGB(255, 30, 45, 38)
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            buttonStyleData: const ButtonStyleData(
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            iconStyleData: IconStyleData(
                              iconEnabledColor: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF256C4C),
                              iconDisabledColor: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF256C4C),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedWilaya = newValue;
                                _selectedDaira = null;
                              });
                              if (newValue != null) {
                                updateDairaList(newValue);
                              }
                            },
                            selectedItemBuilder: (BuildContext context) {
                              return ProductData.wilayas.keys
                                  .map<Widget>((wilaya) {
                                return Align(
                                  // 👈 Align instead of Center
                                  alignment: Alignment
                                      .centerLeft, // 👈 center vertically, left horizontally
                                  child: Text(
                                    getWilayaName(wilaya),
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF256C4C),
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            items: ProductData.wilayas.keys
                                .map<DropdownMenuItem<String>>((wilaya) {
                              return DropdownMenuItem<String>(
                                value: wilaya,
                                child: Text(
                                  wilaya,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF256C4C),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Daira Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color.fromARGB(255, 39, 57, 48)
                              : Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            value: _selectedDaira,
                            hint: Text(
                              "Select Daira",
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF256C4C),
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 300,
                              offset: const Offset(0, 0),
                              width: MediaQuery.of(context).size.width - 100,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? const Color.fromARGB(255, 30, 45, 38)
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            buttonStyleData: const ButtonStyleData(
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            iconStyleData: IconStyleData(
                              iconEnabledColor: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF256C4C),
                              iconDisabledColor: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF256C4C),
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedDaira = newValue;
                              });
                            },
                            items: availableDairas
                                .map<DropdownMenuItem<String>>((daira) {
                              return DropdownMenuItem<String>(
                                value: daira,
                                child: Text(
                                  daira,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF256C4C),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
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
                    const SizedBox(height: 70),

                    // Sign up button
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
                                  _confirmPasswordController.text.isEmpty) {
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
                                if (_passwordController.text.isEmpty) {
                                  passwordError = "يرجى إدخال كلمة المرور";
                                }
                                if (_confirmPasswordController.text.isEmpty) {
                                  confirmPasswordError =
                                      "يرجى تأكيد كلمة المرور";
                                }
                                return;
                              } else if (!user
                                  .isEmailValid(_emailController.text)) {
                                emailError = "البريد الإلكتروني غير صالح";
                              } else if (!user
                                  .isPasswordValid(_passwordController.text)) {
                                passwordError =
                                    "كلمة المرور يجب أن تحتوي على 6 أحرف على الأقل";
                              } else if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                confirmPasswordError =
                                    "كلمة المرور غير متطابقة";
                              } else if (!user
                                  .isPhoneValid(_phoneController.text)) {
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
                                  first_name: _firstNameController.text,
                                  last_name: _lastNameController.text,
                                  verify: false,
                                  daira: _selectedDaira ?? '',
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
                                  fontSize: 18,
                                  color: isDarkMode
                                      ? Colors.black
                                      : Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                  style: TextStyle(
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF256C4C)),
                  controller: controller,
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
}
