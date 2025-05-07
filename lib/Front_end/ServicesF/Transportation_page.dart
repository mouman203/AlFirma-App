import 'package:agriplant/Back_end/ServicesB/TransportService.dart';
import 'package:agriplant/data/ProductData.dart'; // To access wilayas
import 'package:agriplant/generated/l10n.dart';
import 'package:agriplant/widgets_UI/Item_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set localized defaults if not already selected
    selectedWilaya ??= S.of(context).all_wilayas;
    selectedDaira ??= S.of(context).all_dairas;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).transport_service),
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
                        iconEnabledColor:
                            isDarkMode ? Colors.white : const Color(0xFF256C4C),
                      ),
                      items: [
                        S.of(context).all_wilayas,
                        ...ProductData.wilayas(context).keys
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
                          ...ProductData.wilayas(context).keys
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
                              (ProductData.wilayas(context)[selectedWilaya] ??
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
            FutureBuilder<List<TransportService>>(
              future: TransportService.getTransportservicesOnce(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(S.of(context).error_fetching_data));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(S.of(context).no_transport_services_found));
                }

                var filtered = snapshot.data!.where((s) {
                  return (selectedWilaya == S.of(context).all_wilayas ||
                          s.wilaya == selectedWilaya) &&
                      (selectedDaira == S.of(context).all_dairas ||
                          s.daira == selectedDaira);
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
