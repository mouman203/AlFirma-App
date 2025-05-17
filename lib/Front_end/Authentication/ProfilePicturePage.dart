import 'dart:io';
import 'dart:math';
import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Home/home_page.dart';
import 'package:agriplant/generated/l10n.dart';
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

class _ProfilePicturePageState extends State<ProfilePicturePage>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool isLoading = false;
  bool isImageSelected = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Pick Image from Gallery or Camera
  Future<void> _pickImage() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(S.of(context).choose_picture,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library,
                  color: isDarkMode
                      ? const Color(0xFF90D5AE)
                      : const Color(0xFF256C4C)),
              title: Text(S.of(context).select_from_gallery),
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
              title: Text(S.of(context).capture_with_camera),
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

      // Show success animation
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
            S.of(context).profile_picture_updated_successfully,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 1),
  ),
);
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(S.of(context).error),
          content: Text(e.toString()),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> onProceed() async {
    bool isVerified = await Users.checkEmailVerification(context);

    if (!isVerified) {
      // If the email is not verified, navigate to the Login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    Color.fromARGB(255, 16, 24, 20),
                    colorScheme.secondaryContainer
                  ]
                : [colorScheme.secondaryContainer, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Skip Button
              if (!isImageSelected)
                Positioned(
                  top: 20,
                  right: 20,
                  child: TextButton(
                    onPressed: () => onProceed(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      S.of(context).skip,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C),
                      ),
                    ),
                  ),
                ),

              // Title
              Positioned(
                top: size.height * 0.12,
                left: 0,
                right: 0,
                child: Text(
                  S.of(context).profile_picture,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),

              // Subtitle
              Positioned(
                top: size.height * 0.17,
                left: 40,
                right: 40,
                child: Text(
                  S.of(context).add_profile_picture_subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),

              // Profile Picture and Done Button
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Profile Picture
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Profile Picture
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDarkMode
                                    ? const Color(0xFF90D5AE)
                                    : const Color(0xFF256C4C),
                                width: 3,
                              ),
                              boxShadow: [
                                if (!isImageSelected)
                                  BoxShadow(
                                    color: isDarkMode
                                        ? Colors.black.withOpacity(0.4)
                                        : Colors.white.withOpacity(0.4),
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: _selectedImage != null
                                  ? Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      isDarkMode
                                          ? "assets/anonymeD.png"
                                          : "assets/anonyme.png",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),

                          // Camera Icon Overlay (only shown when no image is selected)
                          if (!isImageSelected)
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.5),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: isDarkMode
                                    ? Colors.black.withOpacity(0.8)
                                    : Colors.white.withOpacity(0.8),
                              ),
                            ),

                          // Edit Icon (only shown when image is selected)
                          if (isImageSelected)
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? const Color(0xFF90D5AE)
                                      : const Color(0xFF256C4C),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color:
                                      isDarkMode ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Done Button
                    if (isImageSelected && !isLoading)
                      ScaleTransition(
                        scale: _animation,
                        child: ElevatedButton(
                          onPressed: () async {
                            await uploadImageAndSave();
                            await onProceed();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode
                                ? const Color(0xFF90D5AE)
                                : const Color(0xFF256C4C),
                            foregroundColor:
                                isDarkMode ? Colors.black : Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            S.of(context).done,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Loading Indicator
                    if (isLoading) const CircularProgressIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
