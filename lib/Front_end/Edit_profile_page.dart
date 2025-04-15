import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String? firstNameError;
  String? lastNameError;

  String? _currentFirstName;
  String? _currentLastName;

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
        _currentImage = userDoc["photo"];

        _firstNameController.text = _currentFirstName!;
        _lastNameController.text = _currentLastName!;
      });
    }
  }

  File? _selectedImageFile;
  String? _currentImage;
  bool isLoading = false;

  //to pick
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _selectedImageFile = File(image.path); // 👈 show the image in your UI
    });
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

/*
  Future<void> pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() => isLoading = true);
      setState(() {
        _selectedImageFile = File(image.path); // 👈 show image
        isLoading = true;
      });

      File imageFile = File(image.path);
      String imagePath = 'Profile_Pic/image_${Random().nextInt(100000)}.jpg';

      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      await ref.putFile(imageFile);

      // Get download URL
      final imageUrl = await ref.getDownloadURL();

      // Save URL & location to Firestore
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'location': imagePath,
        'photo': imageUrl,
      });

      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload complete!")),
      );*/
    } catch (e) {
      print("Upload error: $e");
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
*/
  // Validation method
  bool validateFields() {
    setState(() {
      firstNameError = _firstNameController.text.isEmpty
          ? 'First Name cannot be empty'
          : null;
      lastNameError =
          _lastNameController.text.isEmpty ? 'Last Name cannot be empty' : null;
    });
    return firstNameError == null && lastNameError == null;
  }

  Future<void> _updateProfile() async {
    if (_firstNameController.text != _currentFirstName ||
        _lastNameController.text != _currentLastName ||
        _selectedImageFile != null) {
      // Only update if there are changes
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
      });

      uploadImage(_selectedImageFile!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes detected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: isDarkMode ? colorScheme.surface : colorScheme.surface,
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => pickImage(),
            child: Padding(
              padding: const EdgeInsets.only(top: 54, bottom: 16),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : CircleAvatar(
                      radius: 90,
                      backgroundColor: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                      backgroundImage: _selectedImageFile != null
                          ? FileImage(_selectedImageFile!) as ImageProvider
                          : (_currentImage != null
                              ? NetworkImage(_currentImage!)
                              : null),
                      child: _selectedImageFile == null
                          ? const Icon(Icons.camera_alt,
                              size: 30, color: Colors.black54)
                          : null,
                    ),
            ),
          ),
          const SizedBox(height: 70),

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

          const SizedBox(height: 70),

          // Submit button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (validateFields()) {
                    _updateProfile();
                  }
                  ;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? const Color(0xFF90D5AE)
                      :const Color(0xFF256C4C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text("Submit",
                    style:
                        GoogleFonts.roboto(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for TextField with validation
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
              ? const Color.fromARGB(255, 55, 72, 56)
              : Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
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
}
