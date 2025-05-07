import 'dart:io';

import 'package:agriplant/data/ProductData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:agriplant/Back_end/Product.dart';
import 'package:image_picker/image_picker.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Controllers for input fields
  final TextEditingController quantiteController = TextEditingController();
  final TextEditingController surfaceController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<XFile> selectedImages = [];
  List<String> uploadedPhotos = [];

  List<String>? Category;
  List<String>? subCategory;
  List<String>? Product;
  List<String>? Unit;

  String? selectedCategory;
  String? selectedsubCategory;
  String? selectedproduct;
  String? selectedUnit;
  String? selectedTypeService;
  String? selectedWilaya;
  String? selectedDaira;
  String? typeItem;

  String? userType;

bool _isFormEmpty() {
  return quantiteController.text.trim().isEmpty &&
      surfaceController.text.trim().isEmpty &&
      prixController.text.trim().isEmpty &&
      descriptionController.text.trim().isEmpty &&
      (selectedImages.isEmpty) &&
      (selectedCategory == null || selectedCategory!.isEmpty) &&
      (selectedsubCategory == null || selectedsubCategory!.isEmpty) &&
      (selectedTypeService == null || selectedTypeService!.isEmpty) &&
      (selectedWilaya == null || selectedWilaya!.isEmpty) &&
      (selectedDaira == null || selectedDaira!.isEmpty) &&
      (selectedproduct == null || selectedproduct!.isEmpty) &&
      (selectedUnit == null || selectedUnit!.isEmpty);
}


  Future<void> fetchUserType() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      print('${docSnapshot.data()?['activeType']}');
      if (docSnapshot.exists) {
        setState(() {
          userType = docSnapshot.data()?['activeType'];
          print("$userType");
          switch (userType) {
            case 'Agriculteur':
              print('222222$Category');

              typeItem = "Agricultural Product";
              Category = ProductData.getMainCategories(typeItem, context);
              print('111111$Category');

              break;
            case 'Éleveur':
              typeItem = "Animal Product";
              Category = ProductData.getMainCategories(typeItem, context);
              break;
            case 'Commerçant':
              typeItem = "Commercial Product";
              Category = ProductData.getMainCategories(typeItem, context);
              break;
            case 'Expert Agri':
              typeItem = "Expertise";
              //ma7abtch temchi ki 3ayatlha man productData mfhmtch 3leh
              Category = [
                "استشارات الزراعة",
                "خدمات التوعية والتدريب",
                "التكنولوجيا الزراعية",
                "خدمات توجيهية للمزارعين",
                "مراقبة صحة النباتات والحيوانات",
                "الاستشارات المالية والإدارية",
              ];
              break;
            case 'Transporteur':
              typeItem = "Transportation";
              //ma7abtch temchi ki 3ayatlha man productData mfhmtch 3leh
              Category = ["نقل المواشي", "نقل المحاصيل", "نقل عام"];
              print(Category);
              break;
            case 'Réparateur':
              typeItem = "Repairs";
              Category = ProductData.ReparationType;
              break;
            default:
              print("🚨 Unknown userType: $userType");
              return;
          }
        });
        print('User type: $userType');
      } else {
        print('No such user document found.');
      }
    } else {
      print('User not logged in.');
    }
  }

  void initState() {
    super.initState();
    fetchUserType();
  }

  bool _isLoading = false; // To show a loading indicator

  void _resetForm() {
    _formKey.currentState?.reset();
    quantiteController.clear();
    surfaceController.clear();
    prixController.clear();
    descriptionController.clear();
    setState(() {
      selectedCategory = null;
      selectedsubCategory = null;
      selectedproduct = null;
      selectedWilaya = null;
      selectedDaira = null;
      selectedImages.clear(); // Reset dropdown value
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

      Products newProduct = Products(
        id: "", // سيتم تعيينه تلقائيًا في Firestore
        ownerId: FirebaseAuth.instance.currentUser?.uid ?? '',
        typeItem: typeItem ?? '', /////////
        category: selectedCategory,
        subCategory: selectedsubCategory,
        product: selectedproduct ?? '',
        quantity: quantiteController.text.isNotEmpty
            ? double.tryParse(quantiteController.text)
            : null,
        surface: surfaceController.text.isNotEmpty
            ? double.tryParse(quantiteController.text)
            : null,
        unit: selectedUnit ?? '',
        service: selectedTypeService ?? '',
        price: prixController.text.isNotEmpty
            ? double.tryParse(prixController.text)!
            : 0,
        description: descriptionController.text,
        comments: [],
        photos: uploadedPhotos, // ✅ استخدام رابط الصورة هنا
        liked: [],
        disliked: [],
        date_of_add: DateTime.now(),
        wilaya: selectedWilaya!,
        daira: selectedDaira!,
        SP: typeItem == "EleveurProduct" ||
                typeItem == "CommercantProduct" ||
                typeItem == "AgricolProduct"
            ? "Product"
            : "Service",
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

    for (var image in selectedImages) {
      final file = File(image.path);
      final url = await uploadImageToFirebase(file);
      if (url != null) {
        uploadedPhotos.add(url);
      }
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        selectedImages = images;
      });
    }
  }

  Map<String, List<String>> unitsByCategory = {
    "منتوجات فلاحية": ["كلغ", "طن", "لتر", "صندوق"],
    "أراضي": ["م²", "هكتار"],
    "معدات": ["قطعة", "مجموعة"]
  };
  List<String> serviceTypes = ["بيع", "كراء"];

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
                  child: selectedImages.isEmpty
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
                          itemCount: selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Image.file(
                                    File(selectedImages[index].path),
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
                                          selectedImages.removeAt(index);
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

// ==========================CATEGORY================================
              //category
              ProductData.buildDropdown(
                  context: context,
                  selectedValue: selectedCategory,
                  items: Category ?? [],
                  label: 'category',
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      selectedsubCategory = null;
                      selectedproduct = null;
                      print(selectedCategory);
                    });
                  }),

