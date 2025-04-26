import 'package:agriplant/Front_end/Document_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// List of all possible user types
final Map<String, dynamic> UserTypes = {
  'Agriculteur': {},
  'Éleveur': {},
  'Expert Agri': {},
  'Vétérinaire': {},
  'Entreprise': {},
  'Transporteur': {},
  'Réparateur': {}
};

// Add user type to the Firestore user's list (if not already exists)
Future<void> addUserType(String userType) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);
      final snapshot = await docRef.get();

      Map<String, dynamic> currentTypes =
          Map<String, dynamic>.from(snapshot.data()?['userType'] ?? {});

      if (!currentTypes.containsKey(userType)) {
        if (userType == 'Agriculteur' || userType == 'Éleveur') {
          currentTypes[userType] = {
            'createdAt': FieldValue.serverTimestamp(),
            // تضيف حقول حسب الحاجة
          };
        } else {
          currentTypes[userType] = {
            'validation': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
            // تضيف حقول حسب الحاجة
          };
        }

        await docRef.update({
          'userType': currentTypes,
          'userTypeUpdatedAt': FieldValue.serverTimestamp(),
        });

        print("✅ User type '$userType' added successfully as a map.");
      }
    } else {
      print("⚠️ No user is logged in.");
    }
  } catch (e) {
    print("❌ Error updating user type: $e");
  }
}

