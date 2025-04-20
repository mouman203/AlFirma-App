import 'package:agriplant/Back_end/RepairService.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductReparateur extends StatefulWidget {
  const AddProductReparateur({Key? key}) : super(key: key);

  @override
  State<AddProductReparateur> createState() => _AddProductReparateurState();
}

class _AddProductReparateurState extends State<AddProductReparateur> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for input fields

  final TextEditingController imageController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image;

  bool _isLoading = false; // To show a loading indicator

  void _resetForm() {
    _formKey.currentState?.reset();
    imageController.clear();
    prixController.clear();
    descriptionController.clear();
    setState(() {
      selectedCategorie = null;
      selectedWilaya = null;
      selectedDaira = null; // Reset dropdown value
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Create a Product object
      RepairService newService = RepairService(
        id: "", // سيتم تعيينه تلقائيًا في Firestore
        typeService: "Repairs",
        categorie: selectedCategorie ?? '',
        price: prixController.text.isNotEmpty
            ? double.tryParse(prixController.text)!
            : 0.0,
        description: descriptionController.text,
        rate: 0,
        ownerId: FirebaseAuth.instance.currentUser?.uid ?? '',
        comments: [],
        photos: uploadedPhotos, // ✅ استخدام رابط الصورة هنا
        liked: [],
        disliked: [],
        date_of_add: DateTime.now(),
        wilaya: selectedWilaya,
        daira: selectedDaira,
      );

      await newService.addRepairService(newService);

      _showSuccessDialog();
      _resetForm();
      setState(() => _isLoading = false);
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('service_image/$fileName');

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('❌ فشل في رفع الصورة: $e');
      return null;
    }
  }

  List<XFile> _selectedImages = [];
  List<String> uploadedPhotos = [];
  Future<void> _pickImages() async {
    final List<XFile> images = await ImagePicker().pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images;
      });

      // رفع الصور إلى Firebase Storage
      for (var image in _selectedImages) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef =
            FirebaseStorage.instance.ref().child('service_image/$fileName');

        try {
          await storageRef.putFile(File(image.path));
          String downloadUrl = await storageRef.getDownloadURL();
          uploadedPhotos.add(downloadUrl);
        } catch (e) {
          print("❌ Error uploading image: $e");
        }
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Added Successfully! ✅"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  // Types of repair services
  String? selectedCategorie;
  final List<String> categories = [
    "إصلاح المعدات الزراعية",
    "إصلاح الآلات الثقيلة",
    "إصلاح أنظمة الري",
    "صيانة المنشآت",
    "إصلاح المعدات الكهربائية"
  ];

  String? selectedWilaya;
  String? selectedDaira;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Réparation 🛠️"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Back button functionality
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade700),
                  ),
                  child: _image == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Appuyez pour ajouter une photo",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 15),

              //category
              ProductData.buildDropdown(
                  selectedValue: selectedCategorie,
                  items: categories,
                  label: "category",
                  onChanged: (value) {
                    setState(() {
                      selectedCategorie = value;
                    });
                  }),
           

              //prix
              ProductData.buildTextField(
                controller: prixController,
                hintText: "السعر",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  return null;
                },
              ),
           
              //wilaya selection
              ProductData.buildDropdown(
                  selectedValue: selectedWilaya,
                  items: ProductData.wilayas.keys.toList(),
                  label: "Wilaya",
                  onChanged: (value) {
                    setState(() {
                      selectedWilaya = value;
                      selectedDaira = null;
                    });
                  }),
          

              if (selectedWilaya != null)
                ProductData.buildDropdown(
                  selectedValue: selectedDaira,
                  items: ProductData.wilayas[selectedWilaya]!,
                  label: "Daira",
                  onChanged: (value) {
                    setState(() {
                      selectedDaira = value;
                    });
                  },
                ),
         
              ProductData.buildTextField(
                controller: descriptionController,
                hintText: "Description",
                icon: Icons.description,
                maxLines: 4,
                validator: (value) {
                  return null;
                },
              ),
            
              SizedBox(
                width: double.infinity, // Make the button full width
                height: 50, // Match the height of text fields
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator()) // Show progress
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          try {
                            _submitForm();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          }
                        },
                        child: const Text(
                          "Share",
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
