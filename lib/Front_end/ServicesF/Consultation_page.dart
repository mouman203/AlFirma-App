import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:agriplant/generated/l10n.dart';
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
  String? selectedWilaya;
  String? selectedDaira;
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
    .where('userType.Vétérinaire.validation', isEqualTo: 'true')
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
    if (selectedWilaya == S.of(context).all_wilayas) {
      filteredVeterinarians = List.from(allVeterinarians);
    } else {
      filteredVeterinarians = allVeterinarians.where((vet) {
        final vetWilaya = vet['wilaya']?.toString().toLowerCase();
        return vetWilaya == selectedWilaya!.toLowerCase();
      }).toList();
    }

    if (selectedDaira != S.of(context).all_dairas && selectedDaira != null) {
      filteredVeterinarians = filteredVeterinarians.where((vet) {
        final vetDaira = vet['daira']?.toString().toLowerCase();
        return vetDaira == selectedDaira!.toLowerCase();
      }).toList();
    }

    setState(() {});
  }

  List<String> getAvailableDairas(String wilaya) {
    return ProductData.wilayasT(context)[wilaya] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    selectedWilaya ??= S.of(context).all_wilayas;
    selectedDaira ??= S.of(context).all_dairas;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).consultation), // Localized title
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
                    Expanded(
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        value: selectedWilaya,
                        onChanged: (newValue) {
                          setState(() {
                            selectedWilaya = newValue!;
                            selectedDaira = S.of(context).all_dairas;
                          });
                        },
                        decoration: InputDecoration(
                          // Custom border
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF256C4C),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF256C4C),
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        iconStyleData: IconStyleData(
                          iconEnabledColor: isDarkMode
                              ? Colors.white
                              : const Color(0xFF256C4C),
                        ),
                        items: [
                          S.of(context).all_wilayas,
                          ...ProductData.wilayasT(context).keys
                        ]
                            .map((wilaya) => DropdownMenuItem<String>(
                                  value: wilaya,
                                  child: Text(
                                    wilaya == S.of(context).all_wilayas
                                        ? wilaya
                                        : wilaya,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF256C4C),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ))
                            .toList(),
                        selectedItemBuilder: (context) {
                          return [
                            S.of(context).all_wilayas,
                            ...ProductData.wilayasT(context).keys
                          ]
                              .map((wilaya) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      wilaya == S.of(context).all_wilayas
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
                                  ))
                              .toList();
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        value: selectedDaira,
                        items: selectedWilaya == S.of(context).all_wilayas
                            ? [
                                DropdownMenuItem<String>(
                                  value: S.of(context).all_dairas,
                                  child: Text(
                                    S.of(context).all_dairas,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF256C4C),
                                    ),
                                  ),
                                ),
                              ]
                            : [
                                  DropdownMenuItem<String>(
                                    value: S.of(context).all_dairas,
                                    child: Text(
                                      S.of(context).all_dairas,
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : const Color(0xFF256C4C),
                                      ),
                                    ),
                                  ),
                                ] +
                                (ProductData.wilayasT(context)[selectedWilaya] ??
                                        [])
                                    .map((daira) => DropdownMenuItem<String>(
                                          value: daira,
                                          child: Text(
                                            daira,
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : const Color(0xFF256C4C),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedDaira = val!;
                          });
                        },
                        decoration: InputDecoration(
                          // Custom border for second dropdown, same as the first one
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF256C4C),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF256C4C),
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        iconStyleData: IconStyleData(
                          iconEnabledColor: isDarkMode
                              ? Colors.white
                              : const Color(0xFF256C4C),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Veterinarian List
                Expanded(
                  child: filteredVeterinarians.isEmpty
                      ? Center(
                          child: Text(S
                              .of(context)
                              .no_veterinarians_found)) // Localized text
                      : ListView.builder(
                          itemCount: filteredVeterinarians.length,
                          itemBuilder: (context, index) {
                            final vet = filteredVeterinarians[index];
                            final firstName = vet['first_name'] ?? '';
                            final lastName = vet['last_name'] ?? '';
                            final phone = vet['phone'] ?? 'N/A';
                            final wilaya = vet['wilaya'] ?? 'N/A';
                            final profileImage = vet['photo'];
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
                                            : (isDarkMode
                                                    ? const AssetImage(
                                                        "assets/anonymeD.png")
                                                    : const AssetImage(
                                                        "assets/anonyme.png"))
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
                                            Text(
                                              S
                                                  .of(context)
                                                  .veterinaire, // Localized text
                                              style:
                                                  const TextStyle(fontSize: 16),
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