// Success Popup to show when user type is added successfully
void showSuccessPopup(BuildContext context, String? type) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("🎉 Congratulations!"),
        content: Text("Yeeey! You are now a $type!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
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
      return AlertDialog(
        title: const Text("🎉 Alert!"),
        content: Text(
            "You have to upload some files .. after validation you received a notification"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

// Normalize the userType string for use as an ID or path
String normalize(String name) {
  return name
      .toLowerCase()
      .replaceAll(' ', '_')
      .replaceAll(RegExp(r'[éèêë]'), 'e')
      .replaceAll(RegExp(r'[àâä]'), 'a')
      .replaceAll(RegExp(r'[îï]'), 'i')
      .replaceAll(RegExp(r'[ôö]'), 'o')
      .replaceAll(RegExp(r'[ùûü]'), 'u')
      .replaceAll(RegExp(r'[ç]'), 'c');
}

Future<Map<String, dynamic>> fetchUserTypesAndActive() async {
  final user = FirebaseAuth.instance.currentUser;
  final docRef = FirebaseFirestore.instance.collection('Users').doc(user?.uid);
  final docSnapshot = await docRef.get();

  if (!docSnapshot.exists) {
    print("❌ User document not found.");
    return {'userType': <String>[], 'activeType': ''};
  }

  final data = docSnapshot.data()!;
  Map<String, dynamic> typesMap =
      Map<String, dynamic>.from(data['userType'] ?? {});
  List<String> types = typesMap.keys.toList();
  String? type = data['activeType'];

  print("✅ Fetched from Firestore:");
  print("userType keys: $types");
  print("activeType: $type");

  if (type == null || type.isEmpty) {
    type = 'Client';
    await docRef.update({'activeType': type});
    print("⚠️ activeType was null, defaulted to 'Client'");
  }

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

class BecomeTypeAction extends StatefulWidget {
  final VoidCallback onTypeChanged;

  const BecomeTypeAction({Key? key, required this.onTypeChanged})
      : super(key: key);

  @override
  State<BecomeTypeAction> createState() => _BecomeTypeActionState();
}

class _BecomeTypeActionState extends State<BecomeTypeAction> {
  List<String> selectedTypes = [];
  String? activeType;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    final result = await fetchUserTypesAndActive();

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

  Object getLabelForDoc(selectedType) {
    switch (selectedType) {
      case 'Vétérinaire':
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DocumentPage(userType: 'Vétérinaire'),
          ),
        );
      case 'Expert Agri':
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DocumentPage(userType: 'Expert Agri'),
          ),
        );
      case 'Entreprise':
        return {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DocumentPage(userType: 'Entreprise'),
            ),
          ),
        };
      case 'Transporteur':
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DocumentPage(userType: 'Transporteur'),
          ),
        );
      case 'Réparateur':
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DocumentPage(userType: 'Réparateur'),
          ),
        );
      default:
        return Null;
    }
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

      // Update the user's document to delete the specific key from the userType map
      await userDocRef.update({
        'userType.$keyToDelete': FieldValue.delete(),
      });

      print("Key '$keyToDelete' successfully deleted from userType.");

      if (selectedTypes.isEmpty) {
        setActiveType('Client');
      } else if (activeType == keyToDelete) {
        setActiveType(selectedTypes.first);
      }
      print('selected : $selectedTypes');
    } catch (e) {
      print("Error deleting key from userType: $e");
    }
  }

  Future<void> addTypeFlow(BuildContext context) async {
    print("selected types : $selectedTypes");
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final String? selectedType = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(90, 102, overlay.size.width - 20, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.transparent,
      items: UserTypes.keys
          .where((type) => !selectedTypes.contains(type))
          .map((type) {
        final imagePath = 'assets/become/${normalize(type)}.jpg';
        return PopupMenuItem<String>(
          value: type,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 100,
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
                    color: Colors.black.withOpacity(0.3),
                    alignment: Alignment.center,
                    child: Text(
                      type,
                      style: const TextStyle(
                        fontSize: 22,
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

    if (selectedType != null) {
      await getLabelForDoc(selectedType);
      // 2. أولاً حفظ البيانات قبل التحقق من التفعيل
      await addUserType(selectedType);
      setState(() {
        selectedTypes.add(selectedType);
      });

      // 2. تحقق من حالة التفعيل
      final isValid = await getValidation(selectedType) ?? false;

      // 3. إذا النوع غير مفعل، أظهر رسالة تحذير
      if (!isValid) {
        return; // 🛑 لا تضيف النوع إذا غير مفعل
      }

      // 4. إذا كان النوع مفعل، أضفه إلى القائمة وحدث الحالة
      setState(() {
        activeType = selectedType;
      });

      //await setActiveType(activeType!);
      await saveUserData(selectedTypes, activeType!);
      widget.onTypeChanged(); // 👈 Add this
      if (activeType == 'Éleveur' || activeType == 'Agriculteur') {
        showSuccessPopup(context, selectedType);
      } else {
        showAlertsPopup(context);
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
        if (data['userType'] == 'Agriculteur' ||
            data['userType'] == 'Éleveur') {
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
                    borderRadius: BorderRadius.circular(16)),
                fixedSize: const Size.fromHeight(40),
              ),
              onPressed: () => addTypeFlow(context),
              child: const Center(
                child: Text("Become",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

                      final emojiMap = {
                        'Agriculteur': '👨🏽‍🌾',
                        'Éleveur': '🐮',
                        'Expert Agri': '🕵🏼',
                        'Vétérinaire': '💉',
                        'Entreprise': '🏢',
                        'Transporteur': '🛻',
                        'Réparateur': '👨🏻‍🔧',
                      };

                      final emoji = emojiMap[type] ?? '❓';

                      return Positioned(
                        right: index * 12.0 - 28.0,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: type == activeType
                                ? const Color.fromARGB(255, 53, 118, 55)
                                : isDarkMode
                                    ? const Color.fromARGB(255, 199, 197, 197)
                                    : const Color.fromARGB(255, 59, 58, 58),
                            border: Border.all(color: Colors.white, width: 0.8),
                          ),
                          alignment: Alignment.center,
                          child: Text(emoji,
                              style: const TextStyle(
                                fontSize: 25,
                              )),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Transform.translate(
                    offset: const Offset(15.0, 2),
                    child: IconButton(
                      icon: Icon(Icons.arrow_drop_down_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 35),
                      tooltip: 'Switch Active Profile',
                      onPressed: () async {
                        final newActive = await showMenu<String>(
                          context: context,
                          position: const RelativeRect.fromLTRB(40, 103, 10, 0),
                          color: Colors.transparent,
                          items:
                              await Future.wait(selectedTypes.map((type) async {
                            final isValid = await getValidation(type) ?? false;
                            final imagePath =
                                'assets/become/${normalize(type)}.jpg';

                            return PopupMenuItem<String>(
                              enabled:
                                  isValid, // Prevents selection if not valid
                              value: isValid
                                  ? type
                                  : null, // Returns the type only if it's valid
                              padding: EdgeInsets.zero,
                              height: 100,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      height: 100,
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
                                                Colors.black.withOpacity(0.3),
                                            alignment: Alignment.center,
                                            child: Text(
                                              type,
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          if (!isValid)
                                            Container(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              child: Center(
                                                child: Icon(Icons.lock,
                                                    color: Colors.white,
                                                    size: 30),
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
                                        deleteUserTypeKey(type);
                                        selectedTypes.remove(type);
                                        await saveUserData(
                                            selectedTypes, activeType!);
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.delete_forever,
                                          size: 22,
                                          color: Colors.white,
                                        ),
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
                                      title: const Text('تنبيه'),
                                      content: const Text(
                                          'هذا النوع غير مفعل من طرف الإدارة.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('حسناً'),
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
                          setState(() {
                            selectedTypes.remove(newActive);
                            selectedTypes.insert(0, newActive);
                            activeType = newActive;
                          });
                          await saveUserData(selectedTypes, newActive);
                          widget.onTypeChanged(); // 👈 Add this
                        }
                      },
                    )),
                if (selectedTypes.length < UserTypes.length)
                  GestureDetector(
                    onTap: () => addTypeFlow(context),
                    child: Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.group_add,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
              ],
            ),
    );
  }
}
