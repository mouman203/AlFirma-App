import 'package:agriplant/Front_end/Home/Document_page.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';

// List of all possible user types in Arabic - these are the keys stored in Firebase
final Map<String, dynamic> userTypes = {
  'فلاح': {},
  'مربي الماشية': {},
  'خبير زراعي': {},
  'بيطري': {},
  'شركة': {},
  'ناقل': {},
  'مصلح': {},
  'تاجر': {},
};

// Emoji map using Arabic keys
final emojiMap = {
  'فلاح': '👨🏽‍🌾',
  'مربي الماشية': '🐮',
  'خبير زراعي': '🕵🏼',
  'بيطري': '💉',
  'شركة': '🏢',
  'ناقل': '🛻',
  'مصلح': '👨🏻‍🔧',
  'تاجر': '🛍️',
};

// Map from localized strings to Arabic keys - for displaying the correct label but saving the Arabic key
Map<String, String> TranslatedToArabicMap(BuildContext context) {
  return {
    S.of(context).agriculteur: 'فلاح',
    S.of(context).eleveur: 'مربي الماشية',
    S.of(context).expertAgri: 'خبير زراعي',
    S.of(context).veterinaire: 'بيطري',
    S.of(context).entreprise: 'شركة',
    S.of(context).transporteur: 'ناقل',
    S.of(context).reparateur: 'مصلح',
    S.of(context).commercant: 'تاجر',
  };
}

// Map from Arabic keys to localized strings - for displaying in the UI based on Arabic keys from Firebase
Map<String, String> ArabicToTranslatedMap(BuildContext context) {
  return {
    'فلاح': S.of(context).agriculteur,
    'مربي الماشية': S.of(context).eleveur,
    'خبير زراعي': S.of(context).expertAgri,
    'بيطري': S.of(context).veterinaire,
    'شركة': S.of(context).entreprise,
    'ناقل': S.of(context).transporteur,
    'مصلح': S.of(context).reparateur,
    'تاجر': S.of(context).commercant,
  };
}

Future<void> addUserTypeNoDoc(String userType) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);
      final snapshot = await docRef.get();

      Map<String, dynamic> currentTypes =
          Map<String, dynamic>.from(snapshot.data()?['userType'] ?? {});

      if (!currentTypes.containsKey(userType)) {
        currentTypes[userType] = {
          'createdAt': FieldValue.serverTimestamp(),
          // تضيف حقول حسب الحاجة
        };

        await docRef.update({'userType': currentTypes, 'activeType': userType});
      }
    }
  } catch (e) {
    print("there is a problem 'function userType' $e");
  }
}

void showSuccessPopup(BuildContext context, String translatedType) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        title: Text(
          S.of(context).congratulations,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        content: Text(
          "${S.of(context).successMessage} $translatedType!",
          style: const TextStyle(fontSize: 18),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              S.of(context).ok,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showAlertsPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        title: Text(
          S.of(context).alert,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.red,
          ),
        ),
        content: Text(
          S.of(context).alertMessage,
          style: const TextStyle(fontSize: 18),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              S.of(context).ok,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<Map<String, dynamic>> fetchUserTypesAndActive() async {
  final user = FirebaseAuth.instance.currentUser;
  final docRef = FirebaseFirestore.instance.collection('Users').doc(user?.uid);
  final docSnapshot = await docRef.get();

  if (!docSnapshot.exists) {
    print("❌ User document not found.");
    return {'userType': <String>[], 'activeType': 'عميل'};
  }

  final data = docSnapshot.data()!;
  Map<String, dynamic> typesMap =
      Map<String, dynamic>.from(data['userType'] ?? {});
  List<String> types = typesMap.keys.toList();
  String? type = data['activeType'];

  if (types.isEmpty) {
    type = 'عميل'; // Set only the activeType to 'عميل'
    await docRef.update({'activeType': type});
    print("⚠️ userType was empty. Set only activeType to 'عميل'");
  }

  print("✅ Fetched from Firestore:");
  print("userType keys: $types");
  print("activeType: $type");

  return {'userType': types, 'activeType': type};
}

Future<void> saveUserData(List<String> selectedTypes, String activeType) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList('userType', selectedTypes);
  prefs.setString('activeType', activeType);
}

// Set the active user type for the user (main type they are using)
Future<void> setActiveType(String activeType) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({
        'activeType': activeType, // Setting the active user type
      });
      print("Active type updated to $activeType");
    }
  } catch (e) {
    print("Error setting active type: $e");
  }
}

Object getDocumentPageForType(BuildContext context, String arabicType) {
  // Use Arabic keys directly for comparison rather than translated strings
  switch (arabicType) {
    case 'بيطري':
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DocumentPage(userType: 'بيطري'),
        ),
      );
    case 'خبير زراعي':
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DocumentPage(userType: 'خبير زراعي'),
        ),
      );
    case 'شركة':
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DocumentPage(userType: 'شركة'),
        ),
      );
    case 'ناقل':
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DocumentPage(userType: 'ناقل'),
        ),
      );
    case 'مصلح':
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DocumentPage(userType: 'مصلح'),
        ),
      );
    case 'تاجر':
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DocumentPage(userType: 'تاجر'),
        ),
      );
    default:
      return Null;
  }
}

