import 'package:flutter/material.dart';

class ProductData {
  static final Map<String, List<String>> agriCategories = {
    "منتوجات فلاحية": [
      "الفواكه",
      "الخضروات ",
      "الحبوب ",
      "المحاصيل الزيتية ",
      "البقوليات ",
      "النباتات العطرية و الطبية ",
      "الأعلاف ",
    ],
    "معدات": [
      "الآلات الزراعية ",
      "المعدات الزراعية ",
      "معدات الري ",
      "معدات التسميد ",
    ],
    "أراضي": [],
  };

  static final Map<String, List<String>> agriSubCategories = {
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

  static final Map<String, List<String>> equipmentCategories = {
    "الآلات الزراعية ": ["جرار ", "حصادة ", "محراث "],
    "المعدات الزراعية ": [],
    "معدات الري ": ["أنابيب الري ", "رشاشات مياه "],
    "معدات التسميد ": [],
  };

  static final Map<String, List<String>> produitsElevages = {
    "الحيوانات الحية": [
      "أبقار حلوب",
      "أبقار للتسمين",
      "عجول",
      "أغنام (خراف، نعاج)",
      "ماعز (جديان، إناث ماعز)",
      "جمال",
      "خيول",
      "دواجن (دجاج، بط، ديك رومي)",
      "أرانب",
    ],
    "منتجات الألبان ومشتقاتها": [
      "الحليب الطازج (بقري، ماعز، غنم)",
      "الجبن (بلدي، موزاريلا، شيدر)",
      "الزبدة الطبيعية",
      "الياغورت الطبيعي",
      "القشطة",
      "اللبن الرائب",
    ],
    "المنتجات المشتقة من الحيوانات": [
      "الصوف الخام",
      "الجلود الطبيعية (بقر، غنم، ماعز)",
      "العسل الطبيعي",
      "شمع النحل",
      "البيض (بلدي، مزارع)",
      "السماد الطبيعي العضوي",
    ],
    "معدات وأدوات تربية المواشي": [
      "أقفاص وحظائر متنقلة",
      "معالف ومشارب أوتوماتيكية",
      "أجهزة الحلب اليدوية والكهربائية",
      "أدوات القص والتقليم (للحوافر والصوف)",
      "مستلزمات تدفئة الحظائر",
      "أنظمة تهوية وتحكم في الحرارة",
    ],
  };

  static final Map<String, Map<String, List<String>>> productTypeCategories = {
    "AgricolProduct": agriCategories,
    "EleveurProduct": produitsElevages,
  };

  static final Map<String, Map<String, List<String>>> subCategoryDetails = {
    "AgricolProduct": {
      ...agriSubCategories,
      ...equipmentCategories,
    },
    "EleveurProduct": {...produitsElevages},
  };

  static final Map<String, List<String>> wilayas = {
    "01 - Adrar": [
      "Adrar",
      "Aoulef",
      "Reggane",
      "Timimoun",
      "Zaouiet Kounta",
      "Fenoughil",
      "Tsabit",
      "Tinerkouk"
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
      "Taougrit"
    ],
    "03 - Laghouat": [
      "Laghouat",
      "Aflou",
      "Brida",
      "Ksar El Hirane",
      "Hassi R'Mel",
      "Aïn Madhi",
      "Oued Morra",
      "Tadjemout"
    ],
    "04 - Oum El Bouaghi": [
      "Oum El Bouaghi",
      "Aïn Beïda",
      "Aïn M'lila",
      "F'kirina",
      "Meskiana",
      "Souk Naamane",
      "Aïn Babouche"
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
      "Ichmoul"
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
      "Adekar"
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
      "Foughala"
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
      "El Ouata"
    ],
    "09 - Blida": [
      "Blida",
      "Boufarik",
      "Bouinan",
      "El Affroun",
      "Mouzaïa",
      "Larbaa",
      "Oued Djer",
      "Chebli"
    ],
    "10 - Bouira": [
      "Bouira",
      "Lakhdaria",
      "Sour El Ghozlane",
      "Kadiria",
      "Haizer",
      "M'Chedallah",
      "Aïn Bessem",
      "El Hachimia"
    ],
    "11 - Tamanrasset": [
      "Tamanrasset",
      "Abalessa",
      "In Guezzam",
      "In Salah",
      "Tazrouk",
      "Tinzaouatine"
    ],
    "12 - Tébessa": [
      "Tébessa",
      "Bir El Ater",
      "Cheria",
      "El Ogla",
      "Negrine",
      "Ouenza",
      "El Aouinet"
    ],
    "13 - Tlemcen": [
      "Tlemcen",
      "Ghazaouet",
      "Maghnia",
      "Nedroma",
      "Remchi",
      "Sebdou",
      "Beni Snous",
      "Bensekrane"
    ],
    "14 - Tiaret": [
      "Tiaret",
      "Frenda",
      "Mahdia",
      "Sougueur",
      "Medroussa",
      "Mechraa Safa",
      "Ksar Chellala"
    ],
    "15 - Tizi Ouzou": [
      "Tizi Ouzou",
      "Azazga",
      "Draa El Mizan",
      "Larbaa Nath Irathen",
      "Boghni",
      "Aïn El Hammam",
      "Tizi Rached"
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
      "Baraki",
      "Bouzareah",
      "Chéraga",
      "Draria",
      "Zéralda"
    ],
    "17 - Djelfa": [
      "Djelfa",
      "Aïn Oussera",
      "Hassi Bahbah",
      "Messaad",
      "Charef",
      "El Idrissia",
      "Zaafrane",
      "Birine",
      "Dar Chioukh"
    ],
    "18 - Jijel": [
      "Jijel",
      "El Milia",
      "Taher",
      "Texenna",
      "Chekfa",
      "Sidi Maarouf",
      "El Aouana",
      "Settara",
      "Bordj T'har"
    ],
    "19 - Sétif": [
      "Sétif",
      "El Eulma",
      "Aïn Oulmene",
      "Bougaa",
      "Beni Ourtilane",
      "Hammam Guergour",
      "Babor",
      "Guenzet",
      "Aïn Azel"
    ],
    "20 - Saïda": [
      "Saïda",
      "Aïn El Hadjar",
      "Ouled Brahim",
      "Sidi Boubekeur",
      "Youb",
      "El Hassasna",
      "Maamora",
      "Tircine"
    ],
    "21 - Skikda": [
      "Skikda",
      "Collo",
      "El Harrouch",
      "Azzaba",
      "Tamalous",
      "Beni Bechir",
      "Ramadan Djamel",
      "Filfila",
      "Oum Toub"
    ],
    "22 - Sidi Bel Abbès": [
      "Sidi Bel Abbès",
      "Tessala",
      "Ben Badis",
      "Sfisef",
      "Mostefa Ben Brahim",
      "Ras El Ma",
      "Tabia",
      "Telagh"
    ],
    "23 - Annaba": [
      "Annaba",
      "El Bouni",
      "El Hadjar",
      "Berrahal",
      "Chetaïbi",
      "Seraïdi",
      "Aïn Berda",
      "Treat"
    ],
    "24 - Guelma": [
      "Guelma",
      "Oued Zenati",
      "Bouchegouf",
      "Hammam Debagh",
      "Héliopolis",
      "Nechmaya",
      "Aïn Makhlouf",
      "Bouati Mahmoud"
    ],
    "25 - Constantine": [
      "Constantine",
      "Hamma Bouziane",
      "Zighoud Youcef",
      "El Khroub",
      "Aïn Smara",
      "Didouche Mourad",
      "Ibn Ziad"
    ],
    "26 - Médéa": [
      "Médéa",
      "Berrouaghia",
      "Ksar El Boukhari",
      "Tablat",
      "Béni Slimane",
      "Oum El Djellil",
      "El Omaria",
      "Chahbounia"
    ],
    "27 - Mostaganem": [
      "Mostaganem",
      "Aïn Nouissy",
      "Bouguirat",
      "Kheïr Eddine",
      "Hassi Mameche",
      "Mesra",
      "Sidi Ali",
      "Achaacha"
    ],
    "28 - M'Sila": [
      "M'Sila",
      "Boussaada",
      "Magra",
      "Chellal",
      "Ouled Derradj",
      "Aïn El Hadjel",
      "Hammam Dalaa",
      "Sidi Aïssa"
    ],
    "29 - Mascara": [
      "Mascara",
      "Sig",
      "Tighennif",
      "Oued Taria",
      "Bouhanifia",
      "Ghriss",
      "Mohammadia",
      "Aïn Fares"
    ],
    "30 - Ouargla": [
      "Ouargla",
      "Touggourt",
      "El Hadjira",
      "Hassi Messaoud",
      "Sidi Khouiled",
      "Rouissat",
      "N'Goussa"
    ],
    "31 - Oran": [
      "Oran",
      "Es Senia",
      "Arzew",
      "Aïn El Turk",
      "Bir El Djir",
      "Boutlelis",
      "Gdyel",
      "Hassi Bounif"
    ],
    "32 - El Bayadh": [
      "El Bayadh",
      "Bougtoub",
      "Rogassa",
      "Labiodh Sidi Cheikh",
      "Brezina",
      "El Abiodh Sidi Cheikh",
      "Aïn El Orak"
    ],
    "33 - Illizi": ["Illizi", "Djanet", "Debdeb", "Bordj Omar Driss"],
    "34 - Bordj Bou Arréridj": [
      "Bordj Bou Arréridj",
      "El Achir",
      "Medjana",
      "Ras El Oued",
      "Bordj Zemoura",
      "Bir Kasdali",
      "Aïn Taghrout"
    ],
    "35 - Boumerdès": [
      "Boumerdès",
      "Khemis El Khechna",
      "Dellys",
      "Naciria",
      "Boudouaou",
      "Bordj Menaïel",
      "Baghlia"
    ],
    "36 - El Tarf": [
      "El Tarf",
      "Drean",
      "Ben Mhidi",
      "El Kala",
      "Zeramdine",
      "Bouhadjar",
      "Bouteldja",
      "Souarekh"
    ],
    "37 - Tindouf": ["Tindouf", "Oum El Arayes", "El Ouara"],
    "38 - Tissemsilt": [
      "Tissemsilt",
      "Bordj Bounaama",
      "Theniet El Had",
      "Lazharia",
      "Ammari",
      "Layoune",
      "Sidi Slimane"
    ],
    "39 - El Oued": [
      "El Oued",
      "Robbah",
      "Mih Ouensa",
      "Guemar",
      "Debila",
      "Hassani Abdelkrim",
      "Taleb Larbi"
    ],
    "40 - Khenchela": [
      "Khenchela",
      "El Hamma",
      "Kais",
      "Babar",
      "Bouhmama",
      "Aïn Touila",
      "Tamza"
    ],
    "41 - Souk Ahras": [
      "Souk Ahras",
      "Sedrata",
      "Taoura",
      "Drea",
      "Haddada",
      "Mechroha",
      "Ouled Driss"
    ],
    "42 - Tipaza": [
      "Tipaza",
      "Cherchell",
      "Gouraya",
      "Hadjout",
      "Bou Ismail",
      "Kolea",
      "Sidi Amar"
    ],
    "43 - Mila": [
      "Mila",
      "Grarem Gouga",
      "Chelghoum Laïd",
      "Telerghma",
      "Aïn Beida Harriche",
      "Oued Athmania",
      "Tassadane Haddada"
    ],
    "44 - Aïn Defla": [
      "Aïn Defla",
      "Khemis Miliana",
      "Miliana",
      "El Abadia",
      "Boumedfaa",
      "Djelida",
      "Rouina"
    ],
    "45 - Naâma": [
      "Naâma",
      "Mecheria",
      "Aïn Sefra",
      "Tiout",
      "Sfissifa",
      "Moghrar",
      "Asla"
    ],
    "46 - Aïn Témouchent": [
      "Aïn Témouchent",
      "El Malah",
      "Beni Saf",
      "Hammam Bouhadjar",
      "Oulhaca El Gheraba",
      "Aïn El Arbaa",
      "Tamzoura"
    ],
    "47 - Ghardaïa": [
      "Ghardaïa",
      "Berriane",
      "Metlili",
      "El Menea",
      "Zelfana",
      "Dhayet Bendhahoua",
      "Sebseb"
    ],
    "48 - Relizane": [
      "Relizane",
      "Zemmora",
      "Mekla",
      "Oued Rhiou",
      "Ammi Moussa",
      "Mazouna",
      "Sidi M'Hamed Ben Ali"
    ],
    "49 - Timimoun": [
      "Timimoun",
      "Beni Abbès",
      "Talmine",
      "Tinerkouk",
      "Ouled Said",
      "Charouine",
      "Aougrout"
    ],
    "50 - Bordj Badji Mokhtar": ["Bordj Badji Mokhtar", "Timiaouine"],
    "51 - Ouled Djellal": [
      "Ouled Djellal",
      "Aïn Ksar",
      "Sidi Khaled",
      "Doucen"
    ],
    "52 - Béni Abbès": [
      "Béni Abbès",
      "Aïn Sefra",
      "Kerzaz",
      "Igli",
      "Timoudi",
      "El Ouata"
    ],
    "53 - In Salah": ["In Salah", "In Guezzam", "Foggaret Ezzaouia"],
    "54 - In Guezzam": ["In Guezzam", "Tinzaouatine"],
    "55 - Touggourt": ["Touggourt", "Temacine", "Megarine", "Nezla"],
    "56 - Djanet": ["Djanet", "Bordj El Haouas"],
    "57 - El M'Ghair": ["El M'Ghair", "Djamaa", "Sidi Khelil", "Oum Touyour"],
    "58 - El Meniaa": ["El Meniaa", "Hassi Gara", "Mansoura"]
  };

  

  static List<String> getMainCategories(String? productType) {
    return productType != null
        ? productTypeCategories[productType]?.keys.toList() ?? []
        : [];
  }

  static List<String> getSubCategories(String? productType, String? category) {
    if (productType != null && category != null) {
      return productTypeCategories[productType]?[category] ?? [];
    }
    return [];
  }

  static List<String> getProduct(String? productType, String? subCategory) {
    if (productType != null && subCategory != null) {
      return subCategoryDetails[productType]?[subCategory] ?? [];
    }
    return [];
  }

  static List<String> getWilaya() {
    return wilayas.keys.toList();
  }

  //widgets :

  static Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required String? Function(dynamic value) validator,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextField(
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
      ),
      const SizedBox(height: 15)
    ]);
  }

  static Widget buildDropdown({
    required String? selectedValue,
    required List<String> items,
    required String label,
    required void Function(String?) onChanged,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: dropdownDecoration(label),
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a $label';
          }
          return null;
        },
      ),
      const SizedBox(
        height: 15,
      )
    ]);
  }

  static InputDecoration dropdownDecoration(String label) {
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
