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

  const DocumentPage({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return DocumentForm(userType: userType);
  }
}

class DocumentForm extends StatefulWidget {
  final String userType; // Arabic string

  const DocumentForm({super.key, required this.userType});

  @override
  State<DocumentForm> createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  final ImagePicker _picker = ImagePicker();
  final Map<String, XFile?> _pickedImages = {};
  
  // Store existing documents from other user types
  Map<String, Map<String, dynamic>> _existingDocuments = {};
  bool _isLoadingExistingDocs = true;

  // Arabic user types and their document requirements (stored in Arabic)
  final Map<String, List<String>> requiredDocuments = {
    'ناقل': [
      "بطاقة التعريف الوطنية (الوجه)",
      "بطاقة التعريف الوطنية (الظهر)",
      '(الوجه) رخصة السياقة',
      '(الظهر) رخصة السياقة',
       'البطاقة الرمادية',
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
      'شهادة خاصة بالمصلح'
    ],
    'شركة': ['سجل تجاري خاص بالشركة'],
    'تاجر': ['سجل تجاري الخاص بالتاجر'],
    'عامل': [
      "بطاقة التعريف الوطنية (الوجه)",
      "بطاقة التعريف الوطنية (الظهر)",
    ]
  };

  @override
  void initState() {
    super.initState();
    _loadExistingDocuments();
  }

  // Load existing documents from all user types
  Future<void> _loadExistingDocuments() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final docRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
      final snapshot = await docRef.get();
      
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        final userTypes = userData['userType'] as Map<String, dynamic>? ?? {};
        
        // Collect all documents from all user types
        Map<String, Map<String, dynamic>> allDocs = {};
        
        userTypes.forEach((userType, typeData) {
          if (typeData is Map<String, dynamic> && typeData.containsKey('documents')) {
            final documents = typeData['documents'] as Map<String, dynamic>;
            documents.forEach((docName, docData) {
              // Only add if we don't already have this document type
              if (!allDocs.containsKey(docName)) {
                allDocs[docName] = Map<String, dynamic>.from(docData);
              }
            });
          }
        });
        
        setState(() {
          _existingDocuments = allDocs;
          _isLoadingExistingDocs = false;
        });
      } else {
        setState(() {
          _isLoadingExistingDocs = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingExistingDocs = false;
      });
      print("Error loading existing documents: $e");
    }
  }

  // Check if document already exists
  bool _hasExistingDocument(String arabicLabel) {
    return _existingDocuments.containsKey(arabicLabel);
  }

  // Get existing document URL
  String? _getExistingDocumentUrl(String arabicLabel) {
    return _existingDocuments[arabicLabel]?['documentUrl'] as String?;
  }

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
      case 'عامل':
        return S.of(context).worker;
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 19),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                final picked =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() => _pickedImages[arabicLabel] = picked);
                }
                Navigator.pop(context);
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
              onTap: () async {
                final picked =
                    await _picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  setState(() => _pickedImages[arabicLabel] = picked);
                }
                Navigator.pop(context);
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
    );
  }

  Widget buildImageBox(String arabicLabel) {
    final image = _pickedImages[arabicLabel];
    final localizedLabel = getLocalizedDocumentLabel(context, arabicLabel);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final hasExisting = _hasExistingDocument(arabicLabel);
    final existingUrl = _getExistingDocumentUrl(arabicLabel);

    return GestureDetector(
      onTap: () => _pickImage(arabicLabel),
      child: Container(
        height: 180,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: hasExisting 
                  ? Colors.green 
                  : (isDarkMode
                      ? const Color(0xFF90D5AE)
                      : const Color(0xFF256C4C))),
          borderRadius: BorderRadius.circular(12),
          color: colorScheme.surface,
        ),
        child: Stack(
          children: [
            // Main content
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(File(image.path), 
                    fit: BoxFit.cover, 
                    width: double.infinity, 
                    height: double.infinity),
              )
            else if (hasExisting && existingUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.network(existingUrl, 
                    fit: BoxFit.cover, 
                    width: double.infinity, 
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, 
                                size: 40, 
                                color: Colors.red),
                            const SizedBox(height: 10),
                            Text('Error loading image',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      );
                    }),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description,
                        size: 40,
                        color: isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C)),
                    const SizedBox(height: 10),
                    Text(localizedLabel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: isDarkMode
                                ? const Color(0xFF90D5AE)
                                : const Color(0xFF256C4C))),
                  ],
                ),
              ),
            
            // Status indicator with document name
            if (hasExisting)
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, 
                          color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${S.of(context).existing} : ${getLocalizedDocumentLabel(context, arabicLabel)}',
                          style: const TextStyle(
                              color: Colors.white, 
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
            // Tap to change overlay
            if (hasExisting)
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    S.of(context).tap_to_upload_new,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool isLoading = false;

  Future<void> _submitDocuments() async {
    setState(() => isLoading = true);

    String selectedUserTypeArabic = widget.userType;
    List<String> userDocs = requiredDocuments[selectedUserTypeArabic] ?? [];

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final docRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
      final snapshot = await docRef.get();
      
      Map<String, dynamic> currentTypes =
          Map<String, dynamic>.from(snapshot.data()?['userType'] ?? {});

      // Prepare the documents map for this user type
      Map<String, dynamic> documentsMap = {};
      
      // Process each required document
      for (String docArabic in userDocs) {
        final pickedImage = _pickedImages[docArabic];
        
        if (pickedImage != null) {
          // User uploaded a new image, use it
          String fileName =
              "${selectedUserTypeArabic}_${docArabic}_${DateTime.now().millisecondsSinceEpoch}";
          final storageRef =
              FirebaseStorage.instance.ref().child('documents/$fileName');
          await storageRef.putFile(File(pickedImage.path));

          String downloadUrl = await storageRef.getDownloadURL();
          
          documentsMap[docArabic] = {
            'documentUrl': downloadUrl,
            'uploadedAt': FieldValue.serverTimestamp(),
          };
        } else if (_hasExistingDocument(docArabic)) {
          // Reuse existing document
          documentsMap[docArabic] = _existingDocuments[docArabic]!;
        } else {
          // No document provided and none exists
          throw Exception(
              '${getLocalizedDocumentLabel(context, docArabic)} ${S.of(context).document_not_attached}');
        }
      }

      // Update Firestore with documents
      if (!currentTypes.containsKey(selectedUserTypeArabic)) {
        // Create new user type with documents
        currentTypes[selectedUserTypeArabic] = {
          'validation': false,
          'documents': documentsMap,
          'createdAt': FieldValue.serverTimestamp(),
        };
      } else {
        // Update existing user type with new/reused documents
        currentTypes[selectedUserTypeArabic]['documents'] = {
          ...currentTypes[selectedUserTypeArabic]['documents'] ?? {},
          ...documentsMap,
        };
      }

      // Single Firestore update with all documents
      await docRef.update({
        'userType': currentTypes,
        'userTypeUpdatedAt': FieldValue.serverTimestamp(),
      });

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
        if (mounted) Navigator.of(context).maybePop();
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

    if (_isLoadingExistingDocs) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${S.of(context).document_title} $localizedUserType'),
          backgroundColor: isDarkMode ? colorScheme.surface : colorScheme.surface,
          elevation: 5,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
            // Show info message if any documents are being reused
            if (documents.any((doc) => _hasExistingDocument(doc)))
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        S.of(context).documents_reused_notice,
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              ),
            
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