class BecomeTypeAction extends StatefulWidget {
  final VoidCallback onTypeChanged;

  const BecomeTypeAction({Key? key, required this.onTypeChanged})
      : super(key: key);

  @override
  State<BecomeTypeAction> createState() => _BecomeTypeActionState();
}

class _BecomeTypeActionState extends State<BecomeTypeAction> {
  List<String> selectedTypes = []; // These are Arabic keys from Firebase
  String? activeType; // This is Arabic key from Firebase

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    final result = await fetchUserTypesAndActive();

    if (!mounted) return; // Prevent setState after widget is disposed

    setState(() {
      selectedTypes = result['userType'];
      activeType = result['activeType'];

      // Ensure the activeType is at the top of the selectedTypes list
      if (selectedTypes.contains(activeType)) {
        selectedTypes.remove(activeType); // Remove it from its current position
        selectedTypes.insert(
            0, activeType!); // Insert it at the top (first position)
      }
    });

    await saveUserData(selectedTypes, activeType!);
  }

  Future<void> deleteUserTypeKey(String keyToDelete) async {
    try {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user is currently logged in.");
      }

      // Reference the user's document in Firestore
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);

      // Delete the specific key from the userType map
      await userDocRef.update({
        'userType.$keyToDelete': FieldValue.delete(),
      });

      print("Key '$keyToDelete' successfully deleted from userType.");

      // Re-fetch updated user types
      final updatedData = await userDocRef.get();
      final typesMap = Map<String, dynamic>.from(updatedData['userType'] ?? {});
      final updatedTypes = typesMap.keys.toList();

      // Check for validity of first remaining type (if any)
      final isValid = updatedTypes.isNotEmpty
          ? await getValidation(updatedTypes.first) ?? false
          : false;

      // Update activeType logic
      if (updatedTypes.isEmpty || !isValid) {
        await setActiveType('عميل');
        widget.onTypeChanged();
      } else if (activeType == keyToDelete) {
        await setActiveType(updatedTypes.first);
        widget.onTypeChanged();
      }

      widget.onTypeChanged(); // Always notify changes

      print('Updated selectedTypes: $updatedTypes');
    } catch (e) {
      print("Error deleting key from userType: $e");
    }
  }

  Future<void> addTypeFlow(BuildContext context) async {
    print("selected types : $selectedTypes");

    // Create list of user types that are not already selected
    List<String> availableTypes = [];
    Map<String, String> arabicMap = TranslatedToArabicMap(context);

    arabicMap.forEach((translatedType, arabicType) {
      if (!selectedTypes.contains(arabicType)) {
        availableTypes.add(translatedType);
      }
    });

    final String? selectedTranslatedType = await showMenu<String>(
      context: context,
      position: Directionality.of(context) == TextDirection.rtl
          ? const RelativeRect.fromLTRB(0, 94, 40, 0) //ar
          : const RelativeRect.fromLTRB(40, 94, 0, 0), //en,fr
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.transparent,
      items: availableTypes.map((translatedType) {
        final arabicType = arabicMap[translatedType]!;
        final emoji = emojiMap[arabicType] ?? '❓';
        final imagePath = 'assets/become/$emoji.jpg';

        return PopupMenuItem<String>(
          value: translatedType,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 90,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) => Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Icon(Icons.broken_image, color: Colors.grey[600]),
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    alignment: Alignment.center,
                    child: Text(
                      translatedType,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );

    if (selectedTranslatedType != null) {
      // Convert the selected translated type to Arabic for storage
      final arabicType = arabicMap[selectedTranslatedType]!;

      if (selectedTranslatedType == S.of(context).agriculteur ||
          selectedTranslatedType == S.of(context).eleveur) {
        // If Agriculteur or Éleveur, add directly without document
        await addUserTypeNoDoc(arabicType);
        setState(() {
          selectedTypes.insert(0, arabicType);
          activeType = arabicType;
          widget.onTypeChanged();
        });
      } else {
        // For other types, navigate to document page
        await getDocumentPageForType(context, arabicType);

        // Check validation status
        final isValid = await getValidation(arabicType) ?? false;

        // Don't add the type if not valid
        if (!isValid) {
          return;
        }

        setState(() {
          activeType = arabicType;
          widget.onTypeChanged();
        });

        await saveUserData(selectedTypes, activeType!);
        widget.onTypeChanged();

        // Show appropriate popup
        if (arabicType == 'مربي الماشية' || arabicType == 'فلاح') {
          showSuccessPopup(context, arabicType);
        } else {
          showAlertsPopup(context);
        }
      }
    }
  }

  Future<bool?> getValidation(String type) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .get();

      final data = doc.data();
      if (data != null) {
        if (data['userType'] == 'فلاح' || data['userType'] == 'مربي الماشية') {
          return true;
        } else if (data['userType'] != null) {
          final userTypeMap = Map<String, dynamic>.from(data['userType']);
          final typeData = userTypeMap[type];

          if (typeData != null && typeData['validation'] == 'pending') {
            return false;
          } else {
            return true;
          }
        }
      }
      return false; // default: not validated or doesn't exist
    } catch (e) {
      print("Error checking validation: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.zero,
      child: selectedTypes.isEmpty
          ? FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                fixedSize: const Size.fromHeight(40),
              ),
              onPressed: () => addTypeFlow(context),
              child: Center(
                child: Text(S.of(context).become,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: (selectedTypes.length * 10),
                  height: 32,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: selectedTypes
                        .asMap()
                        .entries
                        .toList()
                        .reversed
                        .map((entry) {
                      final index = selectedTypes.length - 1 - entry.key;
                      final type = entry.value;
                      final emoji = emojiMap[type] ?? '❓';

                      return Positioned(
                        left: Directionality.of(context) == TextDirection.rtl
                            ? index * 8.0 - 28.0
                            : null,
                        right: Directionality.of(context) == TextDirection.rtl
                            ? null
                            : index * 8.0 - 28.0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: type == activeType
                                ? const Color.fromARGB(255, 53, 118, 55)
                                : isDarkMode
                                    ? const Color.fromARGB(255, 129, 129, 129)
                                    : const Color.fromARGB(255, 59, 58, 58),
                            border: Border.all(color: Colors.white, width: 1.1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Transform.translate(
                    offset: Directionality.of(context) == TextDirection.rtl
                        ? const Offset(-20.0, 2)
                        : const Offset(20.0, 2),
                    child: IconButton(
                      icon: Icon(Icons.arrow_drop_down_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 35),
                      tooltip: S.of(context).switchActiveProfile,
                      onPressed: () async {
                        final newActive = await showMenu<String>(
                          context: context,
                          position: Directionality.of(context) ==
                                  TextDirection.rtl
                              ? const RelativeRect.fromLTRB(0, 94, 40, 0) //ar
                              : const RelativeRect.fromLTRB(
                                  40, 94, 0, 0), //en,fr
                          color: Colors.transparent,
                          items: await Future.wait(
                              selectedTypes.map((arabicType) async {
                            final isValid =
                                await getValidation(arabicType) ?? false;
                            widget.onTypeChanged();
                            final emoji = emojiMap[arabicType] ?? '❓';
                            final imagePath = 'assets/become/$emoji.jpg';
                            // Get the translated name for display
                            final translatedType =
                                ArabicToTranslatedMap(context)[arabicType] ??
                                    arabicType;

                            return PopupMenuItem<String>(
                              value: isValid
                                  ? arabicType
                                  : null, // Returns the Arabic type only if it's valid
                              padding: EdgeInsets.zero,
                              height: 90,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      height: 90,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.asset(
                                            imagePath,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, _) =>
                                                Container(
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: Icon(Icons.broken_image,
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                          Container(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            alignment: Alignment.center,
                                            child: Text(
                                              translatedType, // Display translated type
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          if (!isValid)
                                            Positioned.fill(
                                              child: IgnorePointer(
                                                // Prevents blocking touches if needed
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    // Dark semi-transparent overlay
                                                    Container(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                    ),

                                                    // Lock icon on top (not affected by dark background)
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Icon(
                                                        IconlyBold.lock,
                                                        color: Colors.white,
                                                        size: 40,
                                                        shadows: [
                                                          Shadow(
                                                            color: Colors.white,
                                                            offset:
                                                                Offset(0, 2),
                                                            blurRadius: 0,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Trash icon - stays visible no matter if valid or not
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: GestureDetector(
                                      onTap: () async {
                                        deleteUserTypeKey(arabicType);
                                        selectedTypes.remove(arabicType);
                                        widget.onTypeChanged();
                                        await saveUserData(
                                            selectedTypes, activeType!);
                                        widget.onTypeChanged();
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red),
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(Icons.delete_forever,
                                            size: 22,
                                            color: Colors.white,
                                            shadows: isValid
                                                ? []
                                                : [
                                                    Shadow(
                                                      color: Colors.white,
                                                      offset: Offset(0, 2),
                                                      blurRadius: 0,
                                                    ),
                                                  ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                if (!isValid) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        S.of(context).alert,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          color: Colors.red,
                                        ),
                                      ),
                                      content: Text(
                                        S.of(context).alertContent,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            S.of(context).ok,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          }).toList()),
                        );

                        if (newActive != null && newActive != activeType) {
                          await setActiveType(newActive);
                          widget.onTypeChanged();
                          setState(() {
                            selectedTypes.remove(newActive);
                            selectedTypes.insert(0, newActive);
                            activeType = newActive;
                          });
                          await saveUserData(selectedTypes, newActive);
                          widget.onTypeChanged();
                        }
                      },
                    )),
                if (selectedTypes.length < userTypes.length)
                  GestureDetector(
                    onTap: () => addTypeFlow(context),
                    child: Container(
                      width: 35,
                      height: 35,
                      alignment: Directionality.of(context) == TextDirection.rtl
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Icon(
                        Icons.group_add,
                        size: 26,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
              ],
            ),
    );
  }
}
