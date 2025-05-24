import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Meseges/Chat.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:agriplant/data/ProductData.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  String? selectedWilaya;
  String? selectedDaira;
  bool isLoading = false;
  List<Map<String, dynamic>> allVeterinarians = [];
  List<Map<String, dynamic>> filteredVeterinarians = [];
  Map<String, String> translationMap = {}; // Localized to Arabic
  Map<String, String> reverseTranslationMap = {}; // Arabic to localized

  @override
  void initState() {
    super.initState();
    _loadVeterinarians();
  }

  Future<void> _loadVeterinarians() async {
    setState(() => isLoading = true);
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('userType.بيطري.validation', isEqualTo: 'true')
        .get();

    allVeterinarians = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    // Initialize translation maps
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Build both forward and reverse translation maps
        translationMap = ProductData.buildDairaTranslationMap(context);
        // Create reverse mapping (from localized to Arabic)
        reverseTranslationMap = {};
        translationMap.forEach((arabic, localized) {
          reverseTranslationMap[localized] = arabic;
        });
      });
      _filterVeterinarians();
    });

    setState(() => isLoading = false);
  }

  void _filterVeterinarians() {
    if (selectedWilaya == null || selectedWilaya == S.of(context).all_wilayas) {
      filteredVeterinarians = allVeterinarians;
    } else {
      // Convert selected values to Arabic for filtering if needed
      final arabicWilaya =
          reverseTranslationMap[selectedWilaya] ?? selectedWilaya;
      final arabicDaira = selectedDaira == S.of(context).all_dairas
          ? selectedDaira
          : reverseTranslationMap[selectedDaira] ?? selectedDaira;

      filteredVeterinarians = allVeterinarians.where((vet) {
        final wilaya = vet['wilaya'] ?? '';
        final daira = vet['daira'] ?? '';

        // Check if either the Arabic value matches or the translated value matches
        final wilayaMatch = wilaya == arabicWilaya ||
            getLocalizedName(wilaya) == selectedWilaya;

        final dairaMatch = selectedDaira == null ||
            selectedDaira == S.of(context).all_dairas ||
            daira == arabicDaira ||
            getLocalizedName(daira) == selectedDaira;

        return wilayaMatch && dairaMatch;
      }).toList();
    }
    setState(() {});
  }

  String getLocalizedName(String arabicName) {
    return translationMap[arabicName] ?? arabicName;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    selectedWilaya ??= S.of(context).all_wilayas;
    selectedDaira ??= S.of(context).all_dairas;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).consultation,
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 5,
      ),
      // Using CustomScrollView instead of SingleChildScrollView
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(children: [
                    Expanded(
                      child: DropdownButtonFormField2<String>(
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 450,
                          offset: const Offset(0, 0),
                          width: MediaQuery.of(context).size.width - 220,
                          decoration: BoxDecoration(
                            color: colorScheme
                                .secondaryContainer, // Background color for the dropdown menu
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        isExpanded: true,
                        value: selectedWilaya,
                        onChanged: (newValue) {
                          setState(() {
                            selectedWilaya = newValue!;
                            selectedDaira = S.of(context).all_dairas;
                            _filterVeterinarians();
                          });
                        },
                        decoration: InputDecoration(
                          filled: true, // This enables the fill color
                          fillColor: colorScheme
                              .secondaryContainer, // Set your fill color
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
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 450,
                          offset: const Offset(0, 0),
                          width: MediaQuery.of(context).size.width - 220,
                          decoration: BoxDecoration(
                            color: colorScheme
                                .secondaryContainer, // Background color for the dropdown menu
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        isExpanded: true,
                        value: selectedDaira,
                        items: selectedWilaya == S.of(context).all_wilayas
                            ? [
                                DropdownMenuItem<String>(
                                  value: S.of(context).all_dairas,
                                  child: Text(S.of(context).all_dairas,
                                      style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : const Color(0xFF256C4C))),
                                ),
                              ]
                            : [
                                  DropdownMenuItem<String>(
                                    value: S.of(context).all_dairas,
                                    child: Text(S.of(context).all_dairas,
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color(0xFF256C4C))),
                                  ),
                                ] +
                                (ProductData.wilayasT(
                                            context)[selectedWilaya] ??
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
                            _filterVeterinarians();
                          });
                        },
                        decoration: InputDecoration(
                          filled: true, // Enables the background color
                          fillColor: colorScheme
                              .secondaryContainer, // Set your fill color
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
                          iconEnabledColor: isDarkMode
                              ? Colors.white
                              : const Color(0xFF256C4C),
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 16.0),
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
                        S.of(context).our_trusted_veterinarians,
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
              ],
            ),
          ),
          // Loading indicator or empty state message
          if (isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (filteredVeterinarians.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    S.of(context).no_veterinarians_found,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            )
          else
            // List of veterinarians as a SliverList
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final vet = filteredVeterinarians[index];
                    final arabicWilaya = vet['wilaya'] ?? '';
                    final arabicDaira = vet['daira'] ?? '';

                    final localizedWilaya = getLocalizedName(arabicWilaya);
                    final localizedDaira = getLocalizedName(arabicDaira);

                    return VeterinarianCard(
                      firstName: vet['first_name'] ?? '',
                      lastName: vet['last_name'] ?? '',
                      wilaya: localizedWilaya,
                      daira: localizedDaira,
                      profileImageUrl: vet['photo'],
                      vet: vet, // Pass the full vet data
                      onTap: () {
                        // Handle vet tap - navigate to detail page or show contact options
                        // You can implement this later based on your needs
                      },
                    );
                  },
                  childCount: filteredVeterinarians.length,
                ),
              ),
            ),
          // Add some padding at the bottom
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  String getWilayaName(String wilayaWithNumber) {
    return wilayaWithNumber
        .split(' - ')
        .last; // Remove the number and return only the name
  }
}

class VeterinarianCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String wilaya;
  final String daira;
  final String? profileImageUrl;
  final Map<String, dynamic> vet; // Added the full vet data map
  final VoidCallback onTap;

  const VeterinarianCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.wilaya,
    required this.daira,
    this.profileImageUrl,
    required this.vet, // Added this parameter
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: colorScheme.secondaryContainer,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage:
                      (profileImageUrl != null && profileImageUrl!.isNotEmpty)
                          ? NetworkImage(profileImageUrl!)
                          : (isDarkMode
                                  ? const AssetImage("assets/anonymeD.png")
                                  : const AssetImage("assets/anonyme.png"))
                              as ImageProvider,
                ),
              ),
              const SizedBox(width: 16),
              // Veterinarian Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      '$firstName $lastName',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Profession
                    Text(
                      S.of(context).veterinaire,
                      style: TextStyle(
                        color: isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Location - Wilaya
                    Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          size: 18,
                          color: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            wilaya,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Location - Daira
                    Row(
                      children: [
                        Icon(
                          Icons.place,
                          size: 18,
                          color: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            daira,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Contact buttons in a column with defined width
              SizedBox(
                width: 80, // Fixed width for the buttons column
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch, // Make buttons fill the width
                  children: [
                    const SizedBox(height: 50),
                    // Message Button
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          final vetId = vet['id'];
                          if (vetId != null) {
                            if (!Users.isGuestUser()) {
                              /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatPage(receiverId: vetId,product: widget.vet['product'],),
                                ),
                              );*/
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.error_outline,
                                          color: Colors.black),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          S.of(context).loginToMessage,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 247, 234, 117),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                          foregroundColor:
                              isDarkMode ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Icon(IconlyLight.message, size: 24),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Call Button
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          final String? phoneNumber = vet['phone'];
                          if (phoneNumber != null && phoneNumber.isNotEmpty) {
                            final Uri phoneUri =
                                Uri(scheme: 'tel', path: phoneNumber);
                            if (await canLaunchUrl(phoneUri)) {
                              await launchUrl(phoneUri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.error_outline,
                                          color: Colors.black),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          S.of(context).cannotOpenDialer,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 247, 234, 117),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.black),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        S.of(context).noPhoneNumber,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 247, 234, 117),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? const Color(0xFF90D5AE)
                              : const Color(0xFF256C4C),
                          foregroundColor:
                              isDarkMode ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Icon(Icons.call_outlined, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
