import 'dart:io';
import 'package:agriplant/Front_end/Home/user_type_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentPage extends StatelessWidget {
  final String userType;

  const DocumentPage({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DocumentForm(userType: userType);
  }
}

class DocumentForm extends StatefulWidget {
  final String userType;

  const DocumentForm({Key? key, required this.userType}) : super(key: key);

  @override
  State<DocumentForm> createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  final ImagePicker _picker = ImagePicker();

  // Store picked images in a Map
  final Map<String, XFile?> _pickedImages = {};

  // Define required document labels for each user type
  final Map<String, List<String>> requiredDocuments = {
    'Transporteur': [
      'بطاقة الهوية (الوجه)',
      'بطاقة الهوية (الظهر)',
      'شهادة',
      'رخصة السياقة'
    ],
    'Vétérinaire': [
      'بطاقة الهوية (الوجه)',
      'بطاقة الهوية (الظهر)',
      'شهادة بيطرية'
    ],
    'Expert Agri': ['بطاقة الهوية (الوجه)', 'بطاقة الهوية (الظهر)', 'شهادة'],
    'Réparateur': ['بطاقة الهوية (الوجه)', 'بطاقة الهوية (الظهر)', 'شهادة'],
    'Entreprise': ['شهادة'],
  };

  void updateUserType(String activeType) {
    setActiveType(activeType); // Calling the function
  }

  Future<void> _pickImage(String label) async {
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
                  final picked =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      _pickedImages[label] = picked;
                    });
                    Navigator.pop(context); // Close dialog
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('التقاط صورة بالكاميرا'),
                onTap: () async {
                  final picked =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    setState(() {
                      _pickedImages[label] = picked;
                    });
                    Navigator.pop(context); // Close dialog
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageBox(String label) {
    final image = _pickedImages[label];
    return GestureDetector(
      onTap: () => _pickImage(label),
      child: Container(
        height: 180,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(12),
          color: Colors.green.shade50,
        ),
        child: image == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.photo, size: 40, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(label, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            : Image.file(File(image.path), fit: BoxFit.cover),
      ),
    );
  }

  Future<void> _submitDocuments() async {
    setState(() => isLoading = true);

    // Fetch the userType you selected (could be passed from UI)
    String selectedUserType = widget.userType;

    // Assume widget.userType is the selected userType
    List<String> userDocs = requiredDocuments[selectedUserType] ?? [];
    try {
      // Loop through the documents and upload them
      for (String doc in userDocs) {
        final pickedImage = _pickedImages[doc];
        if (pickedImage == null) {
          throw Exception("الوثيقة '$doc' غير مرفقة");
        }

        // Generate a unique file name for the document
        String fileName =
            "${selectedUserType}_${doc}_${DateTime.now().millisecondsSinceEpoch}";
        final storageRef =
            FirebaseStorage.instance.ref().child('documents/$fileName');

        // Upload the file to Firebase Storage
        await storageRef.putFile(File(pickedImage.path));

        // Get the download URL of the uploaded file
        String downloadUrl = await storageRef.getDownloadURL();

        try {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final docRef =
                FirebaseFirestore.instance.collection('Users').doc(user.uid);
            final snapshot = await docRef.get();

            Map<String, dynamic> currentTypes =
                Map<String, dynamic>.from(snapshot.data()?['userType'] ?? {});

            if (!currentTypes.containsKey(selectedUserType)) {
              currentTypes[selectedUserType] = {
                'validation': 'pending',
                selectedUserType: {
                  'documents': {
                    doc: {
                      'documentUrl': downloadUrl,
                      'uploadedAt': FieldValue.serverTimestamp(),
                    }
                  }
                },
                'createdAt': FieldValue.serverTimestamp(),
                // تضيف حقول حسب الحاجة
              };

              await docRef.update({
                'userType': currentTypes,
                'userTypeUpdatedAt': FieldValue.serverTimestamp(),
              });

              print(
                  "✅ User type '$selectedUserType' added successfully as a map.");
              /*if (selectedUserType == 'Agriculteur' ||
                  selectedUserType == 'Éleveur') {
                setActiveType(selectedUserType);
              }*/
            }
          } else {
            print("⚠️ No user is logged in.");
          }
        } catch (e) {
          print("❌ Error updating user type: $e");
        }
        SetOptions(merge: true); // لتفادي مسح البيانات السابقة
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم إرسال الوثائق بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ خطأ: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final documents = requiredDocuments[widget.userType] ?? [];
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
          title: Text('توثيق ${widget.userType}'),
          backgroundColor:
              isDarkMode ? colorScheme.surface : colorScheme.surface),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (var doc in documents) buildImageBox(doc),
            const SizedBox(height: 20),
            Container(
              width: double.infinity, // Make the button full width
              height: 50, // Match the height of text fields
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator()) // Show progress
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        try {
                          _submitDocuments();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      },
                      icon: const Icon(Icons.upload, color: Colors.white),
                      label: const Text(
                        "إرسال الوثائق",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
