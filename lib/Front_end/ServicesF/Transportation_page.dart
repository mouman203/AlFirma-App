import 'package:agriplant/Back_end/ServicesB/TransportService.dart';
import 'package:agriplant/data/ProductData.dart'; // To access wilayas
import 'package:agriplant/widgets_UI/Item_card.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class TransportationPage extends StatefulWidget {
  const TransportationPage({super.key});

  @override
  State<TransportationPage> createState() => _TransportationPageState();
}

class _TransportationPageState extends State<TransportationPage> {
  String selectedWilaya = 'All Wilayas';
  String selectedDaira = 'All Dairas';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transport Services'),
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
                    child: DropdownButton2<String>(
                      iconStyleData: IconStyleData(
                        iconEnabledColor:
                            isDarkMode ? Colors.white : const Color(0xFF256C4C),
                        iconDisabledColor:
                            isDarkMode ? Colors.white : const Color(0xFF256C4C),
                      ),
                      isExpanded: true,
                      value: selectedWilaya,
                      onChanged: (newValue) {
                        setState(() {
                          selectedWilaya = newValue!;
                          selectedDaira =
                              'All Dairas'; // Reset Daira when Wilaya changes
                        });
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton2<String>(
                      iconStyleData: IconStyleData(
                        iconEnabledColor:
                            isDarkMode ? Colors.white : const Color(0xFF256C4C),
                        iconDisabledColor:
                            isDarkMode ? Colors.white : const Color(0xFF256C4C),
                      ),
                      isExpanded: true,
                      value: selectedDaira,
                      items: selectedWilaya == 'All Wilayas'
                          ? [
                              DropdownMenuItem<String>(
                                value: 'All Dairas',
                                child: Text(
                                  'All Dairas',
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
                                  value: 'All Dairas',
                                  child: Text(
                                    'All Dairas',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF256C4C),
                                    ),
                                  ),
                                ),
                              ] +
                              (ProductData.wilayas[selectedWilaya] ?? [])
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
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Featured Transportations",
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
                  return const Center(child: Text("Error fetching data"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No transport services found."));
                }

                var filtered = snapshot.data!.where((s) {
                  return (selectedWilaya == 'All Wilayas' ||
                          s.wilaya == selectedWilaya) &&
                      (selectedDaira == 'All Dairas' ||
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

  // Helper function to map Wilaya code to Wilaya name (you can expand this as needed)
  String getWilayaName(String wilayaWithNumber) {
    return wilayaWithNumber.split(' - ').last; // Split and return only the name
  }
}
