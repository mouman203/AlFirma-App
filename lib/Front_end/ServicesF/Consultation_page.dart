import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:agriplant/data/ProductData.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  List<Map<String, dynamic>> allVeterinarians = [];
  List<Map<String, dynamic>> filteredVeterinarians = [];
  String? _selectedWilaya = 'All Wilayas';
  String? _selectedDaira = 'All Dairas';
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
      data['id'] = doc.id;
      return data;
    }).toList();

    _applyFilter();
    setState(() => isLoading = false);
  }

  void _applyFilter() {
    if (_selectedWilaya == 'All Wilayas') {
      filteredVeterinarians = List.from(allVeterinarians);
    } else {
      filteredVeterinarians = allVeterinarians.where((vet) {
        final vetWilaya = vet['wilaya']?.toString().toLowerCase();
        return vetWilaya == _selectedWilaya!.toLowerCase();
      }).toList();
    }

    if (_selectedDaira != 'All Dairas' && _selectedDaira != null) {
      filteredVeterinarians = filteredVeterinarians.where((vet) {
        final vetDaira = vet['daira']?.toString().toLowerCase();
        return vetDaira == _selectedDaira!.toLowerCase();
      }).toList();
    }

    setState(() {});
  }

  List<String> getAvailableDairas(String wilaya) {
    return ProductData.wilayas[wilaya] ?? [];
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
                const SizedBox(height: 12),

                // Wilaya + Daira Filter Row
                Row(
                  children: [
                    // Wilaya Dropdown
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButton2<String>(
                          iconStyleData: IconStyleData(
                            iconEnabledColor: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C),
                            iconDisabledColor: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C),
                          ),
                          isExpanded: true,
                          value: _selectedWilaya,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedWilaya = newValue;
                              _selectedDaira = 'All Dairas';
                            });
                            _applyFilter();
                          },
                          items: ['All Wilayas', ...ProductData.wilayas.keys]
                              .map((wilaya) {
                            return DropdownMenuItem<String>(
                              value: wilaya,
                              child: Text(
                                wilaya,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF256C4C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }).toList(),
                          selectedItemBuilder: (context) {
                            return ['All Wilayas', ...ProductData.wilayas.keys]
                                .map((wilaya) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  wilaya == 'All Wilayas'
                                      ? wilaya
                                      : getWilayaName(wilaya),
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF256C4C),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                    // Daira Dropdown (always shown)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButton2<String>(
                          iconStyleData: IconStyleData(
                            iconEnabledColor: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C),
                            iconDisabledColor: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C),
                          ),
                          isExpanded: true,
                          value: _selectedDaira,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDaira = newValue;
                            });
                            _applyFilter();
                          },
                          items: [
                            'All Dairas',
                            ...(_selectedWilaya != null &&
                                    _selectedWilaya != 'All Wilayas'
                                ? getAvailableDairas(_selectedWilaya!)
                                : ProductData.wilayas.values
                                    .expand((dairas) => dairas)
                                    .toSet()
                                    .toList())
                          ]
                              .map((daira) => DropdownMenuItem<String>(
                                    value: daira,
                                    child: Text(daira, style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF256C4C),
                                ),),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Veterinarian List
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 45,
                                        backgroundImage: profileImage != null
                                            ? NetworkImage(profileImage)
                                            : const AssetImage(
                                                    'assets/anonyme.png')
                                                as ImageProvider,
                                      ),
                                      const SizedBox(width: 16),
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

  String getWilayaName(String wilayaWithNumber) {
    return wilayaWithNumber
        .split(" - ")
        .last; // Remove the number and return only the name
  }
}
