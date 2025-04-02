import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

File? _imageFile;

 Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
          backgroundColor:
              isDarkMode ? colorScheme.surface : colorScheme.surface,
          ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[500],
                backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? const Icon(Icons.camera_alt, size: 30, color: Colors.black54)
                    : null,
              ),
            ),
              const SizedBox(height: 70),

              // firstName field
              _buildTextField(
                icon: Icons.person,
                hintText: "First Name",
              ),

              const SizedBox(height: 20),

              // lastName field
              _buildTextField(
               icon: Icons.person,
                hintText: "Last Name",
              ),

              const SizedBox(height: 20),

              // Email field
              _buildTextField(
                icon: Icons.email,
                hintText: "Email",
              ),

              const SizedBox(height: 20),

              // Phone number field
              _buildTextField(
                icon: Icons.phone,
                hintText: "Phone Number ",
              ),

              const SizedBox(height: 20),

              // Password field
              _buildPasswordField(
                hintText: "Password",
              ),
      
              const SizedBox(height: 70),

              // زر التسجيل
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                     
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? const Color.fromARGB(
                              255, 55, 72, 56) // Dark green in dark mode
                          : const Color.fromARGB(255, 44, 107, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text("Submit",
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
              ? const Color.fromARGB(255, 55, 72, 56) // Dark green in dark mode
              : Colors.green.shade50, // Light green in light mode
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

  Widget _buildPasswordField({
   
    required String hintText,
 
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color.fromARGB(255, 55, 72, 56) // Dark green in dark mode
              : Colors.green.shade50, // Light green in light mode,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(Icons.lock,
                  color: isDarkMode
                      ? Colors.white
                      : const Color.fromARGB(255, 42, 103, 34)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
          
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
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

