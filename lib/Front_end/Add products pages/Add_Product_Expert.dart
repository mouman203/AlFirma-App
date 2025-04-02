import 'package:agriplant/Back_end/ProductElev.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductExpert extends StatefulWidget {
  const AddProductExpert({Key? key}) : super(key: key);

  @override
  State<AddProductExpert> createState() => _AddProductExpertState();
}

class _AddProductExpertState extends State<AddProductExpert> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for input fields

  final TextEditingController imageController = TextEditingController();
  final TextEditingController quantiteController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image;

  bool _isLoading = false; // To show a loading indicator

  Future<void> _submitForm() async {
    if (true) {
      setState(() {
        _isLoading = true;
      });
      // Create a Product object
      ProductElev newProduct = ProductElev(
        //image: imageController.text,
        categorie: selectedCategorie,
        produit: selectedProduit,
        quantite: quantiteController.text.isNotEmpty
            ? double.tryParse(quantiteController.text)
            : null,
        prix: prixController.text.isNotEmpty
            ? int.tryParse(prixController.text)
            : null,
        wilaya: selectedWilaya,
        daira: selectedDaira,
        description: descriptionController.text,
      );

      // Add to Firestore
      await newProduct.addProduct(newProduct);

      // Show success message
      _showSuccessDialog(context);

      // Clear the form
      _formKey.currentState!.reset();
      imageController.clear();
      quantiteController.clear();
      prixController.clear();
      descriptionController.clear();

      setState(() {
        _isLoading = false;
      });
    }
  }

  final Map<String, List<String>> categories = {
    "استشارات الزراعة": [
      "استشارات في الزراعة العضوية",
      "استشارات في الزراعة المستدامة",
      "تحليل التربة",
      "تحليل المياه",
    ],
    "خدمات التوعية والتدريب": [
      " حول تقنيات الزراعة الحديثة",
      "ورش العمل الزراعية",
    ],
    "التكنولوجيا الزراعية": [
      "استشارات في استخدام التكنولوجيا الزراعية",
      "تطبيقات الزراعة الذكية "
    ],
    "خدمات توجيهية للمزارعين": [
      "خطط الزراعة الخاصة بالمزارع",
      "إدارة المحاصيل بشكل فعال",
    ],
    "مراقبة صحة النباتات والحيوانات": [
      "مراقبة الأمراض والآفات الزراعية",
      "الوقاية والتغذية المناسبة للمحاصيل ",
    ],
    "الاستشارات المالية والإدارية": [
      "استشارات في التمويل الزراعي",
      "استشارات في إدارة المزارع",
    ],
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Added Successfully! ✅"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
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
        title: const Text("Agricultural Expert 🌱👨‍🌾"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Back button functionality
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
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
            DropdownButtonFormField<String>(
              value: selectedCategorie,
              decoration: _dropdownDecoration("الاصناف"),
              items: categories.keys
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
            ),
            const SizedBox(height: 15),
            //Produit
            if (selectedCategorie != null)
              DropdownButtonFormField<String>(
                value: selectedProduit,
                decoration: _dropdownDecoration("المنتجات"),
                items: categories[selectedCategorie]!
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

            //prix

            _buildTextField(
              controller: prixController,
              hintText: "السعر",
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                return null;
              },
            ),
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
            ),
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
              child: ElevatedButton(
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
                    print("error $e");
                  }

                  print(
                    "Produit ajouté :$selectedCategorie > $selectedProduit, Wilaya: $selectedWilaya, Daïra: $selectedDaira",
                  );
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
