import 'dart:io';
import 'dart:math';
import 'package:agriplant/Front_end/Authentication/LoginPage.dart';
import 'package:agriplant/Front_end/Home/home_page.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  final String frompage;

  const EditProfilePage({super.key, required this.frompage});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _PhoneNumController = TextEditingController();

  String? firstNameError;
  String? lastNameError;
  String? phoneNumError;
  String? wilayaError;
  String? dairaError;

  // List to store Dairas based on selected Wilaya
  List<String> availableDairas = [];

  // Variables to store display (localized) and storage (Arabic) versions
  String? selectedWilaya; // Display version (localized)
  String? selectedDaira; // Display version (localized)
  String? selectedWilayaArabic; // Storage version (Arabic)
  String? selectedDairaArabic; // Storage version (Arabic)

  // Translation maps
  late Map<String, String> _translationMap; // Arabic to localized
  late Map<String, String> _reverseTranslationMap; // localized to Arabic

  String? _currentFirstName;
  String? _currentLastName;
  String? _currentPhoneNum;
  String? _currentWilaya; // This will be in Arabic from Firestore
  String? _currentDaira; // This will be in Arabic from Firestore

  @override
  void initState() {
    super.initState();

    // We'll initialize the translation maps when the widget is inserted in the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initTranslationMaps();
      _loadUserData();
    });
  }

  void _initTranslationMaps() {
    // Build the translation map from Arabic to localized
    _translationMap = ProductData.buildDairaTranslationMap(context);

    // Build reverse translation map from localized to Arabic
    _reverseTranslationMap = {};
    _translationMap.forEach((arabic, localized) {
      _reverseTranslationMap[localized] = arabic;
    });
  }

  void updateDairaList(String wilaya) {
    setState(() {
      availableDairas = ProductData.wilayasT(context)[wilaya] ?? [];

      // Store the Arabic version when selecting wilaya
      selectedWilayaArabic = _reverseTranslationMap[wilaya];
    });
  }

  Future<void> _loadUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("Users").doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        _currentFirstName = userDoc["first_name"] ?? '';
        _currentLastName = userDoc["last_name"] ?? '';
        _currentPhoneNum = userDoc["phone"] ?? '';
        _currentImage = userDoc["photo"] ?? '';

        // Get the Arabic versions from Firestore
        _currentWilaya = userDoc["wilaya"] ?? '';
        _currentDaira = userDoc["daira"] ?? '';

        // Translate Arabic to localized versions for display
        String? localizedWilaya =
            _translationMap[_currentWilaya] ?? _currentWilaya;
        String? localizedDaira =
            _translationMap[_currentDaira] ?? _currentDaira;

        _firstNameController.text = _currentFirstName!;
        _lastNameController.text = _currentLastName!;
        _PhoneNumController.text = _currentPhoneNum!;

        // Set the localized versions for display
        selectedWilaya = localizedWilaya;
        selectedDaira = localizedDaira;

        // Store the Arabic versions for database updates
        selectedWilayaArabic = _currentWilaya;
        selectedDairaArabic = _currentDaira;

        // Update available dairas based on the selected wilaya
        if (selectedWilaya != null) {
          updateDairaList(selectedWilaya!);
        }
      });
    }
  }

  File? _selectedImageFile;
  String? _currentImage;
  bool isLoading = false;
  final ImagePicker picker = ImagePicker();

  //to pick from gallery
  Future<void> pickImageGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _selectedImageFile = File(image.path); // 👈 show the image in your UI
    });
  }

  //tp pick from camera
  Future<void> pickImageCamera() async {
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
      });
      Navigator.pop(context); // Close dialog
    }
  }

