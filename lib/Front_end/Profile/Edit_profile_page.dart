import 'dart:io';
import 'dart:math';
import 'package:agriplant/Front_end/Home/home_page.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            ? Text('Edit Profile')
            : Text('Continuing sign in ...'),
        backgroundColor: isDarkMode ? colorScheme.surface : colorScheme.surface,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
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
                        child:
                            _selectedImageFile == null && _currentImage == null
                                ? const Icon(Icons.camera_alt,
                                    size: 30, color: Colors.black54)
                                : null)),
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
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF256C4C)),
                  onPressed: () {
                    showPopUp();
                  },
                ),
              ),
            )
          ]),

          const SizedBox(height: 50),

          // First name field
          _buildTextField(
            controller: _firstNameController,
            icon: Icons.person,
            hintText: "First Name",
            errorText: firstNameError,
          ),

          const SizedBox(height: 20),

          // Last name field
          _buildTextField(
            controller: _lastNameController,
            icon: Icons.person,
            hintText: "Last Name",
            errorText: lastNameError,
          ),

          const SizedBox(height: 20),

          // Phone num field
          _buildTextField(
            controller: _PhoneNumController,
            icon: Icons.phone,
            hintText: "Phone Number",
            errorText: phoneNumError,
          ),

          const SizedBox(height: 20),

          //wilaya selection
          buildDropdown(
            selectedValue: selectedWilaya,
            items: ProductData.wilayas.keys.toList(),
            label: 'Wilaya',
            errorText: wilayaError,
            onChanged: (value) {
              setState(() {
                selectedWilaya = value;
                selectedDaira = '';
              });
            },
          ),
          const SizedBox(height: 20),

          //Daira selection
          buildDropdown(
              selectedValue: selectedDaira,
              items: ProductData.wilayas[selectedWilaya] ?? [],
              label: 'Daira',
              errorText: dairaError,
              onChanged: (value) {
                setState(() {
                  selectedDaira = value;
                });
              }),

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
    );
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
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color.fromARGB(255, 55, 72, 56)
              : Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: errorText != null
                ? Colors.red
                : Colors.transparent, // 👈 Red border if error
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(icon,
                  color: isDarkMode
                      ? Colors.white
                      : const Color.fromARGB(255, 42, 103, 34)),
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: isDarkMode
                          ? Colors.white
                          : const Color.fromARGB(255, 42, 103, 34),
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

  static Widget buildDropdown({
    required String? selectedValue,
    required List<String> items,
    required String label,
    required String? errorText,
    required void Function(String?) onChanged, // 👈 Add IconData parameter
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: errorText != null
                ? Colors.red
                : Colors.transparent, // 👈 Red border if error
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(
                Icons.add_location_alt_sharp,
                color: const Color(0xFF256C4C),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: items.contains(selectedValue) ? selectedValue : null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: label,
                    errorText: errorText,
                  ),
                  items: items
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
