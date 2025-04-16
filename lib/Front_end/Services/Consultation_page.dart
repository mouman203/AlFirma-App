import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  List<Map<String, dynamic>> allVeterinarians = [];
  List<Map<String, dynamic>> filteredVeterinarians = [];

  List<String> wilayaList = [
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

  String? selectedWilaya = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVeterinarians();
  }

  Future<void> _loadVeterinarians() async {
    setState(() => isLoading = true);
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('userType', arrayContains: 'Vétérinaire')
        .get();

    allVeterinarians = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add Firestore document ID
      return data;
    }).toList();

    _applyFilter();
    setState(() => isLoading = false);
  }

  void _applyFilter() {
    if (selectedWilaya == null || selectedWilaya == 'All') {
      filteredVeterinarians = List.from(allVeterinarians);
    } else {
      final selected = selectedWilaya!.split(' - ').last.toLowerCase();
      filteredVeterinarians = allVeterinarians.where((vet) {
        final vetWilaya = vet['wilaya']?.toString().toLowerCase();
        return vetWilaya == selected;
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation'),
        elevation: 5,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        selectedWilaya = value;
                        _applyFilter();
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          selectedWilaya ?? 'Select Wilaya',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF256C4C),
                        ),
                      ],
                    ),
                    itemBuilder: (context) {
                      return wilayaList.map((String wilaya) {
                        return PopupMenuItem<String>(
                          value: wilaya,
                          child: Text(
                            wilaya,
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF256C4C),
                            ),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                Expanded(
                  child: filteredVeterinarians.isEmpty
                      ? const Center(child: Text('No veterinarians found.'))
                      : ListView.builder(
                          itemCount: filteredVeterinarians.length,
                          itemBuilder: (context, index) {
                            final vet = filteredVeterinarians[index];
                            final firstName = vet['first_name'] ?? '';
                            final lastName = vet['last_name'] ?? '';
                            final phone = vet['phone'] ?? 'N/A';
                            final wilaya = vet['wilaya'] ?? 'N/A';
                            final profileImage = vet['profileImage'];
                            final vetId = vet['id'];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      // Profile Image
                                      CircleAvatar(
                                        radius: 45,
                                        backgroundImage: profileImage != null
                                            ? NetworkImage(profileImage)
                                            : const AssetImage(
                                                    'assets/anonyme.png')
                                                as ImageProvider,
                                      ),
                                      const SizedBox(width: 16),
                                      // Information Column
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$firstName $lastName',
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Vétérinaire',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.phone,
                                                  color: Colors.green,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  phone,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Colors.redAccent,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  wilaya,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Send message button
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatPage(receiverId: vetId),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          IconlyBroken.message,
                                          size: 30,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
