import 'package:agriplant/Back_end/ProductElev.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductEleveur extends StatefulWidget {
  const AddProductEleveur({Key? key}) : super(key: key);

  @override
  State<AddProductEleveur> createState() => _AddProductEleveurState();
}

class _AddProductEleveurState extends State<AddProductEleveur> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for input fields

  final TextEditingController imageController = TextEditingController();
  final TextEditingController quantiteController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedCategory;
  String? selectedproduct;
  String? selectedWilaya;
  String? selectedDaira;

  bool _isLoading = false; // To show a loading indicator

  void _resetForm() {
    _formKey.currentState?.reset();
    imageController.clear();
    quantiteController.clear();
    prixController.clear();
    descriptionController.clear();
    setState(() {
      selectedCategory = null;
      selectedWilaya = null;
      selectedDaira = null;
      selectedproduct = null; // Reset dropdown value
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Create a Product object
      ProductElev newProduct = ProductElev(
        id: UniqueKey().toString(), // أو استخدم UUID
        name: selectedproduct ?? '', // أو أي اسم تختاره
        typeProduct: "EleveurProduct", // أو أي اسم تختاره
        price: prixController.text.isNotEmpty
            ? double.tryParse(prixController.text) ?? 0.0
            : 0.0,
        description: descriptionController.text,
        rate: 0,
        ownerId: FirebaseAuth.instance.currentUser?.uid,
        comments: [],
        photos: uploadedPhotos, // قائمة روابط الصور من Firebase Storage
        liked: [],
        disliked: [],
        date_of_add: DateTime.now(),
        category: selectedCategory,
        quantite: quantiteController.text.isNotEmpty
            ? double.tryParse(quantiteController.text)
            : null,
        wilaya: selectedWilaya!,
        daira: selectedDaira!,
      );
      // Add to Firestore
      await newProduct.addProduct(newProduct);

      // Show success message
      _showSuccessDialog(context);

      // Clear the form
      _resetForm();

      setState(() {
        _isLoading = false;
      });
    }
  }

  //produit elevage

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
            FirebaseStorage.instance.ref().child('product_images/$fileName');

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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Added Successfully! ✅"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produit Elevage 🐏"),
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
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                    color: Colors.green.shade50,
                  ),
                  child: _selectedImages.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo_library,
                                  size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text("Tap to select images",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File(_selectedImages[index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                ),
              ),

              const SizedBox(height: 15),

              //category
              ProductData.buildDropdown(
                  selectedValue: selectedCategory,
                  items: ProductData.produitsElevages.keys.toList(),
                  label: "Category",
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      selectedproduct = null;
                    });
                  }),

              //Produit
              if (selectedCategory != null)
                ProductData.buildDropdown(
                    selectedValue: selectedproduct,
                    items: ProductData.produitsElevages[selectedCategory]!,
                    label: 'product',
                    onChanged: (value) {
                      setState(() {
                        selectedproduct = value;
                      });
                    }),

              //quantity
              ProductData.buildTextField(
                controller: quantiteController,
                hintText: "الكمية",
                icon: Icons.scale,
                keyboardType: TextInputType.number,
                validator: (value) {
                  return null;
                },
              ),

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
                },
              ),

              if (selectedWilaya != null)
                ProductData.buildDropdown(
                    selectedValue: selectedDaira,
                    items: ProductData.wilayas[selectedWilaya]!,
                    label: "Daïra",
                    onChanged: (value) {
                      setState(() {
                        selectedDaira = value;
                      });
                    }),

              //description
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
