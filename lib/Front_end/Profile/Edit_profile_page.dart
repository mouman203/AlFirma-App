import 'dart:io';
import 'dart:math';
import 'package:agriplant/Front_end/Home/home_page.dart';
import 'package:agriplant/data/ProductData.dart';
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
  void updateDairaList(String wilaya) {
    setState(() {
      availableDairas = ProductData.wilayas[wilaya] ?? [];
    });
  }

  String? selectedWilaya;
  String? selectedDaira;

  String? _currentFirstName;
  String? _currentLastName;
  String? _currentPhoneNum;
  String? _currentWilaya;
  String? _currentDaira;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("Users").doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        _currentFirstName = userDoc["first_name"] ?? '';
        _currentLastName = userDoc["last_name"] ?? '';
        _currentWilaya = userDoc["wilaya"] ?? '';
        _currentDaira = userDoc["daira"] ?? '';
        _currentPhoneNum = userDoc["phone"] ?? '';
        _currentImage = userDoc["photo"] ?? '';

        _firstNameController.text = _currentFirstName!;
        _lastNameController.text = _currentLastName!;
        _PhoneNumController.text = _currentPhoneNum!;
        selectedWilaya = _currentWilaya;
        selectedDaira = _currentDaira;
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
          title: const Text("Error"),
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (_firstNameController.text != _currentFirstName ||
        _lastNameController.text != _currentLastName ||
        _PhoneNumController.text != _currentPhoneNum ||
        selectedWilaya != _currentWilaya ||
        selectedDaira != _currentDaira ||
        _selectedImageFile != null) {
      // Only update if there are changes
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'phone': _PhoneNumController.text,
        'wilaya': selectedWilaya,
        'daira': selectedDaira
      });
      if (_selectedImageFile != null) {
        uploadImage(_selectedImageFile!);
      }

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId) // Using UID to access the document directly
          .update({'Verify': true});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes detected')),
      );
    }
  }

  Future<void> showPopUp() async {
    showDialog(
      context: context,
      builder: (_) => SafeArea(
        child: AlertDialog(
          title: const Text('اختيار صورة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('اختيار من المعرض'),
                onTap: () async {
                  pickImageGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('التقاط صورة بالكاميرا'),
                onTap: () async {
                  pickImageCamera();
                },
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
        appBar: AppBar(
          title: widget.frompage == 'profile'
              ? const Text('Edit Profile')
              : const Text('Continuing sign in ...'),
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
                hintText: "First Name",
                errorText: firstNameError,
              ),

              const SizedBox(height: 13),

              // Last name field
              _buildTextField(
                controller: _lastNameController,
                icon: Icons.person,
                hintText: "Last Name",
                errorText: lastNameError,
              ),

              const SizedBox(height: 13),

              // Phone num field
              _buildTextField(
                controller: _PhoneNumController,
                icon: Icons.phone,
                hintText: "Phone Number",
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
                        color: isDarkMode
                            ? const Color.fromARGB(255, 39, 57, 48)
                            : Theme.of(context).colorScheme.secondaryContainer,
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
                          value: selectedWilaya,
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
                                "Select Wilaya",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF256C4C),
                                ),
                              ),
                            ],
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 180,
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
                              selectedWilaya = newValue;
                              selectedDaira = null;
                              wilayaError = null;
                              dairaError = null;
                            });
                            if (newValue != null) {
                              updateDairaList(newValue);
                            }
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return ProductData.wilayas.keys.map((wilaya) {
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
                        color: isDarkMode
                            ? const Color.fromARGB(255, 39, 57, 48)
                            : Theme.of(context).colorScheme.secondaryContainer,
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
                          value: selectedDaira,
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
                                "Select Daira",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF256C4C),
                                ),
                              ),
                            ],
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 180,
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
                              selectedDaira = newValue;
                              dairaError = null;
                            });
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
                            firstNameError = "يرجى إدخال الاسم";
                          }
                          if (_lastNameController.text.isEmpty) {
                            lastNameError = "يرجى إدخال اللقب";
                          }
                          if (_PhoneNumController.text.isEmpty) {
                            phoneNumError = "يرجى إدخال رقم الهاتف";
                          }
                          if (_PhoneNumController.text.length != 10) {
                            phoneNumError = "يرجى ادخال 10 ارقام";
                          }
                          if (selectedDaira == '') {
                            dairaError = "يرجى ادخال الدائرة";
                          }
                          if (selectedWilaya == '') {
                            wilayaError = "يرجى ادخال الولاية";
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
                    child: Text("Submit",
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
                      inputFormatters: hintText == "Phone Number"
                          ? [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ]
                          : null,
                      keyboardType: hintText == "Phone Number"
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
