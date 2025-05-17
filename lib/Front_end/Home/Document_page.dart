import 'dart:io';
import 'package:agriplant/Front_end/Home/user_type_handler.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentPage extends StatelessWidget {
  final String userType; // Arabic string e.g., "ناقل"

  const DocumentPage({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DocumentForm(userType: userType);
  }
}

class DocumentForm extends StatefulWidget {
  final String userType; // Arabic string

  const DocumentForm({Key? key, required this.userType}) : super(key: key);

  @override
  State<DocumentForm> createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  final ImagePicker _picker = ImagePicker();
  final Map<String, XFile?> _pickedImages = {};

  // Arabic user types and their document requirements (stored in Arabic)
  final Map<String, List<String>> requiredDocuments = {
    'ناقل': [
      "بطاقة التعريف الوطنية (الوجه)",
      "بطاقة التعريف الوطنية (الظهر)",
      'شهادة',
      'رخصة السياقة'
    ],
    'بيطري': [
      "بطاقة التعريف الوطنية (الوجه)",
      "بطاقة التعريف الوطنية (الظهر)",
      'شهادة بيطرية'
    ],
    'خبير زراعي': [
      "بطاقة التعريف الوطنية (الوجه)",
      "بطاقة التعريف الوطنية (الظهر)",
      'شهادة'
    ],
    'مصلح': [
      "بطاقة التعريف الوطنية (الوجه)",
      "بطاقة التعريف الوطنية (الظهر)",
      'شهادة'
    ],
    'شركة': ['سجل تجاري'],
    'تاجر': ['سجل تجاري'],
  };

  // Translate Arabic document labels to localized strings
  String getLocalizedDocumentLabel(BuildContext context, String arabicLabel) {
    switch (arabicLabel) {
      case "بطاقة التعريف الوطنية (الوجه)":
        return S.of(context).identityFront;
      case "بطاقة التعريف الوطنية (الظهر)":
        return S.of(context).identityBack;
      case 'شهادة':
        return S.of(context).certificate;
      case 'رخصة السياقة':
        return S.of(context).drivingLicense;
      case 'شهادة بيطرية':
        return S.of(context).veterinaryCertificate;
      case 'سجل تجاري':
        return S.of(context).commercialRegister;
      default:
        return arabicLabel; // fallback to Arabic if unknown
    }
  }

  // Translate Arabic user type to localized string
  String getLocalizedUserType(BuildContext context, String arabicUserType) {
    switch (arabicUserType) {
      case 'ناقل':
        return S.of(context).transporteur;
      case 'بيطري':
        return S.of(context).veterinaire;
      case 'خبير زراعي':
        return S.of(context).expertAgri;
      case 'مصلح':
        return S.of(context).reparateur;
      case 'شركة':
        return S.of(context).entreprise;
      case 'تاجر':
        return S.of(context).commercant;
      default:
        return arabicUserType; // fallback to Arabic if unknown
    }
  }

  void updateUserType(String activeType) {
    setActiveType(activeType); // Calling the function
  }

  Future<void> _pickImage(String arabicLabel) async {
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
                  setState(() => _pickedImages[arabicLabel] = picked);
                }
                Navigator.pop(context);
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
                  setState(() => _pickedImages[arabicLabel] = picked);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageBox(String arabicLabel) {
    final image = _pickedImages[arabicLabel];
    final localizedLabel = getLocalizedDocumentLabel(context, arabicLabel);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _pickImage(arabicLabel),
      child: Container(
        height: 180,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C)),
          borderRadius: BorderRadius.circular(12),
          color: colorScheme.surface,
        ),
        child: image == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo,
                        size: 40,
                        color: isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C)),
                    const SizedBox(height: 10),
                    Text(localizedLabel,
                        style: TextStyle(
                            color: isDarkMode
                                ? const Color(0xFF90D5AE)
                                : const Color(0xFF256C4C))),
                  ],
                ),
              )
            : Image.file(File(image.path), fit: BoxFit.cover),
      ),
    );
  }

  bool isLoading = false;

  Future<void> _submitDocuments() async {
    setState(() => isLoading = true);

    String selectedUserTypeArabic = widget.userType;
    List<String> userDocs = requiredDocuments[selectedUserTypeArabic] ?? [];

    try {
      for (String docArabic in userDocs) {
        final pickedImage = _pickedImages[docArabic];
        if (pickedImage == null) {
          throw Exception(
              '${getLocalizedDocumentLabel(context, docArabic)} ${S.of(context).document_not_attached}');
        }

        String fileName =
            "${selectedUserTypeArabic}_${docArabic}_${DateTime.now().millisecondsSinceEpoch}";
        final storageRef =
            FirebaseStorage.instance.ref().child('documents/$fileName');
        await storageRef.putFile(File(pickedImage.path));
        String downloadUrl = await storageRef.getDownloadURL();

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final docRef =
              FirebaseFirestore.instance.collection('Users').doc(user.uid);
          final snapshot = await docRef.get();

          Map<String, dynamic> currentTypes =
              Map<String, dynamic>.from(snapshot.data()?['userType'] ?? {});
          if (!currentTypes.containsKey(selectedUserTypeArabic)) {
            currentTypes[selectedUserTypeArabic] = {
              'validation': 'pending',
              selectedUserTypeArabic: {
                'documents': {
                  docArabic: {
                    'documentUrl': downloadUrl,
                    'uploadedAt': FieldValue.serverTimestamp(),
                  }
                }
              },
              'createdAt': FieldValue.serverTimestamp(),
            };

            await docRef.update({
              'userType': currentTypes,
              'userTypeUpdatedAt': FieldValue.serverTimestamp(),
            });
          }
        }
      }

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
                  S.of(context).documents_sent_successfully,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.of(context).pop();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              const Color.fromARGB(255, 247, 234, 117), // Yellow background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.black),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${S.of(context).error}: $e",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final documents = requiredDocuments[widget.userType] ?? [];
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // Get localized user type for display
    final localizedUserType = getLocalizedUserType(context, widget.userType);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '${S.of(context).document_title} $localizedUserType',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).appBarTheme.titleTextStyle ??
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isDarkMode ? colorScheme.surface : colorScheme.surface,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (var doc in documents) buildImageBox(doc),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submitDocuments,
                      icon: Icon(Icons.upload,
                          color: isDarkMode ? Colors.black : Colors.white),
                      label: Text(
                        S.of(context).submitDocuments,
                        style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontSize: 18),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
