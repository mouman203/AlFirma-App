import 'package:agriplant/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  String? email;
  String? phone;

  // Show dialog to update email and phone num
  void Email_PhoneUpdateDialog(String val, context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    TextEditingController emailController = TextEditingController();

    InputDecoration customDecoration(String label) => InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C)),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C)),
            borderRadius: BorderRadius.circular(12),
          ),
        );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            val == "Email"
                ? S.of(context).updateEmail
                : S.of(context).updatePhoneNumber,
            style: TextStyle(
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C)),
          ),
          content: TextField(
            controller: emailController,
            decoration: customDecoration(val == "Email"
                ? S.of(context).enterNewEmail
                : S.of(context).enterNewPhoneNumber),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close dialog
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor:
                    isDarkMode ? Colors.red.shade100 : Colors.red.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                    color:
                        isDarkMode ? Colors.red.shade900 : Colors.red.shade100,
                    fontSize: 16),
              ),
            ),
            const SizedBox(width: 75),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                S.of(context).submit,
                style: TextStyle(
                    color: isDarkMode ? Colors.black : Colors.white,
                    fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

//show email and phone num options
  void Email_PhoneOptions(String val) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            val =="Email"
                ? S.of(context).emailOptions
                : S.of(context).phoneOptions,
            style: TextStyle(
              color: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: isDarkMode
                      ? const Color(0xFF90D5AE)
                      : const Color(0xFF256C4C),
                ),
                title: Text(
                  val == "Email"
                      ? S.of(context).changeEmail
                      : S.of(context).changePhoneNumber,
                  style: TextStyle(
                    color: isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  val == "Email"
                      ? Email_PhoneUpdateDialog("Email", context)
                      : Email_PhoneUpdateDialog("Phone", context);
                },
              ),
              const SizedBox(height: 5),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 255, 17, 0),
                ),
                title: Text(
                  val == S.of(context).email
                      ? S.of(context).deleteEmail
                      : S.of(context).deletePhoneNumber,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 155, 10, 0),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  val == "Email"
                      ? _showDeletingAccMsg("Email")
                      : _showDeletingAccMsg("Phone Number");
                  print("hello");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //show changing password
  void _showChangePasswordDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    InputDecoration customDecoration(String label) => InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C)),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C)),
            borderRadius: BorderRadius.circular(12),
          ),
        );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            S.of(context).changePassword,
            style: TextStyle(
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: customDecoration(S.of(context).oldPassword),
              ),
              const SizedBox(height: 10), // Add space between the text fields
              TextField(
                obscureText: true,
                decoration: customDecoration(S.of(context).newPassword),
              ),
              const SizedBox(height: 10), // Add space between the text fields
              TextField(
                obscureText: true,
                decoration: customDecoration(S.of(context).newPassword),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor:
                    isDarkMode ? Colors.red.shade100 : Colors.red.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                    color:
                        isDarkMode ? Colors.red.shade900 : Colors.red.shade100,
                    fontSize: 16),
              ),
            ),
            const SizedBox(width: 60),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                S.of(context).submit,
                style: TextStyle(
                    color: isDarkMode ? Colors.black : Colors.white,
                    fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  //show deleting Account msg
  void _showDeletingAccMsg(String val) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title:  Text(
            S.of(context).attention,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(
            val == S.of(context).account
                ? S.of(context).confirmDeleteAccount
                :'${S.of(context).confirmDeleteItem} $val?',
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor:
                    isDarkMode ? Colors.red.shade100 : Colors.red.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                  color: isDarkMode ? Colors.red.shade900 : Colors.red.shade100,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 110),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                	S.of(context).submit,
                style: TextStyle(
                  color: isDarkMode ? Colors.black : Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("Users").doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        email = userDoc["email"];
        phone = userDoc["phone"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title:  Text(S.of(context).privacySecurity,style:TextStyle(fontWeight: FontWeight.bold) ),
        elevation: 5,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Security Card
              Card(
                color:
                    isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
                margin: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/Security.png",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).securityMessage2,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Card(
                              color: isDarkMode
                                  ? Colors.orange.shade100
                                  : Colors.orange.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                child: Text(
                                  	S.of(context).mediumSecurity,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.orange.shade900
                                        : Colors.orange.shade100,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Contact Info Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                 S.of(context).contactInfo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C),
                  ),
                ),
              ),

              // Email Card
              Card(
                color:
                    isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(
                    Icons.email,
                    color: isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C),
                  ),
                  title: Text(
                    	S.of(context).email,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode
                          ? const Color(0xFF90D5AE)
                          : const Color(0xFF256C4C),
                    ),
                  ),
                  subtitle: Text(
                    "$email",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C),
                  ),
                  onTap: () => Email_PhoneOptions("Email"),
                ),
              ),/*

              const SizedBox(height: 5),

              // Phone Card
              Card(
                color:
                    isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C),
                  ),
                  title: Text(
                    S.of(context).phoneNumber,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode
                          ? const Color(0xFF90D5AE)
                          : const Color(0xFF256C4C),
                    ),
                  ),
                  subtitle: Text(
                    "$phone",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C),
                  ),
                  onTap: () => Email_PhoneOptions("Phone Number"),
                ),
              ),*/
            ],
          ),

          const SizedBox(
            height: 30,
          ),

          //security card
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              S.of(context).securityCard,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
              ),
            ),
          ),

          Card(
            color: isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.lock,
                    color: isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C),
                  ),
                  title: Text(
                    S.of(context).changePassword,
                    style: TextStyle(
                        color: isDarkMode
                            ? const Color(0xFF90D5AE)
                            : const Color(0xFF256C4C),
                        fontSize: 16),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: isDarkMode
                        ? const Color(0xFF90D5AE)
                        : const Color(0xFF256C4C),
                  ),
                  onTap: _showChangePasswordDialog,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),

          //account management card
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              S.of(context).accountManagement,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? const Color(0xFF90D5AE)
                    : const Color(0xFF256C4C),
              ),
            ),
          ),

          Card(
            color: isDarkMode ? scheme.onSecondary : scheme.secondaryContainer,
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete,
                      color: Color.fromARGB(255, 255, 30, 0)),
                  title: Text(S.of(context).deleteAccount,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 17, 0),
                      )),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 255, 17, 0),
                  ),
                  onTap: () => _showDeletingAccMsg(S.of(context).account),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
