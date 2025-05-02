import 'package:agriplant/Back_end/Products/ProductCommer%C3%A7ant.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductCommercant extends StatefulWidget {
  const AddProductCommercant({Key? key}) : super(key: key);

  @override
  State<AddProductCommercant> createState() => _AddProductCommercantState();
}

class _AddProductCommercantState extends State<AddProductCommercant> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controllers for input fields
  final TextEditingController surfaceController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String>? Category;
  List<String>? subCategory;
  List<String>? Products;

  String? selectedCategory;
  String? selectedsubCategory;
  String? selectedproduct;
  String? selectedService;
  String? selectedWilaya;
  String? selectedDaira;
  void initState() {
    super.initState();
    Category = ProductData.getMainCategories("CommercantProduct");
    subCategory =
        ProductData.getSubCategories("CommercantProduct", selectedCategory);
    Products = ProductData.getProduct("CommercantProduct", selectedsubCategory);
  }

  bool _isLoading = false; // To show a loading indicator

  void _resetForm() {
    _formKey.currentState?.reset();
    surfaceController.clear();
    prixController.clear();
    descriptionController.clear();
    setState(() {
      selectedsubCategory = null;
      selectedService = null;
      selectedWilaya = null;
      selectedDaira = null;
      selectedproduct = null;
      selectedCategory = null;
      _selectedImages.clear(); // Reset dropdown value
    });
  }

  Future<void> _submitForm() async {
    await uploadSelectedImages();
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
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

      ProductCommercant newProduct = ProductCommercant(
        id: "", // سيتم تعيينه تلقائيًا في Firestore
        name: selectedproduct ?? '',
        typeProduct: "CommercantProduct",
        price: prixController.text.isNotEmpty
            ? double.tryParse(prixController.text)!
            : 0.0,
        description: descriptionController.text,
        rate: 0,
        ownerId: FirebaseAuth.instance.currentUser?.uid ?? '',
        comments: [],
        unite: selectedUnite ?? '',
        serviceType: selectedService ?? '',
        photos: uploadedPhotos, // ✅ استخدام رابط الصورة هنا
        liked: [],
        disliked: [],
        date_of_add: DateTime.now(),
        category: selectedCategory,
        subcategory: selectedsubCategory,
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
      Reference ref =
          FirebaseStorage.instance.ref().child('product_images/$fileName');

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('❌ فشل في رفع الصورة: $e');
      return null;
    }
  }

  Future<void> uploadSelectedImages() async {
    uploadedPhotos.clear(); // تنظيف القديم

    for (var image in _selectedImages) {
      final file = File(image.path);
      final url = await uploadImageToFirebase(file);
      if (url != null) {
        uploadedPhotos.add(url);
      }
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
    }
  }

  Map<String, List<String>> unitsByCategory = {
    "منتوجات فلاحية": ["كلغ", "طن", "لتر", "صندوق"],
    "أراضي": ["م²", "هكتار"],
    "معدات": ["قطعة", "مجموعة"]
  };

  List<String> serviceTypes = ["بيع", "كراء"];

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
        title: const Text("Commercant 💰"),
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
              // add the images
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
                              child: Stack(
                                children: [
                                  Image.file(
                                    File(_selectedImages[index].path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        // 👇 هذا التعديل يتم بأمان داخل setState وخارج التكرار
                                        setState(() {
                                          _selectedImages.removeAt(index);
                                          if (uploadedPhotos.length > index) {
                                            uploadedPhotos.removeAt(index);
                                          }
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.7),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),

              const SizedBox(height: 15),

              ProductData.buildDropdown(
                  selectedValue: selectedCategory,
                  items: Category!,
                  label: 'type',
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      selectedsubCategory = null;
                      selectedproduct = null;
                    });
                  }),
              if (selectedCategory == "معدات")
                Column(
                  children: [
                    ProductData.buildDropdown(
                      selectedValue: selectedsubCategory,
                      items: (ProductData.equipmentCategories.keys.toList()),
                      label: 'category',
                      onChanged: (value) {
                        setState(() {
                          selectedsubCategory = value;
                          selectedproduct = null;
                        });
                      },
                    ),
                  ],
                ),
              if (selectedsubCategory != null &&
                  selectedCategory == "معدات")
                Column(
                  children: [
                    ProductData.buildDropdown(
                      selectedValue: selectedproduct,
                      items: (ProductData
                          .equipmentCategories[selectedsubCategory])!,
                      label: 'Produit',
                      onChanged: (value) {
                        setState(() {
                          selectedproduct = value;
                        });
                      },
                    ),
                  ],
                ),

              if (selectedCategory != null)
                ProductData.buildDropdown(
                  selectedValue: selectedService,
                  items: serviceTypes,
                  label: 'Rent / Sell',
                  onChanged: (value) {
                    setState(() {
                      selectedService = value;
                    });
                  },
                ),

              if (selectedCategory == "أراضي")
                ProductData.buildTextField(
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
              if (selectedCategory == "معدات" || selectedCategory == "أراضي")
                ProductData.buildTextField(
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

              if (selectedCategory != null &&
                  unitsByCategory.containsKey(selectedCategory!))
                ProductData.buildDropdown(
                  selectedValue: selectedUnite,
                  items: unitsByCategory[selectedCategory]!,
                  label: 'Unit',
                  onChanged: (value) {
                    setState(() {
                      selectedUnite = value;
                    });
                  },
                ),

              //wilaya selection
              ProductData.buildDropdown(
                selectedValue: selectedWilaya,
                items: ProductData.wilayas.keys.toList(),
                label: 'Wilaya',
                onChanged: (value) {
                  setState(() {
                    selectedWilaya = value;
                    selectedDaira = null;
                  });
                },
              ),

              //Daira selection
              if (selectedWilaya != null)
                ProductData.buildDropdown(
                    selectedValue: selectedDaira,
                    items: ProductData.wilayas[selectedWilaya]!,
                    label: 'Daira',
                    onChanged: (value) {
                      setState(() {
                        selectedDaira = value;
                      });
                    }),

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
                            setState(() {
                              _isLoading = true;
                            });
                            _submitForm();
                            setState(() {
                              _isLoading = true;
                            });
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
