import 'dart:io';

import 'package:agriplant/data/ProductData.dart';
import 'package:agriplant/generated/l10n.dart';
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

  // Maps for translation
  Map<String, String> categoryTranslations = {};
  Map<String, String> subCategoryTranslations = {};
  Map<String, String> productTranslations = {};
  Map<String, String> unitTranslations = {};
  Map<String, String> serviceTypeTranslations = {};
  Map<String, String> wilayaTranslations = {};
  Map<String, String> dairaTranslations = {};

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

  // Helper function to convert from localized to Arabic value
  String getArabicValue(
      Map<String, String> translationMap, String localizedValue) {
    final entry = translationMap.entries.firstWhere(
      (entry) => entry.value == localizedValue,
      orElse: () => MapEntry(localizedValue, localizedValue),
    );
    return entry.key;
  }

  // Initialize translation maps
  void _initTranslationMaps() {
    // Initialize category translations
    if (typeItem != null) {
      switch (typeItem) {
        case "Agricultural Product":
          _initAgriCategoryTranslations();
          break;
        case "Animal Product":
          _initAnimalProductTranslations();
          break;
        case "Commercial Product":
          _initCommercialProductTranslations();
          break;
        case "Expertise":
          _initExpertiseTranslations();
          break;
        case "Transportation":
          _initTransportationTranslations();
          break;
        case "Repairs":
          _initRepairTranslations();
          break;
      }
    }

    // Initialize service types translations
    serviceTypeTranslations = {
      "بيع": S.of(context).sell,
      "كراء": S.of(context).rent,
    };

    // Initialize units translations
    unitTranslations = {
      "كلغ": S.of(context).kg,
      "طن": S.of(context).ton,
      "لتر": S.of(context).liter,
      "صندوق": S.of(context).box,
      "م²": S.of(context).squareMeter,
      "هكتار": S.of(context).hectare,
      "قطعة": S.of(context).piece,
      "مجموعة": S.of(context).set,
    };

    // Initialize wilaya and daira translations
    _initWilayaAndDairaTranslations();
  }

  void _initAgriCategoryTranslations() {
    // Map for main agricultural categories
    final arabicMap = ProductData.agriCategories;
    final localizedMap = ProductData.agriCategoriesT(context);

    _mapTranslations(arabicMap, localizedMap, categoryTranslations);

    // Map for subcategories
    final arabicSubMap = ProductData.agriSubCategories;
    final localizedSubMap = ProductData.agriSubCategoriesT(context);

    _mapTranslations(arabicSubMap, localizedSubMap, subCategoryTranslations);
  }

  void _initAnimalProductTranslations() {
    final arabicMap = ProductData.produitsElevages;
    final localizedMap = ProductData.produitsElevagesT(context);

    _mapTranslations(arabicMap, localizedMap, categoryTranslations);

    // Animal products don't have separate subcategories in the provided code
    // So we'll use the same mapping for products
    _mapTranslations(arabicMap, localizedMap, subCategoryTranslations);
  }

  void _initCommercialProductTranslations() {
    final arabicMap = ProductData.commercantCategories;
    final localizedMap = ProductData.commercantCategoriesT(context);

    _mapTranslations(arabicMap, localizedMap, categoryTranslations);

    // Map for equipment subcategories
    final arabicEquipMap = ProductData.equipmentCategories;
    final localizedEquipMap = ProductData.equipmentCategoriesT(context);

    _mapTranslations(
        arabicEquipMap, localizedEquipMap, subCategoryTranslations);
  }

  void _initExpertiseTranslations() {
    final arabicMap = ProductData.ExpertProducts;
    final localizedMap = ProductData.expertProductsT(context);

    _mapTranslations(arabicMap, localizedMap, categoryTranslations);
  }

  void _initTransportationTranslations() {
    // Transportation has simple lists, not maps
    final transportCategories = ["نقل المواشي", "نقل المحاصيل", "نقل عام"];
    final localizedTransportCategories = [
      S.of(context).livestockTransport,
      S.of(context).cropTransport,
      S.of(context).generalTransport,
    ];

    for (int i = 0; i < transportCategories.length; i++) {
      if (i < localizedTransportCategories.length) {
        categoryTranslations[transportCategories[i]] =
            localizedTransportCategories[i];
      }
    }

    // For transport product types
    final arabicTransport = ProductData.moyensDeTransport;
    final localizedTransport = ProductData.moyensDeTransportT(context);

    for (int i = 0; i < arabicTransport.length; i++) {
      if (i < localizedTransport.length) {
        productTranslations[arabicTransport[i]] = localizedTransport[i];
      }
    }
  }

  void _initRepairTranslations() {
    final arabicRepair = ProductData.ReparationType;
    final localizedRepair = ProductData.reparationTypeT(context);

    for (int i = 0; i < arabicRepair.length; i++) {
      if (i < localizedRepair.length) {
        categoryTranslations[arabicRepair[i]] = localizedRepair[i];
      }
    }
  }

  void _initWilayaAndDairaTranslations() {
    final arabicMap = ProductData.wilayas;
    final localizedMap = ProductData.wilayasT(context);

    final arabicWilayasList = arabicMap.keys.toList();
    final localizedWilayasList = localizedMap.keys.toList();

    for (int i = 0; i < arabicWilayasList.length; i++) {
      final arabicWilaya = arabicWilayasList[i];
      if (i >= localizedWilayasList.length) continue; // safeguard
      final localizedWilaya = localizedWilayasList[i];

      wilayaTranslations[arabicWilaya] = localizedWilaya;
      wilayaTranslations[localizedWilaya] =
          arabicWilaya; // Bidirectional mapping

      final arabicDairas = arabicMap[arabicWilaya]!;
      final localizedDairas = localizedMap[localizedWilaya]!;

      for (int j = 0; j < arabicDairas.length; j++) {
        if (j >= localizedDairas.length) continue;
        dairaTranslations[arabicDairas[j]] = localizedDairas[j];
        dairaTranslations[localizedDairas[j]] =
            arabicDairas[j]; // Bidirectional mapping
      }
    }
  }

  void _mapTranslations(Map<String, List<String>> arabicMap,
      Map<String, List<String>> localizedMap, Map<String, String> targetMap) {
    // Map main categories
    arabicMap.forEach((arabicKey, arabicValues) {
      // Find the matching localized key
      String? localizedKey = localizedMap.keys.firstWhere(
        (key) => localizedMap[key]!.length == arabicValues.length,
        orElse: () => arabicKey,
      );

      // Add to translation map
      targetMap[arabicKey] = localizedKey;
      targetMap[localizedKey] = arabicKey; // Add reverse mapping

      // Map values (products)
      List<String> localizedValues = localizedMap[localizedKey] ?? [];
      for (int i = 0; i < arabicValues.length; i++) {
        if (i < localizedValues.length) {
          productTranslations[arabicValues[i]] = localizedValues[i];
          productTranslations[localizedValues[i]] =
              arabicValues[i]; // Add reverse mapping
        }
      }
    });
  }

  Future<void> fetchUserType() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (docSnapshot.exists) {
        final fetchedType = docSnapshot.data()?['activeType'];
        print('Fetched userType: $fetchedType');

        if (!mounted) return; // 👈 Check if widget is still mounted

        setState(() {
          userType = fetchedType;
          print("userType set to: $userType");

          switch (userType) {
            case 'Agriculteur':
              typeItem = "Agricultural Product";
              Category = ProductData.getMainCategories(typeItem, context);
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
              Category = [
                S.of(context).agricultureConsulting,
                S.of(context).trainingServices,
                S.of(context).agriTech,
                S.of(context).farmerGuidance,
                S.of(context).plantAnimalHealth,
                S.of(context).financeAdminConsulting,
              ];
              break;
            case 'Transporteur':
              typeItem = "Transportation";
              Category = [
                S.of(context).livestockTransport,
                S.of(context).cropTransport,
                S.of(context).generalTransport,
              ];
              break;
            case 'Réparateur':
              typeItem = "Repairs";
              Category = ProductData.reparationTypeT(context);
              break;
            default:
              print("🚨 Unknown userType: $userType");
              return;
          }

          _initTranslationMaps();
        });
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
      selectedUnit = null;
      selectedTypeService = null;
      selectedImages.clear();
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

      // Convert from localized values to Arabic values for storage
      String? arabicCategory = selectedCategory != null
          ? getArabicValue(categoryTranslations, selectedCategory!)
          : null;

      String? arabicSubCategory = selectedsubCategory != null
          ? getArabicValue(subCategoryTranslations, selectedsubCategory!)
          : null;

      String? arabicProduct = selectedproduct != null
          ? getArabicValue(productTranslations, selectedproduct!)
          : null;

      String? arabicUnit = selectedUnit != null
          ? getArabicValue(unitTranslations, selectedUnit!)
          : null;

      String? arabicService = selectedTypeService != null
          ? getArabicValue(serviceTypeTranslations, selectedTypeService!)
          : null;

      String? arabicWilaya = selectedWilaya != null
          ? getArabicValue(wilayaTranslations, selectedWilaya!)
          : null;

      String? arabicDaira = selectedDaira != null
          ? getArabicValue(dairaTranslations, selectedDaira!)
          : null;

      Products newProduct = Products(
        id: "", // سيتم تعيينه تلقائيًا في Firestore
        ownerId: FirebaseAuth.instance.currentUser?.uid ?? '',
        typeItem: typeItem ?? '', /////////
        category: arabicCategory,
        subCategory: arabicSubCategory,
        product: arabicProduct ?? '',
        quantity: quantiteController.text.isNotEmpty
            ? double.tryParse(quantiteController.text)
            : null,
        surface: surfaceController.text.isNotEmpty
            ? double.tryParse(quantiteController.text)
            : null,
        unit: arabicUnit,
        service: arabicService,
        price: prixController.text.isNotEmpty
            ? double.tryParse(prixController.text)!
            : 0,
        description: descriptionController.text,
        comments: [],
        photos: uploadedPhotos, // ✅ استخدام رابط الصورة هنا
        liked: [],
        disliked: [],
        date_of_add: DateTime.now(),
        wilaya: arabicWilaya,
        daira: arabicDaira,
        SP: typeItem == "Animal Product" ||
                typeItem == "Commercial Product" ||
                typeItem == "Agricultural Product"
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

  Map<String, List<String>> getLocalizedUnitsByCategory() {
    return {
      S.of(context).agriculturalProducts: [
        S.of(context).kg,
        S.of(context).ton,
        S.of(context).liter,
        S.of(context).box
      ],
      S.of(context).lands: [S.of(context).squareMeter, S.of(context).hectare],
      S.of(context).equipment: [S.of(context).piece, S.of(context).set]
    };
  }

  List<String> getLocalizedServiceTypes() {
    return [S.of(context).sell, S.of(context).rent];
  }

  @override
  Widget build(BuildContext context) {
    final localizedUnitsByCategory = getLocalizedUnitsByCategory();
    final localizedServiceTypes = getLocalizedServiceTypes();
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
                  items: localizedServiceTypes,
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
                  localizedUnitsByCategory.containsKey(selectedCategory!))
                ProductData.buildDropdown(
                  context: context,
                  selectedValue: selectedUnit,
                  items: localizedUnitsByCategory[selectedCategory!]!,
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
                items: ProductData.wilayasT(context).keys.toList(),
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
                    items: ProductData.wilayasT(context)[selectedWilaya]!,
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
              ProductData.actionButton(
                label: "Reset",
                backgroundColor: Colors.blueGrey.shade700,
                isLoading: _isLoading,
                onPressed: _isFormEmpty()
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "The form is empty",
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 247, 234, 117),
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
                      },
              ),

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
                  }),
//==============================FIN================================
            ],
          ),
        ),
      ),
    );
  }
}
