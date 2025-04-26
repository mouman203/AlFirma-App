import 'package:agriplant/Back_end/ServicesB/TransportService.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductTransporteur extends StatefulWidget {
  const AddProductTransporteur({Key? key}) : super(key: key);

  @override
  State<AddProductTransporteur> createState() => _AddProductTransporteurState();
}

class _AddProductTransporteurState extends State<AddProductTransporteur> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController prixController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image;

  bool _isLoading = false;

  String? selectedCategorie;
  String? selectedWilaya;
  String? selectedDaira;
  String? selectedMoyenDeTransport;

  final List<String> categories = ["نقل المواشي", "نقل المحاصيل", "نقل عام"];

  final List<String> moyensDeTransport = [
    "شاحنة صغيرة",
    "شاحنة كبيرة",
    "شاحنة مبردة",
  ];

  void _resetForm() {
    _formKey.currentState?.reset();
    prixController.clear();
    descriptionController.clear();
    setState(() {
      _image = null;
      selectedCategorie = null;
      selectedWilaya = null;
      selectedDaira = null;
    });
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);
    
 if (_selectedImages.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("📸 يُفضل إضافة صورة لتوضيح الخدمة، لكن يمكنك المتابعة بدونها.")),
  );
  // لا ترجع هنا، خليه يكمل عادي
}

    if (_formKey.currentState!.validate()) {
      

      TransportService newService = TransportService(
        id: "", // سيتم تعيينه تلقائيًا في Firestore
        typeService: "Transportation",
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
        moyenDeTransport: selectedMoyenDeTransport,
      );

      await newService.addTransportService(newService);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transport 🚜📦"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade700),
                  ),
                  child: _image == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,
                                  size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text("Appuyez pour ajouter une photo",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!,
                              fit: BoxFit.cover, width: double.infinity),
                        ),
                ),
              ),
              const SizedBox(height: 15),

              //moyen de transport
              ProductData.buildDropdown(selectedValue: selectedMoyenDeTransport, items: moyensDeTransport, label: 'moyen De Transport', onChanged: (value) =>
                    setState(() => selectedMoyenDeTransport = value)),
             

              //type de transport
              ProductData.buildDropdown(selectedValue: selectedCategorie, items: categories, label: 'type de transport', onChanged:  (value) => setState(() => selectedCategorie = value)),
             

              //prix
              ProductData.buildTextField(
                controller: prixController,
                hintText: "السعر",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) => null,
              ),
           

              //wilaya
              ProductData.buildDropdown(selectedValue: selectedWilaya, items: ProductData.wilayas.keys.toList(), label: "Wilaya", onChanged: (value) => setState(() {
                  selectedWilaya = value;
                  selectedDaira = null;
                })),
         

              //daaira
              if (selectedWilaya != null)ProductData.buildDropdown(selectedValue: selectedDaira, items:ProductData.wilayas[selectedWilaya]!, label: "Daira", onChanged: (value) => setState(() => selectedDaira = value),),
         

              //description
              ProductData.buildTextField(
                controller: descriptionController,
                hintText: "الوصف",
                icon: Icons.description,
                maxLines: 4,
                validator: (value) => null,
              ),
          

              SizedBox(
                width: double.infinity,
                height: 50,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _submitForm,
                        child: const Text("نشر",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
