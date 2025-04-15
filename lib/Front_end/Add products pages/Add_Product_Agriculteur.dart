import 'package:agriplant/Back_end/ProductAgri.dart';
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

  bool _isLoading = false; // To show a loading indicator

  void _resetForm() {
    _formKey.currentState?.reset();
    imageController.clear();
    quantiteController.clear();
    surfaceController.clear();
    prixController.clear();
    descriptionController.clear();
    setState(() {
      selectedCategorie = null;
      selectedWilaya = null;
      selectedDaira = null;
      selectedProduit = null;
      selectedPrimaryCategory = null; // Reset dropdown value
    });
  }

 // هذا المتغير سيحمل رابط الصورة بعد الرفع

  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    if (uploadedPhotos == []) {
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
      name: selectedProduit ?? '',
      typeProduct: "AgricolProduct",
      price: prixController.text.isNotEmpty ? double.tryParse(prixController.text)! : 0.0,
      description: descriptionController.text,
      rate: 0,
      ownerId: FirebaseAuth.instance.currentUser?.uid ?? '',
      comments: [],
      unite: selectedUnite ?? '',
      photos: uploadedPhotos, // ✅ استخدام رابط الصورة هنا
      liked: [],
      disliked: [],
      type: selectedPrimaryCategory,
      category: selectedCategorie,
      produit: selectedProduit,
      quantite: quantiteController.text.isNotEmpty
          ? double.tryParse(quantiteController.text)
          : null,
      surface: surfaceController.text.isNotEmpty
          ? double.tryParse(surfaceController.text)
          : null,
      wilaya: selectedWilaya,
      daira: selectedDaira,
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



  final List<String> primaryCategories = ["منتوجات فلاحية", "معدات", "أراضي"];
  String? selectedPrimaryCategory;

  //produit agricoles
  final Map<String, List<String>> produitsAgricoles = {
    "الفواكه": [
      "تفاح ",
      "برتقال ",
      "موز ",
      "عنب ",
      "فراولة ",
      "مانجو ",
      "كمثرى ",
      "كرز ",
      "بطيخ ",
      "شمام ",
      "كيوي ",
      "أناناس ",
      "رمان ",
      "تين ",
      "تمر ",
    ],
    "الخضروات ": [
      "طماطم ",
      "جزر ",
      "بطاطا ",
      "فلفل ",
      "بصل ",
      "ثوم ",
      "خس ",
      "خيار ",
      "باذنجان ",
      "سبانخ",
      "ملفوف ",
      "فجل ",
      "شمندر ",
      "فاصوليا خضراء ",
      "كرفس ",
    ],
    "الحبوب ": [
      "قمح ",
      "شعير ",
      "ذرة ",
      "أرز ",
      "سورغم ",
      "شوفان ",
      "جاودار ",
      "دخن ",
      "كينوا ",
    ],
    "المحاصيل الزيتية ": [
      "زيتون ",
      "لوز ",
      "بندق ",
      "جوز ",
      "بذور عباد الشمس ",
      "بذور السمسم ",
      "بذور الكتان ",
      "بذور اللفت ",
      "فول سوداني ",
    ],
    "البقوليات ": [
      "عدس ",
      "حمص ",
      "فاصوليا بيضاء ",
      "فول ",
      "بازلاء مجففة ",
      "فاصوليا حمراء ",
      "فول الصويا ",
    ],
    "النباتات العطرية و الطبية ": [
      "نعناع ",
      "ريحان ",
      "زعتر ",
      "إكليل الجبل ",
      "بابونج ",
      "لافندر ",
      "مريمية ",
      "بقدونس ",
      "كزبرة ",
    ],
    "الأعلاف ": [
      "برسيم ",
      "تبن ",
      "نفل ",
      "سيلاج الذرة ",
      "سورغم العلفي ",
    ],
  };

  final Map<String, List<String>> equipmentCategories = {
    "الآلات الزراعية ": ["جرار ", "حصادة ", "محراث "],
    "المعدات الزراعية ": [],
    "معدات الري ": ["أنابيب الري ", "رشاشات مياه "],
    "معدات التسميد ": [],
  };

  String? selectedCategorie;
  String? selectedProduit;

  final Map<String, List<String>> wilayas = {
    "01 - Adrar": [
      "Adrar",
      "Aoulef",
      "Reggane",
      "Timimoun",
      "Zaouiet Kounta",
      "Fenoughil",
      "Tsabit",
      "Tinerkouk",
    ],
    "02 - Chlef": [
      "Chlef",
      "Ténès",
      "Abou El Hassane",
      "El Karimia",
      "Ouled Fares",
      "Oued Fodda",
      "Sobha",
      "Beni Haoua",
      "Taougrit",
    ],
    "03 - Laghouat": [
      "Laghouat",
      "Aflou",
      "Brida",
      "Ksar El Hirane",
      "Hassi R'Mel",
      "Aïn Madhi",
      "Oued Morra",
      "Tadjemout",
    ],
    "04 - Oum El Bouaghi": [
      "Oum El Bouaghi",
      "Aïn Beïda",
      "Aïn M'lila",
      "F'kirina",
      "Meskiana",
      "Souk Naamane",
      "Aïn Babouche",
    ],
    "05 - Batna": [
      "Batna",
      "Arris",
      "Barika",
      "Merouana",
      "T'kout",
      "N'gaous",
      "El Madher",
      "Aïn Touta",
      "Ichmoul",
    ],
    "06 - Béjaïa": [
      "Béjaïa",
      "Akbou",
      "Amizour",
      "Sidi Aïch",
      "Tazmalt",
      "Kherrata",
      "El Kseur",
      "Souk El Ténine",
      "Adekar",
    ],
    "07 - Biskra": [
      "Biskra",
      "Tolga",
      "Ourlal",
      "Sidi Okba",
      "El Kantara",
      "Oumache",
      "Lichana",
      "M'Chouneche",
      "Foughala",
    ],
    "08 - Béchar": [
      "Béchar",
      "Kenadsa",
      "Taghit",
      "Lahmar",
      "Abadla",
      "Beni Abbes",
      "Igli",
      "Timoudi",
      "El Ouata",
    ],
    "09 - Blida": [
      "Blida",
      "Boufarik",
      "Bouinan",
      "El Affroun",
      "Mouzaïa",
      "Larbaa",
      "Oued Djer",
      "Chebli",
    ],
    "10 - Bouira": [
      "Bouira",
      "Lakhdaria",
      "Sour El Ghozlane",
      "Kadiria",
      "Haizer",
      "M'Chedallah",
      "Aïn Bessem",
      "El Hachimia",
    ],
    "11 - Tamanrasset": [
      "Tamanrasset",
      "Abalessa",
      "In Guezzam",
      "In Salah",
      "Tazrouk",
      "Tinzaouatine",
    ],
    "12 - Tébessa": [
      "Tébessa",
      "Bir El Ater",
      "Cheria",
      "El Ogla",
      "Negrine",
      "Ouenza",
      "El Aouinet",
    ],
    "13 - Tlemcen": [
      "Tlemcen",
      "Ghazaouet",
      "Maghnia",
      "Nedroma",
      "Remchi",
      "Sebdou",
      "Beni Snous",
      "Bensekrane",
    ],
    "14 - Tiaret": [
      "Tiaret",
      "Frenda",
      "Mahdia",
      "Sougueur",
      "Medroussa",
      "Mechraa Safa",
      "Ksar Chellala",
    ],
    "15 - Tizi Ouzou": [
      "Tizi Ouzou",
      "Azazga",
      "Draa El Mizan",
      "Larbaa Nath Irathen",
      "Boghni",
      "Aïn El Hammam",
      "Tizi Rached",
    ],
    "16 - Alger": [
      "Alger-Centre",
      "Bab El Oued",
      "El Harrach",
      "Bir Mourad Raïs",
      "Hussein Dey",
      "Rouiba",
      "Dar El Beida",
      "Birtouta",
    ],
    "17 - Djelfa": [
      "Djelfa",
      "Aïn Oussera",
      "Hassi Bahbah",
      "Messaad",
      "Charef",
      "El Idrissia",
      "Zaafrane",
    ],
    "18 - Jijel": [
      "Jijel",
      "El Milia",
      "Taher",
      "Texenna",
      "Chekfa",
      "Sidi Maarouf",
      "El Aouana",
    ],
    "19 - Sétif": [
      "Sétif",
      "El Eulma",
      "Aïn Oulmene",
      "Bougaa",
      "Beni Ourtilane",
      "Hammam Guergour",
      "Babor",
    ],
    "20 - Saïda": [
      "Saïda",
      "Aïn El Hadjar",
      "Ouled Brahim",
      "Sidi Boubekeur",
      "Youb",
    ],
    "21 - Skikda": [
      "Skikda",
      "Collo",
      "El Harrouch",
      "Azzaba",
      "Tamalous",
      "Beni Bechir",
      "Ramadan Djamel",
    ],
    "22 - Sidi Bel Abbès": [
      "Sidi Bel Abbès",
      "Tessala",
      "Ben Badis",
      "Sfisef",
      "Mostefa Ben Brahim",
      "Ras El Ma",
    ],
    "23 - Annaba": [
      "Annaba",
      "El Bouni",
      "El Hadjar",
      "Berrahal",
      "Chetaïbi",
      "Seraïdi",
    ],
    "24 - Guelma": [
      "Guelma",
      "Oued Zenati",
      "Bouchegouf",
      "Hammam Debagh",
      "Héliopolis",
      "Nechmaya",
    ],
    "25 - Constantine": [
      "Constantine",
      "Hamma Bouziane",
      "Zighoud Youcef",
      "El Khroub",
      "Aïn Smara",
    ],
    "26 - Médéa": [
      "Médéa",
      "Berrouaghia",
      "Ksar El Boukhari",
      "Tablat",
      "Béni Slimane",
      "Oum El Djellil",
    ],
    "27 - Mostaganem": [
      "Mostaganem",
      "Aïn Nouissy",
      "Bouguirat",
      "Kheïr Eddine",
      "Hassi Mameche",
    ],
    "28 - M'Sila": [
      "M'Sila",
      "Boussaada",
      "Magra",
      "Chellal",
      "Ouled Derradj",
      "Aïn El Hadjel",
    ],
    "29 - Mascara": ["Mascara", "Sig", "Tighennif", "Oued Taria", "Bouhanifia"],
    "30 - Ouargla": ["Ouargla", "Touggourt", "El Hadjira", "Hassi Messaoud"],
    "31 - Oran": [
      "Oran",
      "Es Senia",
      "Arzew",
      "Aïn El Turk",
      "Bir El Djir",
      "Boutlelis",
    ],
    "32 - El Bayadh": [
      "El Bayadh",
      "Bougtoub",
      "Rogassa",
      "Labiodh Sidi Cheikh",
    ],
    "33 - Illizi": ["Illizi", "Djanet", "Debdeb"],
    "34 - Bordj Bou Arreridj": [
      "Bordj Bou Arreridj",
      "El Achir",
      "Medjana",
      "Ras El Oued",
    ],
    "35 - Boumerdès": ["Boumerdès", "Khemis El Khechna", "Dellys", "Naciria"],
    "36 - Tissemsilt": ["Tissemsilt", "Bordj Bounaama", "Theniet El Had"],
    "37 - El Oued": ["El Oued", "Robbah", "Mih Ouensa", "Guemar"],
    "38 - Khenchela": ["Khenchela", "El Hamma", "Kais", "Babar"],
    "39 - Souk Ahras": ["Souk Ahras", "Sedrata", "Taoura", "Drea"],
    "40 - Tipaza": ["Tipaza", "Cherchell", "Gouraya", "Hadjout"],
    "41 - Mila": ["Mila", "Grarem Gouga", "Chelghoum Laïd", "Telerghma"],
    "42 - Aïn Defla": ["Aïn Defla", "Khemis Miliana", "Miliana", "El Abadia"],
    "43 - Naâma": ["Naâma", "Mecheria", "Aïn Sefra", "Tiout"],
    "44 - Aïn Témouchent": [
      "Aïn Témouchent",
      "El Malah",
      "Beni Saf",
      "Hammam Bouhadjar",
    ],
    "45 - Ghardaïa": ["Ghardaïa", "Berriane", "Metlili", "El Menea"],
    "46 - Relizane": ["Relizane", "Oued Rhiou", "Mazouna", "Zemmoura"],
  };

  String? selectedWilaya;
  String? selectedDaira;
  //unite by category

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
                  value: selectedPrimaryCategory,
                  decoration: _dropdownDecoration("Type de produit"),
                  items: primaryCategories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPrimaryCategory = value;
                      selectedCategorie = null;
                      selectedProduit = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a type';
                    }
                    return null;
                  }),
              const SizedBox(height: 15),

              if (selectedPrimaryCategory == "منتوجات فلاحية" ||
                  selectedPrimaryCategory == "معدات")
                  Column(
                    children: [
                                  DropdownButtonFormField<String>(
                    value: selectedCategorie,
                    decoration: _dropdownDecoration("Catégorie"),
                    items: (selectedPrimaryCategory == "منتوجات فلاحية"
                            ? produitsAgricoles.keys
                            : equipmentCategories.keys)
                        .map(
                          (categorie) => DropdownMenuItem(
                            value: categorie,
                            child: Text(categorie),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategorie = value;
                        selectedProduit = null;
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
                
              

              if ((selectedPrimaryCategory == "منتوجات فلاحية" ||
                      selectedPrimaryCategory == "معدات") &&
                  selectedCategorie != null)
                  Column(
                    children: [
                      DropdownButtonFormField<String>(
                  value: selectedProduit,
                  decoration: _dropdownDecoration("Produit"),
                  items: (selectedPrimaryCategory == "منتوجات فلاحية"
                          ? produitsAgricoles[selectedCategorie!]
                          : equipmentCategories[selectedCategorie!])!
                      .map(
                        (produit) => DropdownMenuItem(
                          value: produit,
                          child: Text(produit),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProduit = value;
                    });
                  },
                ),
              const SizedBox(height: 15),
                    ],
                  ),
                

              if (selectedPrimaryCategory == "منتوجات فلاحية")
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

              if (selectedPrimaryCategory == "أراضي")
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
              if (selectedPrimaryCategory == "منتوجات فلاحية" ||
                  selectedPrimaryCategory == "أراضي")
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
                  items: wilayas.keys
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
                    items: wilayas[selectedWilaya]!
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
              if (selectedPrimaryCategory != null &&
                      unitsByCategory.containsKey(selectedPrimaryCategory!))
                    DropdownButtonFormField<String>(
                      value: selectedUnite,
                      decoration: _dropdownDecoration("الوحدة"),
                      items: unitsByCategory[selectedPrimaryCategory]!
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
