import 'package:agriplant/Back_end/Products.dart';
import 'package:agriplant/data/ProductData.dart'; // To access wilayas
import 'package:agriplant/generated/l10n.dart';
import 'package:agriplant/widgets_UI/Item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class TransportationPage extends StatefulWidget {
  const TransportationPage({super.key});

  @override
  State<TransportationPage> createState() => _TransportationPageState();
}

class _TransportationPageState extends State<TransportationPage> {
  String? selectedWilaya;
  String? selectedDaira;

  static Future<List<Products>> getTransportservicesOnce() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('item')
        .doc('Services')
        .collection('Services')
        .where('typeItem', isEqualTo: "النقل")
        .get();

    return snapshot.docs.map(Products.fromFirestore).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // Set localized defaults if not already selected
    selectedWilaya ??= S.of(context).all_wilayas;
    selectedDaira ??= S.of(context).all_dairas;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).transport_service,style:TextStyle(fontWeight: FontWeight.bold)),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField2<String>(
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 450,
                        offset: const Offset(0, 0),
                        width: MediaQuery.of(context).size.width - 220,
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      isExpanded: true,
                      value: selectedWilaya,
                      onChanged: (newValue) {
                        setState(() {
                          selectedWilaya = newValue!;
                          selectedDaira = S.of(context).all_dairas;
                        });
                      },
                      decoration: InputDecoration(
                        fillColor: colorScheme.secondaryContainer,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      iconStyleData: IconStyleData(
                        iconEnabledColor:
                            isDarkMode ? Colors.white : const Color(0xFF256C4C),
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
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 450,
                        offset: const Offset(0, 0),
                        width: MediaQuery.of(context).size.width - 220,
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
                        fillColor: colorScheme.secondaryContainer,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF256C4C),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      iconStyleData: IconStyleData(
                        iconEnabledColor:
                            isDarkMode ? Colors.white : const Color(0xFF256C4C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              child: Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    S.of(context).featured_transportations,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            FutureBuilder<List<Products>>(
              future: getTransportservicesOnce(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(S.of(context).error_fetching_data));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(S.of(context).no_transport_services_found));
                }

                // إنشاء خريطة ترجمة معكوسة: من المعروض إلى العربي
                final translationMap =
                    ProductData.buildDairaTranslationMap(context);
                Map<String, String> reverseTranslationMap(
                    Map<String, String> translationMap) {
                  return translationMap
                      .map((key, value) => MapEntry(value, key));
                }

                final reversedTranslationMap =
                    reverseTranslationMap(translationMap);

                // ترجمة الاختيارات إلى العربية قبل الفلترة
                final selectedWilayaArabic =
                    reversedTranslationMap[selectedWilaya] ?? selectedWilaya;
                final selectedDairaArabic =
                    reversedTranslationMap[selectedDaira] ?? selectedDaira;

                var filtered = snapshot.data!.where((s) {
                  return (selectedWilaya == S.of(context).all_wilayas ||
                          s.wilaya == selectedWilayaArabic) &&
                      (selectedDaira == S.of(context).all_dairas ||
                          s.daira == selectedDairaArabic);
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
                    return ItemCard(item: filtered[index]);
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to extract Wilaya name from "01 - Adrar"
  String getWilayaName(String wilayaWithNumber) {
    return wilayaWithNumber.split(' - ').last;
  }
}
