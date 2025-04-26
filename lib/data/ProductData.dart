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
      "Aougrout",
      "Bordj Badji Mokhtar",
      "Charouine",
      "Fenoughil",
      "Reggane",
      "Timimoun",
      "Tinerkouk",
      "Tsabit",
      "Zaouiet Kounta"
    ],
    "02 - Chlef": [
      "Abou El Hassan",
      "Aïn Merane",
      "Beni Haoua",
      "Boukadir",
      "Chlef",
      "El Karimia",
      "El Marsa",
      "Oued Fodda",
      "Ouled Ben Abdelkader",
      "Ouled Fares",
      "Taougrit",
      "Ténès",
      "Zeboudja",
    ],
    "03 - Laghouat": [
      "Aflou",
      "Aïn Madhi",
      "Brida",
      "El Ghicha",
      "Gueltet Sidi Saâd",
      "Hassi R'Mel",
      "Ksar El Hirane",
      "Laghouat",
      "Oued Morra",
      "Sidi Makhlouf"
    ],
    "04 - Oum El Bouaghi": [
      "Oum El Bouaghi",
      "Aïn Babouche",
      "Ksar Sbahi",
      "Aïn Beïda",
      "Fkirina",
      "Aïn M'lila",
      "Souk Naamane",
      "Aïn Fakroun",
      "Sigus",
      "Aïn Kercha",
      "Meskiana",
      "Dhalaa",
    ],
    "05 - Batna": [
      "Aïn Djasser",
      "Aïn Touta",
      "Arris",
      "Barika",
      "Batna",
      "Bouzina",
      "Chemora",
      "Djezzar",
      "El Madher",
      "Ichmoul",
      "Menaa",
      "Merouana",
      "N'Gaous",
      "Ouled Si Slimane",
      "Ras El Aioun",
      "Seggana",
      "Seriana",
      "Tazoult",
      "Teniet El Abed",
      "Timgad",
      "T'kout"
    ],
    "06 - Béjaïa": [
      "Adekar",
      "Akbou",
      "Amizour",
      "Aokas",
      "Barbacha",
      "Béjaïa",
      "Beni Maouche",
      "Chemini",
      "Darguina",
      "El Kseur",
      "Ighil Ali",
      "Kherrata",
      "Ouzellaguen",
      "Seddouk",
      "Sidi-Aïch",
      "Souk El Ténine",
      "Tazmalt",
      "Tichy",
      "Timezrit"
    ],
    "07 - Biskra": [
      "Biskra",
      "Djemorah",
      "El Kantara",
      "M'Chouneche",
      "Sidi Okba",
      "Zeribet El Oued",
      "Ourlal",
      "Tolga",
      "Ouled Djellal",
      "Sidi Khaled",
      "Foughala",
      "El Outaya"
    ],
    "08 - Béchar": [
      "Béchar",
      "Beni Ounif",
      "Lahmar",
      "Kenadsa",
      "Taghit",
      "Abadla",
      "Tabelbala",
      "Igli",
      "Beni Abbes",
      "El Ouata",
      "Kerzaz",
      "Ouled Khoudir"
    ],
    "09 - Blida": [
      "Blida",
      "Boufarik",
      "Bougara",
      "Bouinan",
      "El Affroun",
      "Larbaa",
      "Meftah",
      "Mouzaïa",
      "Oued Alleug",
      "Ouled Yaich"
    ],
    "10 - Bouira": [
      "Bouira",
      "Haizer",
      "Bechloul",
      "M'Chedallah",
      "Kadiria",
      "Lakhdaria",
      "Bir Ghbalou",
      "Ain Bessam",
      "Souk El Khemis",
      "El Hachimia",
      "Sour El Ghozlane",
      "Bordj Okhriss"
    ],
    "11 - Tamanrasset": [
      "Abalessa",
      "In Ghar",
      "In Guezzam",
      "In Salah",
      "Tamanrasset",
      "Tazrouk",
      "Tinzaouten"
    ],
    "12 - Tébessa": [
      "Tébessa",
      "El Kouif",
      "Morsott",
      "El Ma Labiodh",
      "El Aouinet",
      "Ouenza",
      "Bir Mokkadem",
      "Bir El-Ater",
      "El Ogla",
      "Oum Ali",
      "Negrine",
      "Cheria"
    ],
    "13 - Tlemcen": [
      "Aïn Tallout",
      "Bab El Assa",
      "Beni Boussaid",
      "Beni Snous",
      "Bensekrane",
      "Chetouane",
      "El Aricha",
      "Fellaoucene",
      "Ghazaouet",
      "Hennaya",
      "Honaïne",
      "Maghnia",
      "Mansourah",
      "Marsa Ben M'Hidi",
      "Nedroma",
      "Ouled Mimoun",
      "Remchi",
      "Sabra",
      "Sebdou",
      "Sidi Djillali",
      "Tlemcen"
    ],
    "14 - Tiaret": [
      "Tiaret",
      "Sougueur",
      "Aïn Deheb",
      "Aïn Kermes",
      "Frenda",
      "Dahmouni",
      "Mahdia",
      "Hamadia",
      "Ksar Chellala",
      "Medroussa",
      "Mechraa Safa",
      "Rahouia",
      "Oued Lilli",
      "Meghila"
    ],
    "15 - Tizi Ouzou": [
      "Ain El Hammam",
      "Azazga",
      "Azeffoun",
      "Beni Douala",
      "Beni Yenni",
      "Boghni",
      "Bouzguen",
      "Draâ Ben Khedda",
      "Draâ El Mizan",
      "Iferhounène",
      "Larbaâ Nath Irathen",
      "Mâatkas",
      "Makouda",
      "Mekla",
      "Ouacif",
      "Ouadhia",
      "Ouaguenoun",
      "Tigzirt",
      "Tizi Gheniff",
      "Tizi Ouzou",
      "Tizi Rached"
    ],
    "16 - Alger": [
      "Zéralda",
      "Chéraga",
      "Draria",
      "Bir Mourad Raïs",
      "Birtouta",
      "Bouzareah",
      "Bab El Oued",
      "Sidi M'Hamed",
      "Hussein Dey",
      "El Harrach",
      "Baraki",
      "Dar El Beïda",
      "Rouïba"
    ],
    "17 - Djelfa": [
      "Aïn El Ibel",
      "Aïn Oussara",
      "Birine",
      "Charef",
      "Dar Chioukh",
      "Djelfa",
      "El Idrissia",
      "Faidh El Botma",
      "Had-Sahary",
      "Hassi Bahbah",
      "Sidi Ladjel",
      "Messaad"
    ],
    "18 - Jijel": [
      "Chekfa",
      "Djimla",
      "El Ancer",
      "El Aouana",
      "El Milia",
      "Jijel",
      "Settara",
      "Sidi Maarouf",
      "Taher",
      "Texenna",
      "Ziama Mansouriah"
    ],
    "19 - Sétif": [
      "Aïn Arnat",
      "Aïn Azel",
      "Aïn El Kebira",
      "Aïn Oulmene",
      "Amoucha",
      "Babor",
      "Beni Aziz",
      "Beni Ourtilane",
      "Bir El Arch",
      "Bouandas",
      "Bougaa",
      "Djemila",
      "El Eulma",
      "Guidjel",
      "Guenzet",
      "Hammam Guergour",
      "Hammam Soukhna",
      "Maoklane",
      "Salah Bey",
      "Sétif"
    ],
    "20 - Saïda": [
      "Saïda",
      "Aïn El Hadjar",
      "Sidi Boubekeur",
      "El Hassasna",
      "Ouled Brahim",
      "Youb",
    ],
    "21 - Skikda": [
      "Azzaba",
      "Aïn Kechra",
      "Ben Azzouz",
      "Collo",
      "El Hadaiek",
      "El Harrouch",
      "Ouled Attia",
      "Oum Toub",
      "Ramdane Djamel",
      "Sidi Mezghiche",
      "Skikda",
      "Tamalous",
      "Zitouna"
    ],
    "22 - Sidi Bel Abbès": [
      "Sidi Bel Abbès",
      "Aïn el Berd",
      "Ben Badis",
      "Marhoum",
      "Merine",
      "Mostefa Ben Brahim",
      "Moulay Slissen",
      "Ras El Ma",
      "Sfisef",
      "Sidi Ali Benyoub",
      "Sidi Ali Boussidi",
      "Sidi Lahcene",
      "Telagh",
      "Tenira",
      "Tessala"
    ],
    "23 - Annaba": [
      "Annaba",
      "Aïn Berda",
      "El Hadjar",
      "Berrahal",
      "Chetaïbi",
      "El Bouni",
    ],
    "24 - Guelma": [
      "Aïn Makhlouf",
      "Bouchegouf",
      "Guelaât Bou Sbaâ",
      "Guelma",
      "Hammam Debagh",
      "Hammam N'Bails",
      "Héliopolis",
      "Houari Boumédiène",
      "Khezarra",
      "Oued Zenati"
    ],
    "25 - Constantine": [
      "Constantine",
      "El Khroub",
      "Aïn Abid",
      "Zighoud Youcef",
      "Hamma Bouziane",
      "Ibn Ziad"
    ],
    "26 - Médéa": [
      "Aïn Boucif",
      "Aziz",
      "Beni Slimane",
      "Berrouaghia",
      "Chahbounia",
      "Chellalet El Adhaoura",
      "El Azizia",
      "El Guelb El Kebir",
      "El Omaria",
      "Ksar Boukhari",
      "Médéa",
      "Ouamri",
      "Ouled Antar",
      "Ouzera",
      "Seghouane",
      "Sidi Naâmane",
      "Si Mahdjoub",
      "Souagui",
      "Tablat"
    ],
    "27 - Mostaganem": [
      "Achaacha",
      "Ain Nouissi",
      "Ain Tadles",
      "Bouguirat",
      "Hassi Mameche",
      "Kheireddine",
      "Mesra",
      "Mostaganem",
      "Sidi Ali",
      "Sidi Lakhdar"
    ],
    "28 - M'Sila": [
      "M'Sila",
      "Hammam Dalaa",
      "Ouled Derradj",
      "Sidi Aissa",
      "Aïn El Melh",
      "Ben Srour",
      "Bou Saada",
      "Ouled Sidi Brahim",
      "Sidi Ameur",
      "Magra",
      "Chellal",
      "Khoubana",
      "Medjedel",
      "Aïn El Hadjel",
      "Djebel Messaad"
    ],
    "29 - Mascara": [
      "Aïn Fares",
      "Aïn Fekan"
          "Aouf",
      "Bou Hanifia",
      "El Bordj",
      "Ghriss",
      "Hachem",
      "Mascara",
      "Mohammadia",
      "Oggaz",
      "Oued El Abtal",
      "Oued Taria",
      "Sig",
      "Tighennif",
      "Tizi",
      "Zahana",
    ],
    "30 - Ouargla": [
      "El Borma",
      "El Hadjira",
      "Hassi Messaoud",
      "Megarine",
      "N'Goussa"
          "Ouargla",
      "Sidi Khouiled",
      "Taibet",
      "Tamacine",
      "Touggourt",
    ],
    "31 - Oran": [
      "Oran",
      "Aïn El Turk",
      "Arzew",
      "Bethioua",
      "Es Sénia",
      "Bir El Djir",
      "Boutlélis",
      "Oued Tlelat",
      "Gdyel"
    ],
    "32 - El Bayadh": [
      "El Bayadh",
      "Rogassa",
      "Brezina",
      "El Abiodh Sidi Cheikh",
      "Bougtoub",
      "Chellala",
      "Boussemghoun",
      "Boualem"
    ],
    "33 - Illizi": ["Illizi", "Djanet", "In Amenas"],
    "34 - Bordj Bou Arréridj": [
      "Bordj Bou Arreridj",
      "Aïn Taghrout",
      "Ras El Oued",
      "Bordj Ghedir",
      "Bir Kasdali",
      "El Hamadia",
      "Mansoura",
      "Medjana",
      "Bordj Zemoura",
      "Djaafra"
    ],
    "35 - Boumerdès": [
      "Baghlia",
      "Boudouaou",
      "Bordj Ménaïel",
      "Boumerdès",
      "Dellys",
      "Khemis El Kechna",
      "Isser",
      "Naciria",
      "Thenia"
    ],
    "36 - El Tarf": [
      "El Tarf",
      "El Kala",
      "Ben Mhidi",
      "Besbes",
      "Dréan",
      "Bouhadjar",
      "Bouteldja",
    ],
    "37 - Tindouf": ["Tindouf"],
    "38 - Tissemsilt": [
      "Ammari",
      "Bordj Bou Naama",
      "Bordj El Emir Abdelkader",
      "Khemisti",
      "Lardjem",
      "Lazharia",
      "Theniet El Had",
      "Tissemsilt",
    ],
    "39 - El Oued": [
      "Bayadha",
      "Debila",
      "El Oued",
      "Guemar",
      "Hassi Khalifa",
      "Magrane",
      "Mih Ouensa",
      "Reguiba",
      "Robbah",
      "Taleb Larbi"
    ],
    "40 - Khenchela": [
      "Khenchela",
      "Babar",
      "Bouhmama",
      "Chechar",
      "El Hamma",
      "Kais",
      "Ouled Rechache",
      "Aïn Touila",
    ],
    "41 - Souk Ahras": [
      "Bir Bou Haouch",
      "Heddada",
      "M'daourouch",
      "Mechroha",
      "Merahna",
      "Ouled Driss",
      "Oum El Adhaim",
      "Sedrata",
      "Souk Ahras",
      "Taoura"
    ],
    "42 - Tipaza": [
      "Ahmar El Ain",
      "Bou Ismail",
      "Cherchell",
      "Damous",
      "Fouka",
      "Gouraya",
      "Hadjout",
      "Kolea",
      "Sidi Amar",
      "Tipaza",
    ],
    "43 - Mila": [
      "Mila",
      "Chelghoum Laid",
      "Ferdjioua",
      "Grarem Gouga",
      "Oued Endja",
      "Rouached",
      "Terrai Bainen",
      "Tassadane Haddada",
      "Aïn Beida Harriche",
      "Sidi Merouane",
      "Teleghma",
      "Bouhatem",
      "Tadjenanet"
    ],
    "44 - Aïn Defla": [
      "Aïn Defla",
      "Aïn Lechiekh",
      "Bathia",
      "Bordj Emir Khaled",
      "Boumedfaa",
      "Djelida",
      "Djendel",
      "El Abadia",
      "El Amra",
      "El Attaf",
      "Hammam Righa",
      "Khemis Miliana",
      "Miliana",
      "Rouina"
    ],
    "45 - Naâma": [
      "Naâma",
      "Aïn Sefra",
      "Assela",
      "Makman Ben Amer",
      "Mecheria",
      "Moghrar",
      "Sfissifa",
    ],
    "46 - Aïn Témouchent": [
      "Aïn El Arbaa",
      "Ain Kihal",
      "Aïn Témouchent",
      "Beni Saf",
      "El Amria",
      "El Malah",
      "Hammam Bou Hadjar",
      "Oulhaça El Gheraba"
    ],
    "47 - Ghardaïa": [
      "Ghardaïa",
      "El Meniaa",
      "Metlili",
      "Berriane",
      "Daïa Ben Dahoua",
      "Mansoura "
          "Zelfana",
      "Guerrara",
      "Bounoura"
    ],
    "48 - Relizane": [
      "Aïn Tarek",
      "Ammi Moussa",
      "Djidioua",
      "El Hamadna",
      "El Matmar",
      "Mazouna",
      "Mendes",
      "Oued Rhiou",
      "Ramka",
      "Relizane",
      "Sidi M'Hamed Ben Ali",
      "Yellel",
      "Zemmora"
    ],
    "49 - Timimoun": [
      "Timimoun",
      "Aougrout",
      "Tinerkouk",
      "Charouine",
    ],
    "50 - Bordj Badji Mokhtar": ["Bordj Badji Mokhtar"],
    "51 - Ouled Djellal": [
      "Ouled Djellal",
      "Sidi Khaled",
    ],
    "52 - Béni Abbès": [
      "Béni Abbès",
      "Kerzaz",
      "El Ouata",
      "Tabelbala",
      "Igli",
      "Ouled Khoudir",
      "Timoudi",
    ],
    "53 - In Salah": ["In Salah", "In Ghar"],
    "54 - In Guezzam": ["In Guezzam", "Tin Zaouatine"],
    "55 - Touggourt": [
      "El Hadjira",
      "Megarine",
      "Taibet",
      "Temacine",
      "Touggourt"
    ],
    "56 - Djanet": ["Djanet"],
    "57 - El M'Ghair": ["El M'Ghair", "Djamaa"],
    "58 - El Meniaa": ["El Meniaa"]
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
