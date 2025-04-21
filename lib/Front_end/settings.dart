import 'package:agriplant/Front_end/Security_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:agriplant/Front_end/theme_provider.dart';
import 'package:agriplant/Front_end/language_provider.dart';
import 'package:agriplant/Front_end/Contact_us_page.dart';
import 'package:app_settings/app_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool areNotificationsEnabled = true; // Assume notifications are enabled

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor:
              isDarkMode ? colorScheme.surface : colorScheme.surface,
          elevation: 5),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          
          Divider(
              color: isDarkMode
                  ? const Color.fromARGB(255, 16, 24, 20)
                  : Colors.white),

          // security
          ListTile(
            leading: Icon(IconlyBold.shieldFail,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            title: Text(
              'Security',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecurityPage()),
              );
            },
          ),

          Divider(
              color: isDarkMode
                  ? const Color.fromARGB(255, 16, 24, 20)
                  : Colors.white),

          // Dark Mode Toggle
          ListTile(
            leading: Icon(
                themeProvider.themeMode == ThemeMode.dark
                    ? Icons.sunny
                    : Icons.dark_mode,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            title: Text(themeProvider.themeMode == ThemeMode.dark
                ? 'Light Mode'
                : 'Dark Mode'),
            trailing: Switch(
              inactiveThumbColor: const Color(0xFF256C4C),
              activeColor: const Color(0xFF90D5AE),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),
          Divider(
              color: isDarkMode
                  ? const Color.fromARGB(255, 16, 24, 20)
                  : Colors.white),
          // Language Selection
          ListTile(
            leading: Icon(Icons.language,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            title: const Text('Language'),
            trailing: DropdownButton<Locale>(
              value: languageProvider.locale,
              dropdownColor: Theme.of(context).scaffoldBackgroundColor,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              onChanged: (newLocale) {
                if (newLocale != null) {
                  languageProvider.changeLanguage(newLocale);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('fr'),
                  child: Text('French'),
                ),
                DropdownMenuItem(
                  value: Locale('ar'),
                  child: Text('Arabic'),
                ),
              ],
            ),
          ),
          Divider(
              color: isDarkMode
                  ? const Color.fromARGB(255, 16, 24, 20)
                  : Colors.white),
          // Notifications Toggle
          ListTile(
            leading: Icon(Icons.notifications_active,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            title: const Text(' Notifications'),
            trailing: Switch(
              inactiveThumbColor: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C),
              activeColor: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C),
              value: areNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  areNotificationsEnabled = value;
                });

                // Open notification settings if turned on
                if (value) {
                  AppSettings.openAppSettings(
                      type: AppSettingsType.notification);
                }
              },
            ),
          ),
          Divider(
              color: isDarkMode
                  ? const Color.fromARGB(255, 16, 24, 20)
                  : Colors.white),
          // Contact Us
          ListTile(
            leading: Icon(Icons.contact_support,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            title: const Text('Contact Us'),
            trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Contact_us_page()),
              );
            },
          ),

          Divider(
              color: isDarkMode
                  ? const Color.fromARGB(255, 16, 24, 20)
                  : Colors.white),

          ListTile(
            leading: Icon(Icons.logout_sharp,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            title: Text('Log out',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text(
                      'Attention ⚠️',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    content: const Text(
                      'Are you sure you want to log out from this account?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () async {
                          GoogleSignIn googleSignIn = GoogleSignIn();
                          googleSignIn.disconnect();
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "login_page", (route) => false);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
