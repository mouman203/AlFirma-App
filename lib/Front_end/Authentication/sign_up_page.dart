import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Authentication/LoginPage.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  String? wilayaError;
  String? dairaError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Wilaya selection variables
  String? _selectedWilaya;
  String? _selectedDaira;

  // Variables to store Arabic versions
  String? _selectedWilayaArabic;
  String? _selectedDairaArabic;

  // Initialize maps with empty values first
  Map<String, String> _translationMap = {};
  Map<String, String> _reverseTranslationMap = {};

  // List to store Dairas based on selected Wilaya
  List<String> availableDairas = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initTranslationMaps();
      }
    });
  }

  void _initTranslationMaps() {
    try {
      _translationMap = ProductData.buildDairaTranslationMap(context);
      _reverseTranslationMap = {};
      _translationMap.forEach((arabic, localized) {
        _reverseTranslationMap[localized] = arabic;
      });
      print('Translation maps initialized.');
    } catch (e) {
      print('Error initializing translation maps: $e');
    }
  }

  void updateDairaList(String wilaya) {
    setState(() {
      availableDairas = ProductData.wilayasT(context)[wilaya] ?? [];

      // Store the Arabic version of the selected wilaya
      if (_reverseTranslationMap.containsKey(wilaya)) {
        _selectedWilayaArabic = _reverseTranslationMap[wilaya];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 28,
            color:
                isDarkMode ? const Color(0xFF90D5AE) : const Color(0xFF256C4C),
          ),
          onPressed: () {
            // Go back to the HomePage when arrow is pressed
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
        backgroundColor: Colors.transparent, // Transparent AppBar background
        elevation: 0, // Remove shadow
      ),
      body: Column(
        children: [
          // Centered content in the body
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10), // Space for the back button
                    Text(S.of(context).welcome,
                        style: GoogleFonts.roboto(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                    Text(S.of(context).joinOurPlatform,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                        )),
                    const SizedBox(height: 46),

                    // First Name field
                    _buildTextField(
                      controller: _firstNameController,
                      keyType: TextInputType.name,
                      icon: Icons.person,
                      hintText: S.of(context).firstName,
                      errorText: firstNameError,
                    ),

                    const SizedBox(height: 20),
                    // Last Name field
                    _buildTextField(
                      controller: _lastNameController,
                      keyType: TextInputType.name,
                      icon: Icons.person,
                      hintText: S.of(context).lastName,
                      errorText: lastNameError,
                    ),
                    const SizedBox(height: 20),

                    // Email field
                    _buildTextField(
                      controller: _emailController,
                      keyType: TextInputType.emailAddress,
                      icon: Icons.email,
                      hintText: S.of(context).email,
                      errorText: emailError,
                    ),
                    const SizedBox(height: 20),

                    // Phone number field
                    _buildTextField(
                      controller: _phoneController,
                      keyType: TextInputType.number,
                      icon: Icons.phone,
                      hintText: S.of(context).phoneNumber,
                      errorText: phoneError,
                    ),
                    const SizedBox(height: 20),

                    // Wilaya Dropdown
                    buildDropdownField(
                      context: context,
                      selectedValue: _selectedWilaya,
                      items: ProductData.wilayasT(context).keys.toList(),
                      hintText: S.of(context).selectWilaya,
                      errorText: wilayaError,
                      isDarkMode: isDarkMode,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedWilaya = newValue;
                          _selectedDaira = null;
                          wilayaError = null;
                          dairaError = null;

                          // Check for null and map existence before accessing
                          if (newValue != null &&
                              _reverseTranslationMap.containsKey(newValue)) {
                            _selectedWilayaArabic =
                                _reverseTranslationMap[newValue];
                          }
                        });
                        if (newValue != null) updateDairaList(newValue);
                      },
                      onValueSaved: null,
                    ),

                    const SizedBox(height: 16),

                    // Daira Dropdown
                    buildDropdownField(
                      context: context,
                      selectedValue: _selectedDaira,
                      items: availableDairas,
                      hintText: S.of(context).selectDaira,
                      errorText: dairaError,
                      isDarkMode: isDarkMode,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDaira = newValue;
                          dairaError = null;

                          // Check for null and map existence before accessing
                          if (newValue != null &&
                              _reverseTranslationMap.containsKey(newValue)) {
                            _selectedDairaArabic =
                                _reverseTranslationMap[newValue];
                          }
                        });
                      },
                      onValueSaved: null,
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    _buildPasswordField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      hintText: S.of(context).passwordHint,
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
                      hintText: S.of(context).confirmPassword,
                      errorText: confirmPasswordError,
                      toggleObscure: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 50),

                    // Sign up button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // Reset all errors first
                              firstNameError = null;
                              lastNameError = null;
                              emailError = null;
                              phoneError = null;
                              passwordError = null;
                              confirmPasswordError = null;
                              wilayaError = null;
                              dairaError = null;

                              if (_firstNameController.text.isEmpty) {
                                firstNameError = S.of(context).firstNameError;
                              }
                              if (_lastNameController.text.isEmpty) {
                                lastNameError = S.of(context).lastNameError;
                              }
                              if (_emailController.text.isEmpty) {
                                emailError = S.of(context).emailError;
                              }
                              if (_phoneController.text.isEmpty) {
                                phoneError = S.of(context).phoneNumError;
                              }
                              if (_passwordController.text.isEmpty) {
                                passwordError = S.of(context).passwordError;
                              }
                              if (_confirmPasswordController.text.isEmpty) {
                                confirmPasswordError =
                                    S.of(context).confirmPasswordError;
                              }
                              if (_selectedWilaya == null) {
                                wilayaError = S.of(context).wilayaError;
                              }
                              if (_selectedDaira == null) {
                                dairaError = S.of(context).dairaError;
                              }

                              // Validation failed
                              if (firstNameError != null ||
                                  lastNameError != null ||
                                  emailError != null ||
                                  phoneError != null ||
                                  passwordError != null ||
                                  confirmPasswordError != null ||
                                  wilayaError != null ||
                                  dairaError != null) {
                                return;
                              }

                              if (!user.isEmailValid(_emailController.text)) {
                                emailError = S.of(context).invalidEmailError;
                              } else if (!user
                                  .isPasswordValid(_passwordController.text)) {
                                passwordError =
                                    S.of(context).password_min_length;
                              } else if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                confirmPasswordError =
                                    S.of(context).passwords_do_not_match;
                              } else if (!user
                                  .isPhoneValid(_phoneController.text)) {
                                phoneError = S.of(context).invalidPhoneError;
                              } else {
                                // Use the Arabic versions for storage in Firestore
                                // If no Arabic version is found, fallback to the selected (localized) value
                                final wilayaToStore =
                                    _selectedWilayaArabic ?? _selectedWilaya!;
                                final dairaToStore =
                                    _selectedDairaArabic ?? _selectedDaira!;
                                user.signUp(
                                  context: context,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  confirmationpassword:
                                      _confirmPasswordController.text,
                                  phone: _phoneController.text,
                                  wilaya: wilayaToStore,
                                  first_name: _firstNameController.text,
                                  last_name: _lastNameController.text,
                                  verify: false,
                                  daira: dairaToStore,
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
                          child: Text(S.of(context).signup,
                              style: GoogleFonts.roboto(
                                  fontSize: 20,
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
    required TextInputType? keyType,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color.fromARGB(255, 39, 57, 48)
                  : Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: errorText != null ? Colors.red : Colors.transparent,
                width: 1.5,
              ),
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
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF256C4C)),
                      controller: controller,
                      inputFormatters: hintText == S.of(context).phoneNumber
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
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF256C4C),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color.fromARGB(255, 39, 57, 48)
                  : Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: errorText != null ? Colors.red : Colors.transparent,
                width: 1.5,
              ),
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
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF256C4C)),
                      controller: controller,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C),
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
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildDropdownField({
    required BuildContext context,
    required String? selectedValue,
    required List<String> items,
    required String hintText,
    required String? errorText,
    required ValueChanged<String?> onChanged,
    required bool isDarkMode,
    required ValueChanged<String?>? onValueSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color.fromARGB(255, 39, 57, 48)
                  : Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: errorText != null ? Colors.red : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField2<String>(
                isExpanded: true,
                value: selectedValue,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                hint: Row(
                  children: [
                    Icon(
                      Icons.add_location_alt_sharp,
                      color: isDarkMode ? Colors.white : Color(0xFF256C4C),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      hintText,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Color(0xFF256C4C),
                      ),
                    ),
                  ],
                ),
                dropdownStyleData: DropdownStyleData(
                  useRootNavigator: true,
                  maxHeight: 200,
                  offset: const Offset(0, 0),
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color.fromARGB(255, 39, 57, 48)
                        : Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                buttonStyleData: const ButtonStyleData(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                iconStyleData: IconStyleData(
                  iconEnabledColor:
                      isDarkMode ? Colors.white : const Color(0xFF256C4C),
                  iconDisabledColor:
                      isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
                onChanged: onChanged,
                selectedItemBuilder: (context) {
                  return items.map((item) {
                    return Row(
                      children: [
                        Icon(
                          Icons.add_location_alt_sharp,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF256C4C),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item,
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C),
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF256C4C),
                      ),
                    ),
                  );
                }).toList(),
                onSaved: onValueSaved,
              ),
            ),
          ),
          if (errorText != null) const SizedBox(height: 4),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
