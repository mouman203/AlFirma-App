import 'package:agriplant/Back_end/ProductAgri.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductAgriculteur extends StatefulWidget {
  const AddProductAgriculteur({Key? key}) : super(key: key);

  @override
  State<AddProductAgriculteur> createState() => _AddProductAgriculteurState();
}

class _AddProductAgriculteurState extends State<AddProductAgriculteur> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controllers for input fields
  final TextEditingController imageController = TextEditingController();
  final TextEditingController quantiteController = TextEditingController();
  final TextEditingController surfaceController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String>? Category;
  List<String>? subCategory;
  List<String>? Products;

  String? selectedCategory;
  String? selectedsubCategory;
  String? selectedproduct;
  String? selectedWilaya;
  String? selectedDaira;
  void initState(){
    super.initState();
   Category = ProductData.getMainCategories("AgricolProduct");
   subCategory= ProductData.getSubCategories("AgricolProduct", selectedCategory);
   Products = ProductData.getProduct("AgricolProduct",selectedsubCategory);

  }

  bool _isLoading = false; // To show a loading indicator

  void _resetForm() {
    _formKey.currentState?.reset();
    imageController.clear();
    quantiteController.clear();
    surfaceController.clear();
    prixController.clear();
    descriptionController.clear();
    setState(() {
      selectedsubCategory = null;
      selectedWilaya = null;
      selectedDaira = null;
      selectedproduct = null;
      selectedCategory = null; // Reset dropdown value
    });
  }

 // هذا المتغير سيحمل رابط الصورة بعد الرفع

  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    if (uploadedPhotos.isEmpty) {
      // منع الإرسال بدون صورة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📸 الرجاء تحميل صورة المنتج أولًا")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Productagri newProduct = Productagri(
      id: "", // سيتم تعيينه تلقائيًا في Firestore
      name: selectedproduct ?? '',
      typeProduct: "AgricolProduct",
      price: prixController.text.isNotEmpty ? double.tryParse(prixController.text)! : 0.0,
      description: descriptionController.text,
      rate: 0,
      ownerId: FirebaseAuth.instance.currentUser?.uid ?? '',
      comments: [],
      unite: selectedUnite ?? '',
      photos: uploadedPhotos , // ✅ استخدام رابط الصورة هنا
      liked: [],
      disliked: [],
      date_of_add: DateTime.now(),
      category: selectedCategory,
      subcategory: selectedsubCategory,
      quantite: quantiteController.text.isNotEmpty
          ? double.tryParse(quantiteController.text)
          : null,
      surface: surfaceController.text.isNotEmpty
          ? double.tryParse(surfaceController.text)
          : null,
      wilaya: selectedWilaya!,
      daira: selectedDaira!,
    );

    await newProduct.addProduct(newProduct);
    _showSuccessDialog(context);
    _resetForm();

    setState(() {
      _isLoading = false;
    });
  }
}


Future<String?> uploadImageToFirebase(File imageFile) async {
  try {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('product_images/$fileName');

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

  if ( images.isNotEmpty) {
    setState(() {
      _selectedImages = images;
    });

    // رفع الصور إلى Firebase Storage
    for (var image in _selectedImages) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child('product_images/$fileName');

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



  Map<String, List<String>> unitsByCategory = {
  "منتوجات فلاحية": ["كلغ", "طن", "لتر", "صندوق"],
  "أراضي": ["م²", "هكتار"],
  "معدات": ["قطعة", "مجموعة"]
};

  String? selectedUnite;


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
        title: const Text("Produit Agricole 🌿"),
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
                                  Icon(Icons.photo_library, size: 50, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text("Tap to select images", style: TextStyle(color: Colors.grey)),
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

              DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: _dropdownDecoration("Category"),
                  items: Category
                      !.map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      selectedsubCategory = null;
                      selectedproduct = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a type';
                    }
                    return null;
                  }),
              const SizedBox(height: 15),

              if (selectedCategory == "منتوجات فلاحية" ||
                  selectedCategory == "معدات")
                  Column(
                    children: [
                                  DropdownButtonFormField<String>(
                    value: selectedsubCategory,
                    decoration: _dropdownDecoration("Catégorie"),
                    items: (selectedCategory == "منتوجات فلاحية"
                            ? Category
                            : ProductData.equipmentCategories.keys)
                        !.map(
                          (categorie) => DropdownMenuItem(
                            value: categorie,
                            child: Text(categorie),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedsubCategory = value;
                        selectedproduct = null;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    }),
              const SizedBox(height: 15),
                    ],
                  ),
                
              

              if ((selectedCategory == "منتوجات فلاحية" ||
                      selectedCategory == "معدات") &&
                  selectedsubCategory != null)
                  Column(
                    children: [
                      DropdownButtonFormField<String>(
                  value: selectedproduct,
                  decoration: _dropdownDecoration("Produit"),
                  items: (selectedCategory == "منتوجات فلاحية"
                          ? ProductData.agriCategories[selectedsubCategory!]
                          : ProductData.equipmentCategories[selectedsubCategory!])!
                      .map(
                        (produit) => DropdownMenuItem(
                          value: produit,
                          child: Text(produit),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedproduct = value;
                    });
                  },
                ),
              const SizedBox(height: 15),
                    ],
                  ),
                

              if (selectedCategory == "منتوجات فلاحية")
                _buildTextField(
                    controller: quantiteController,
                    hintText: "الكمية",
                    icon: Icons.scale,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the feild';
                      }
                      return null;
                    }),

              if (selectedCategory == "أراضي")
                _buildTextField(
                    controller: surfaceController,
                    hintText: "المساحة",
                    icon: Icons.landscape,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the feild';
                      }
                      return null;
                    }),
              const SizedBox(height: 15),
              if (selectedCategory == "منتوجات فلاحية" ||
                  selectedCategory == "أراضي")
                _buildTextField(
                    controller: prixController,
                    hintText: "السعر",
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the feild';
                      }
                      return null;
                    }),
              const SizedBox(height: 15),

              //wilaya selection
              DropdownButtonFormField<String>(
                  value: selectedWilaya,
                  decoration: _dropdownDecoration("Wilaya"),
                  items: ProductData.wilayas.keys
                      .map(
                        (wilaya) => DropdownMenuItem(
                          value: wilaya,
                          child: Text(wilaya),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedWilaya = value;
                      selectedDaira = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a wilaya';
                    }
                    return null;
                  }),
              const SizedBox(height: 15),

              if (selectedWilaya != null)
                DropdownButtonFormField<String>(
                    value: selectedDaira,
                    decoration: _dropdownDecoration("Daïra"),
                    items: ProductData.wilayas[selectedWilaya]!
                        .map(
                          (daira) => DropdownMenuItem(
                            value: daira,
                            child: Text(daira),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDaira = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a daira';
                      }
                      return null;
                    }),
              if (selectedCategory != null &&
                      unitsByCategory.containsKey(selectedCategory!))
                    DropdownButtonFormField<String>(
                      value: selectedUnite,
                      decoration: _dropdownDecoration("الوحدة"),
                      items: unitsByCategory[selectedCategory]!
                          .map((unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedUnite = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى اختيار الوحدة';
                        }
                        return null;
                      },
                    ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: descriptionController,
                hintText: "Description",
                icon: Icons.description,
                maxLines: 4,
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 15),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required String? Function(dynamic value) validator,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.green.shade50,
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.green.shade50,
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
