import 'dart:io';
import 'dart:math';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'LoginPage.dart';

class ProfilePicturePage extends StatefulWidget {
  final String userId;

  const ProfilePicturePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePicturePageState createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool isLoading = false;
  bool isImageSelected = false;

  // Pick Image from Gallery or Camera
  Future<void> _pickImage() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('📸 Choose a Picture',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library,
                  color: isDarkMode
                      ? const Color(0xFF90D5AE)
                      : const Color(0xFF256C4C)),
              title: const Text('Select from Gallery'),
              onTap: () async {
                final picked =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() {
                    _selectedImage = File(picked.path);
                    isImageSelected = true;
                  });
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt,
                  color: isDarkMode
                      ? const Color(0xFF90D5AE)
                      : const Color(0xFF256C4C)),
              title: const Text('Capture with Camera'),
              onTap: () async {
                final picked =
                    await _picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  setState(() {
                    _selectedImage = File(picked.path);
                    isImageSelected = true;
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Upload the selected image to Firebase Storage and save the URL in Firestore
  Future<void> uploadImageAndSave() async {
    if (_selectedImage == null) return;
    setState(() => isLoading = true);

    try {
      String imagePath = 'Profile_Pic/image_${Random().nextInt(100000)}.jpg';
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      await ref.putFile(_selectedImage!);
      final imageUrl = await ref.getDownloadURL();

      // Save the image URL and path in Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .update({
        'location': imagePath,
        'photo': imageUrl,
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> onProceed() async {
    // Ensure that the user uploads the picture before proceeding (if applicable)
    // Example: await uploadProfilePicture();

    // Call the checkEmailVerification method and await the result
    bool isVerified = await Users.checkEmailVerification(context);

    if (!isVerified) {
      // If the email is not verified, navigate to the Login page
     Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginPage(frompage: 'ProfilPicture')),
            );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // "Skip" Button if no image is selected
            if (!isImageSelected)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 120, right: 35),
                  child: TextButton(
                    onPressed: () => onProceed(),
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 26,
                        color: isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C),
                      ),
                    ),
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Outer CircleAvatar for the border
                  CircleAvatar(
                    radius: 123, // Outer circle (border size)
                    backgroundColor: isDarkMode
                        ? const Color(0xFF90D5AE) // Border color for dark mode
                        : const Color(
                            0xFF256C4C), // Border color for light mode
                    child: CircleAvatar(
                      radius: 120, // Inner circle (profile picture size)
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : AssetImage(isDarkMode
                              ? "assets/anonymeD.png"
                              : "assets/anonyme.png") as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (isImageSelected)
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(
                        Icons.edit,
                        color: isDarkMode ? Colors.black : Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        "Change Picture",
                        style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                    ),
                  const SizedBox(height: 30),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode
                                ? const Color(0xFF90D5AE)
                                : const Color(0xFF256C4C),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                          onPressed: () async {
                            if (!isImageSelected) {
                              await _pickImage();
                            } else {
                              await uploadImageAndSave();
                              await onProceed();
                            }
                          },
                          icon: Icon(
                            isImageSelected ? Icons.check : Icons.photo_camera,
                            color: isDarkMode ? Colors.black : Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            isImageSelected ? "Done" : "Add picture",
                            style: TextStyle(
                                fontSize: 20,
                                color:
                                    isDarkMode ? Colors.black : Colors.white),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
