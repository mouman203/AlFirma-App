import 'package:agriplant/Back_end/RepairService.dart';
import 'package:agriplant/widgets_UI/service_card.dart';
import 'package:flutter/material.dart';

class RepairsPage extends StatefulWidget {
  const RepairsPage({super.key});

  @override
  State<RepairsPage> createState() => _RepairsPageState();
}

class _RepairsPageState extends State<RepairsPage> {
  String selectedWilaya = 'All';
  String selectedDaira = 'All';

  List<String> Wilaya = [
    'All',
    '01 - Adrar',
    '02 - Chlef',
    '03 - Laghouat',
    '04 - Oum El Bouaghi',
    '05 - Batna',
    '06 - Béjaïa',
    '07 - Biskra',
    '08 - Béchar',
    '09 - Blida',
    '10 - Bouira',
    '11 - Tamanrasset',
    '12 - Tébessa',
    '13 - Tlemcen',
    '14 - Tiaret',
    '15 - Tizi Ouzou',
    '16 - Alger',
    '17 - Djelfa',
    '18 - Jijel',
    '19 - Sétif',
    '20 - Saïda',
    '21 - Skikda',
    '22 - Sidi Bel Abbès',
    '23 - Annaba',
    '24 - Guelma',
    '25 - Constantine',
    '26 - Médéa',
    '27 - Mostaganem',
    '28 - M\'Sila',
    '29 - Mascara',
    '30 - Ouargla',
    '31 - Oran',
    '32 - El Bayadh',
    '33 - Illizi',
    '34 - Bordj Bou Arréridj',
    '35 - Boumerdès',
    '36 - El Tarf',
    '37 - Tindouf',
    '38 - Tissemsilt',
    '39 - El Oued',
    '40 - Khenchela',
    '41 - Souk Ahras',
    '42 - Tipaza',
    '43 - Mila',
    '44 - Aïn Defla',
    '45 - Naâma',
    '46 - Aïn Témouchent',
    '47 - Ghardaïa',
    '48 - Relizane',
    '49 - Timimoun',
    '50 - Bordj Badji Mokhtar',
    '51 - Ouled Djellal',
    '52 - Béni Abbès',
    '53 - In Salah',
    '54 - In Guezzam',
    '55 - Touggourt',
    '56 - Djanet',
    '57 - El M\'Ghair',
    '58 - El Meniaa',
  ];

  final Map<String, List<String>> DairaByWilayas = {
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair Services'),
        elevation: 5,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    iconDisabledColor:
                        isDarkMode ? Colors.white : const Color(0xFF256C4C),
                    iconEnabledColor:
                        isDarkMode ? Colors.white : const Color(0xFF256C4C),
                    isExpanded: true,
                    value: selectedWilaya,
                    items: Wilaya.map((w) {
                      return DropdownMenuItem(
                          value: w,
                          child: Text(w,
                              style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF256C4C))));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedWilaya = val!;
                        selectedDaira =
                            'All'; // Reset Daira to 'All' when Wilaya changes
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    iconDisabledColor:
                        isDarkMode ? Colors.white : const Color(0xFF256C4C),
                    iconEnabledColor:
                        isDarkMode ? Colors.white : const Color(0xFF256C4C),
                    isExpanded: true,
                    value: selectedDaira,
                    items: selectedWilaya == 'All'
                        ? [
                            DropdownMenuItem(
                                value: 'All',
                                child: Text('All',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF256C4C),
                                    )))
                          ]
                        : [
                              DropdownMenuItem(
                                  value: 'All',
                                  child: Text('All',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : const Color(0xFF256C4C),
                                      )))
                            ] +
                            (DairaByWilayas[selectedWilaya] ?? [])
                                .map((v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(
                                      v,
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : const Color(0xFF256C4C),
                                      ),
                                    )))
                                .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedDaira = val!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Row(
              children: [
                const Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey, // or Theme.of(context).dividerColor
                  ),
                ),
                const SizedBox(
                    width: 12), // Space between the divider and the text
                Text(
                  "Featured Repairs",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                    width: 12), // Space between the text and the second divider
                const Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey, // or Theme.of(context).dividerColor
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: FutureBuilder<List<RepairService>>(
              future: RepairService.getRepairServicesOnce(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error fetching data"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No Repair services found."));
                }

                // Filter the data based on the selected Wilaya and Daira
                var filtered = snapshot.data!.where((s) {
                  return (selectedWilaya == 'All' ||
                          s.wilaya == selectedWilaya) &&
                      (selectedDaira == 'All' || s.daira == selectedDaira);
                }).toList();

                return GridView.builder(
                  itemCount: filtered.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return ServiceCard(service: filtered[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
