import 'package:agriplant/Back_end/RepairService.dart';
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

    final Map<String, List<String>> wilayas = {
    "01 - Adrar": ["Adrar", "Aoulef", "Reggane", "Timimoun", "Zaouiet Kounta", "Fenoughil", "Tsabit", "Tinerkouk"],
  "02 - Chlef": ["Chlef", "Ténès", "Abou El Hassane", "El Karimia", "Ouled Fares", "Oued Fodda", "Sobha", "Beni Haoua", "Taougrit"],
  "03 - Laghouat": ["Laghouat", "Aflou", "Brida", "Ksar El Hirane", "Hassi R'Mel", "Aïn Madhi", "Oued Morra", "Tadjemout"],
  "04 - Oum El Bouaghi": ["Oum El Bouaghi", "Aïn Beïda", "Aïn M'lila", "F'kirina", "Meskiana", "Souk Naamane", "Aïn Babouche"],
  "05 - Batna": ["Batna", "Arris", "Barika", "Merouana", "T'kout", "N'gaous", "El Madher", "Aïn Touta", "Ichmoul"],
  "06 - Béjaïa": ["Béjaïa", "Akbou", "Amizour", "Sidi Aïch", "Tazmalt", "Kherrata", "El Kseur", "Souk El Ténine", "Adekar"],
  "07 - Biskra": ["Biskra", "Tolga", "Ourlal", "Sidi Okba", "El Kantara", "Oumache", "Lichana", "M'Chouneche", "Foughala"],
  "08 - Béchar": ["Béchar", "Kenadsa", "Taghit", "Lahmar", "Abadla", "Beni Abbes", "Igli", "Timoudi", "El Ouata"],
  "09 - Blida": ["Blida", "Boufarik", "Bouinan", "El Affroun", "Mouzaïa", "Larbaa", "Oued Djer", "Chebli"],
  "10 - Bouira": ["Bouira", "Lakhdaria", "Sour El Ghozlane", "Kadiria", "Haizer", "M'Chedallah", "Aïn Bessem", "El Hachimia"],
  "11 - Tamanrasset": ["Tamanrasset", "Abalessa", "In Guezzam", "In Salah", "Tazrouk", "Tinzaouatine"],
  "12 - Tébessa": ["Tébessa", "Bir El Ater", "Cheria", "El Ogla", "Negrine", "Ouenza", "El Aouinet"],
  "13 - Tlemcen": ["Tlemcen", "Ghazaouet", "Maghnia", "Nedroma", "Remchi", "Sebdou", "Beni Snous", "Bensekrane"],
  "14 - Tiaret": ["Tiaret", "Frenda", "Mahdia", "Sougueur", "Medroussa", "Mechraa Safa", "Ksar Chellala"],
  "15 - Tizi Ouzou": ["Tizi Ouzou", "Azazga", "Draa El Mizan", "Larbaa Nath Irathen", "Boghni", "Aïn El Hammam", "Tizi Rached"],
  "16 - Alger": ["Alger-Centre", "Bab El Oued", "El Harrach", "Bir Mourad Raïs", "Hussein Dey", "Rouiba", "Dar El Beida", "Birtouta", "Baraki", "Bouzareah", "Chéraga", "Draria", "Zéralda"],
  "17 - Djelfa": ["Djelfa", "Aïn Oussera", "Hassi Bahbah", "Messaad", "Charef", "El Idrissia", "Zaafrane", "Birine", "Dar Chioukh"],
  "18 - Jijel": ["Jijel", "El Milia", "Taher", "Texenna", "Chekfa", "Sidi Maarouf", "El Aouana", "Settara", "Bordj T'har"],
  "19 - Sétif": ["Sétif", "El Eulma", "Aïn Oulmene", "Bougaa", "Beni Ourtilane", "Hammam Guergour", "Babor", "Guenzet", "Aïn Azel"],
  "20 - Saïda": ["Saïda", "Aïn El Hadjar", "Ouled Brahim", "Sidi Boubekeur", "Youb", "El Hassasna", "Maamora", "Tircine"],
  "21 - Skikda": ["Skikda", "Collo", "El Harrouch", "Azzaba", "Tamalous", "Beni Bechir", "Ramadan Djamel", "Filfila", "Oum Toub"],
  "22 - Sidi Bel Abbès": ["Sidi Bel Abbès", "Tessala", "Ben Badis", "Sfisef", "Mostefa Ben Brahim", "Ras El Ma", "Tabia", "Telagh"],
  "23 - Annaba": ["Annaba", "El Bouni", "El Hadjar", "Berrahal", "Chetaïbi", "Seraïdi", "Aïn Berda", "Treat"],
  "24 - Guelma": ["Guelma", "Oued Zenati", "Bouchegouf", "Hammam Debagh", "Héliopolis", "Nechmaya", "Aïn Makhlouf", "Bouati Mahmoud"],
  "25 - Constantine": ["Constantine", "Hamma Bouziane", "Zighoud Youcef", "El Khroub", "Aïn Smara", "Didouche Mourad", "Ibn Ziad"],
  "26 - Médéa": ["Médéa", "Berrouaghia", "Ksar El Boukhari", "Tablat", "Béni Slimane", "Oum El Djellil", "El Omaria", "Chahbounia"],
  "27 - Mostaganem": ["Mostaganem", "Aïn Nouissy", "Bouguirat", "Kheïr Eddine", "Hassi Mameche", "Mesra", "Sidi Ali", "Achaacha"],
  "28 - M'Sila": ["M'Sila", "Boussaada", "Magra", "Chellal", "Ouled Derradj", "Aïn El Hadjel", "Hammam Dalaa", "Sidi Aïssa"],
  "29 - Mascara": ["Mascara", "Sig", "Tighennif", "Oued Taria", "Bouhanifia", "Ghriss", "Mohammadia", "Aïn Fares"],
  "30 - Ouargla": ["Ouargla", "Touggourt", "El Hadjira", "Hassi Messaoud", "Sidi Khouiled", "Rouissat", "N'Goussa"],
  "31 - Oran": ["Oran", "Es Senia", "Arzew", "Aïn El Turk", "Bir El Djir", "Boutlelis", "Gdyel", "Hassi Bounif"],
  "32 - El Bayadh": ["El Bayadh", "Bougtoub", "Rogassa", "Labiodh Sidi Cheikh", "Brezina", "El Abiodh Sidi Cheikh", "Aïn El Orak"],
  "33 - Illizi": ["Illizi", "Djanet", "Debdeb", "Bordj Omar Driss"],
  "34 - Bordj Bou Arréridj": ["Bordj Bou Arréridj", "El Achir", "Medjana", "Ras El Oued", "Bordj Zemoura", "Bir Kasdali", "Aïn Taghrout"],
  "35 - Boumerdès": ["Boumerdès", "Khemis El Khechna", "Dellys", "Naciria", "Boudouaou", "Bordj Menaïel", "Baghlia"],
  "36 - El Tarf": ["El Tarf", "Drean", "Ben Mhidi", "El Kala", "Zeramdine", "Bouhadjar", "Bouteldja", "Souarekh"],
  "37 - Tindouf": ["Tindouf", "Oum El Arayes", "El Ouara"],
  "38 - Tissemsilt": ["Tissemsilt", "Bordj Bounaama", "Theniet El Had", "Lazharia", "Ammari", "Layoune", "Sidi Slimane"],
  "39 - El Oued": ["El Oued", "Robbah", "Mih Ouensa", "Guemar", "Debila", "Hassani Abdelkrim", "Taleb Larbi"],
"40 - Khenchela": ["Khenchela", "El Hamma", "Kais", "Babar", "Bouhmama", "Aïn Touila", "Tamza"],
"41 - Souk Ahras": ["Souk Ahras", "Sedrata", "Taoura", "Drea", "Haddada", "Mechroha", "Ouled Driss"],
"42 - Tipaza": ["Tipaza", "Cherchell", "Gouraya", "Hadjout", "Bou Ismail", "Kolea", "Sidi Amar"],
"43 - Mila": ["Mila", "Grarem Gouga", "Chelghoum Laïd", "Telerghma", "Aïn Beida Harriche", "Oued Athmania", "Tassadane Haddada"],
"44 - Aïn Defla": ["Aïn Defla", "Khemis Miliana", "Miliana", "El Abadia", "Boumedfaa", "Djelida", "Rouina"],
"45 - Naâma": ["Naâma", "Mecheria", "Aïn Sefra", "Tiout", "Sfissifa", "Moghrar", "Asla"],
"46 - Aïn Témouchent": ["Aïn Témouchent", "El Malah", "Beni Saf", "Hammam Bouhadjar", "Oulhaca El Gheraba", "Aïn El Arbaa", "Tamzoura"],
"47 - Ghardaïa": ["Ghardaïa", "Berriane", "Metlili", "El Menea", "Zelfana", "Dhayet Bendhahoua", "Sebseb"],
"48 - Relizane": ["Relizane", "Zemmora", "Mekla", "Oued Rhiou", "Ammi Moussa", "Mazouna", "Sidi M'Hamed Ben Ali"],
"49 - Timimoun": ["Timimoun", "Beni Abbès", "Talmine", "Tinerkouk", "Ouled Said", "Charouine", "Aougrout"],
"50 - Bordj Badji Mokhtar": ["Bordj Badji Mokhtar", "Timiaouine"],
"51 - Ouled Djellal": ["Ouled Djellal", "Aïn Ksar", "Sidi Khaled", "Doucen"],
"52 - Béni Abbès": ["Béni Abbès", "Aïn Sefra", "Kerzaz", "Igli", "Timoudi", "El Ouata"],
"53 - In Salah": ["In Salah", "In Guezzam", "Foggaret Ezzaouia"],
"54 - In Guezzam": ["In Guezzam", "Tinzaouatine"],
"55 - Touggourt": ["Touggourt", "Temacine", "Megarine", "Nezla"],
"56 - Djanet": ["Djanet", "Bordj El Haouas"],
"57 - El M'Ghair": ["El M'Ghair", "Djamaa", "Sidi Khelil", "Oum Touyour"],
"58 - El Meniaa": ["El Meniaa", "Hassi Gara", "Mansoura"]
};

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
              DropdownButtonFormField<String>(
                  decoration: _dropdownDecoration("اختر نوع الاصلاح"),
                  value: selectedCategorie,
                  items: categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategorie = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a categorie';
                    }
                    return null;
                  }),
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
                    ? const Center(child: CircularProgressIndicator()) // Show progress
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