//============================SUB CATEGORIES==============================

              if (userType == 'Agriculteur' || userType == 'Commerçant')
                ProductData.buildDropdown(
                  context: context,
                  selectedValue: selectedsubCategory,
                  items: ProductData.getSubCategories(
                      typeItem, selectedCategory, context),
                  label: 'sub category',
                  onChanged: (value) {
                    setState(() {
                      selectedsubCategory = value;
                      selectedproduct = null;
                    });
                  },
                ),

//=============================PRODUCTS=========================================
              if (userType != 'Réparateur' && selectedCategory != null)
                ProductData.buildDropdown(
                    context: context,
                    selectedValue: selectedproduct,
                    items: userType == 'Transporteur'
                        ? ProductData.moyensDeTransport
                        : (selectedsubCategory != null
                            ? ProductData.getProduct(
                                typeItem, selectedsubCategory!, context)
                            : ProductData.getProduct(
                                typeItem, selectedCategory!, context)),
                    label: 'product',
                    onChanged: (value) {
                      setState(() {
                        selectedproduct = value;
                      });
                    }),

//===========================Quantity===================================

              if (userType == "Agriculteur" || userType == "Éleveur") ...[
                ProductData.buildTextField(
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
              ],
//=======================SERVICES TYPE======================================
              if (userType == "Commerçant" && selectedCategory != null)
                ProductData.buildDropdown(
                  context: context,
                  selectedValue: selectedTypeService,
                  items: serviceTypes,
                  label: 'Rent / Sell',
                  onChanged: (value) {
                    setState(() {
                      selectedTypeService = value;
                    });
                  },
                ),

//=========================SURFACES====================================
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
//===============================PRICE====================================
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
//==============================UNITS================================
              if (selectedCategory != null &&
                  unitsByCategory.containsKey(selectedCategory!))
                ProductData.buildDropdown(
                  context: context,
                  selectedValue: selectedUnit,
                  items: unitsByCategory[selectedCategory]!,
                  label: 'Unit',
                  onChanged: (value) {
                    setState(() {
                      selectedUnit = value;
                    });
                  },
                ),

//==============================WILAYA================================
              ProductData.buildDropdown(
                context: context,
                selectedValue: selectedWilaya,
                items: ProductData.wilayas(context).keys.toList(),
                label: 'Wilaya',
                onChanged: (value) {
                  setState(() {
                    selectedWilaya = value;
                    selectedDaira = null;
                  });
                },
              ),

//==============================DAIRA================================
              if (selectedWilaya != null)
                ProductData.buildDropdown(
                    context: context,
                    selectedValue: selectedDaira,
                    items: ProductData.wilayas(context)[selectedWilaya]!,
                    label: 'Daira',
                    onChanged: (value) {
                      setState(() {
                        selectedDaira = value;
                      });
                    }),

//==============================DESCRIPTION================================
              ProductData.buildTextField(
                controller: descriptionController,
                hintText: "Description",
                icon: Icons.description,
                maxLines: 4,
                validator: (value) {
                  return null;
                },
              ),

//==============================RESET BUTTON======================================================
      ProductData.actionButton(label: "Reset",backgroundColor: Colors.blueGrey.shade700, isLoading: _isLoading, onPressed: _isFormEmpty()
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("The form is empty",
                       style: TextStyle(color: Colors.black),),
                      backgroundColor: const Color.fromARGB(255, 247, 234, 117),
                    ),
                  );
                }
              : () {
                  try {
                    _resetForm();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                },),

//==============================SHARE BUTTON================================
              ProductData.actionButton(
                label: "Share",
                isLoading: _isLoading,
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
                        }
              ),
//==============================FIN================================
            ],
          ),
        ),
      ),
    );
  }
}