//to upload
  Future<void> uploadImage(File imageFile) async {
    try {
      String imagePath = 'Profile_Pic/image_${Random().nextInt(100000)}.jpg';

      final ref = FirebaseStorage.instance.ref().child(imagePath);
      await ref.putFile(imageFile);

      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'location': imagePath,
        'photo': imageUrl,
      });
    } catch (e) {
      print("Upload error: $e");
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(S.of(context).error),
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    // Get the Arabic versions for storage
    final wilayaToStore = selectedWilayaArabic ?? selectedWilaya!;
    final dairaToStore = selectedDairaArabic ?? selectedDaira!;

    if (_firstNameController.text != _currentFirstName ||
        _lastNameController.text != _currentLastName ||
        _PhoneNumController.text != _currentPhoneNum ||
        wilayaToStore != _currentWilaya ||
        dairaToStore != _currentDaira ||
        _selectedImageFile != null) {
      // Only update if there are changes
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'phone': _PhoneNumController.text,
        'wilaya': wilayaToStore,
        'daira': dairaToStore
      });
      if (_selectedImageFile != null) {
        uploadImage(_selectedImageFile!);
      }

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'Verify': true});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 54, 126, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  S.of(context).profile_updated,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 54, 126, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  S.of(context).no_changes_detected,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> showPopUp() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => SafeArea(
        child: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(
                Icons.add_a_photo,
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
              ),
              const SizedBox(width: 8),
              Text(
                S.of(context).chooseImageSource,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  pickImageGallery();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDarkMode
                          ? const Color(0xFF90D5AE).withOpacity(0.3)
                          : const Color(0xFF256C4C).withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (isDarkMode
                                  ? const Color(0xFF90D5AE)
                                  : const Color(0xFF256C4C))
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.photo_library,
                          color: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          S.of(context).select_from_gallery,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  pickImageCamera();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDarkMode
                          ? const Color(0xFF90D5AE).withOpacity(0.3)
                          : const Color(0xFF256C4C).withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (isDarkMode
                                  ? const Color(0xFF90D5AE)
                                  : const Color(0xFF256C4C))
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          S.of(context).capture_with_camera,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
        appBar: widget.frompage == 'login'
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                ),
              )
            : AppBar(
                title: Text(S.of(context).edit_profile,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor:
                    isDarkMode ? colorScheme.surface : colorScheme.surface,
                elevation: 5,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 54, bottom: 16),
                    child: CircleAvatar(
                        radius: 93,
                        backgroundColor: isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C),
                        child: CircleAvatar(
                          radius: 90,
                          backgroundImage: _selectedImageFile != null
                              ? FileImage(_selectedImageFile!) as ImageProvider
                              : (_currentImage != null
                                  ? NetworkImage(_currentImage!)
                                  : AssetImage(isDarkMode
                                      ? "assets/anonymeD.png"
                                      : "assets/anonyme.png") as ImageProvider),
                        )),
                  ),
                ),
                Positioned(
                  top: 54,
                  right: 100,
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    child: IconButton(
                      icon: Icon(Icons.edit,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF256C4C)),
                      onPressed: () {
                        showPopUp();
                      },
                    ),
                  ),
                )
              ]),

              const SizedBox(height: 40),

              // First name field
              _buildTextField(
                controller: _firstNameController,
                icon: Icons.person,
                hintText: S.of(context).firstName,
                errorText: firstNameError,
              ),

              const SizedBox(height: 13),

              // Last name field
              _buildTextField(
                controller: _lastNameController,
                icon: Icons.person,
                hintText: S.of(context).lastName,
                errorText: lastNameError,
              ),

              const SizedBox(height: 13),

              // Phone num field
              _buildTextField(
                controller: _PhoneNumController,
                icon: Icons.phone,
                hintText: S.of(context).phoneNumber,
                errorText: phoneNumError,
              ),

              const SizedBox(height: 13),
              // Wilaya Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: wilayaError != null
                              ? Colors.red
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: ProductData.wilayasT(context)
                                  .keys
                                  .contains(selectedWilaya)
                              ? selectedWilaya
                              : null,
                          hint: Row(
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
                                S.of(context).selectWilaya,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF256C4C),
                                ),
                              ),
                            ],
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 140,
                            offset: const Offset(0, 0),
                            width: MediaQuery.of(context).size.width - 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
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
                            if (newValue != null &&
                                ProductData.wilayasT(context)
                                    .containsKey(newValue)) {
                              setState(() {
                                selectedWilaya = newValue;
                                selectedDaira = null;
                                selectedDairaArabic = null;
                                wilayaError = null;
                                dairaError = null;

                                // Store the Arabic version when selecting wilaya
                                selectedWilayaArabic =
                                    _reverseTranslationMap[newValue];

                                updateDairaList(newValue);
                              });
                            }
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return ProductData.wilayasT(context)
                                .keys
                                .map((wilaya) {
                              return Row(
                                children: [
                                  Icon(
                                    Icons.add_location_alt_sharp,
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF256C4C),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    wilaya,
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
                          items: ProductData.wilayasT(context)
                              .keys
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
                    if (wilayaError != null) const SizedBox(height: 4),
                    if (wilayaError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          wilayaError!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 13),

              // Daira Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: dairaError != null
                              ? Colors.red
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: availableDairas.contains(selectedDaira)
                              ? selectedDaira
                              : null,
                          hint: Row(
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
                                S.of(context).selectDaira,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF256C4C),
                                ),
                              ),
                            ],
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 140,
                            offset: const Offset(0, 0),
                            width: MediaQuery.of(context).size.width - 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
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
                            if (newValue != null &&
                                availableDairas.contains(newValue)) {
                              setState(() {
                                selectedDaira = newValue;
                                dairaError = null;

                                // Store the Arabic version when selecting daira
                                selectedDairaArabic =
                                    _reverseTranslationMap[newValue];
                              });
                            }
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return availableDairas.map((daira) {
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
                                    daira,
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
                    if (dairaError != null) const SizedBox(height: 4),
                    if (dairaError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          dairaError!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // Submit button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_firstNameController.text.isEmpty ||
                            _lastNameController.text.isEmpty ||
                            _PhoneNumController.text.isEmpty ||
                            _PhoneNumController.text.length != 10 ||
                            selectedWilaya == '' ||
                            selectedDaira == '') {
                          if (_firstNameController.text.isEmpty) {
                            firstNameError = S.of(context).firstNameError;
                          }
                          if (_lastNameController.text.isEmpty) {
                            lastNameError = S.of(context).lastNameError;
                          }
                          if (_PhoneNumController.text.isEmpty) {
                            phoneNumError = S.of(context).phoneNumError;
                          }
                          if (_PhoneNumController.text.length != 10) {
                            phoneNumError = S.of(context).phoneNumLengthError;
                          }
                          if (selectedDaira == '') {
                            dairaError = S.of(context).dairaError;
                          }
                          if (selectedWilaya == '') {
                            wilayaError = S.of(context).wilayaError;
                          }
                          //rani dyr validation f onchanged f drop down
                        } else {
                          _updateProfile();
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
                    child: Text(S.of(context).submit,
                        style: GoogleFonts.roboto(
                            fontSize: 18,
                            color: isDarkMode ? Colors.black : Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ));
  }

  // Helper method for TextField with validation
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required String? errorText,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
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
                    color: isDarkMode
                        ? Colors.white
                        : const Color.fromARGB(255, 42, 103, 34),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      inputFormatters: hintText == S.of(context).phoneNumber
                          ? [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ]
                          : null,
                      keyboardType: hintText == S.of(context).phoneNumber
                          ? TextInputType.number
                          : TextInputType.name,
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.white
                            : const Color.fromARGB(255, 42, 103, 34),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : const Color.fromARGB(255, 42, 103, 34),
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
}
