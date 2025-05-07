import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Profile/Settings/Security_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:agriplant/Front_end/Providers/theme_provider.dart';
import 'package:agriplant/Front_end/Providers/language_provider.dart';
import 'package:agriplant/Front_end/Profile/Settings/Contact_us_page.dart';
import 'package:app_settings/app_settings.dart';
import 'package:agriplant/generated/l10n.dart'; // Import the localization file

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
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            S.of(context).settings), // Use localized string for appBar title
        backgroundColor: isDarkMode ? scheme.surface : scheme.surface,
        elevation: 5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Divider(
            color: isDarkMode
                ? const Color.fromARGB(255, 16, 24, 20)
                : Colors.white,
          ),

          // security
          ListTile(
            leading: Icon(
              Icons.shield,
              color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
            ),
            title: Text(
              S.of(context).security, // Use localized string
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
            ),
            onTap: () {
              if (Users.isGuestUser()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Text(
                            S
                                .of(context)
                                .securityMessage, // Use localized message
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: const Color.fromARGB(255, 247, 234, 117),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecurityPage()),
                );
              }
            },
          ),

          Divider(
            color: isDarkMode
                ? const Color.fromARGB(255, 16, 24, 20)
                : Colors.white,
          ),

          // Dark Mode Toggle
          ListTile(
            leading: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.sunny
                  : Icons.dark_mode,
              color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
            ),
            title: Text(
              themeProvider.themeMode == ThemeMode.dark
                  ? S.of(context).lightMode // Use localized string
                  : S.of(context).darkMode, // Use localized string
            ),
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
                : Colors.white,
          ),

          // Language Selection
          ListTile(
            leading: Icon(Icons.language,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
            title: Text(S.of(context).language), // Use localized string
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
              items:  [
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(S.of(context).languageEnglish),
                ),
                DropdownMenuItem(
                  value: const Locale('fr'),
                  child: Text(S.of(context).languageFrench),
                ),
                DropdownMenuItem(
                  value: const Locale('ar'),
                  child: Text(S.of(context).languageArabic),
                ),
              ],
            ),
          ),

          Divider(
            color: isDarkMode
                ? const Color.fromARGB(255, 16, 24, 20)
                : Colors.white,
          ),

          // Notifications Toggle
          ListTile(
            leading: Icon(
              areNotificationsEnabled
                  ? Icons.notifications_on_sharp
                  : Icons.notifications_off_sharp, // Change icon when off
              color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
            ),
            title: Text(S.of(context).notifications), // Use localized string
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
                : Colors.white,
          ),

          // Contact Us
          ListTile(
            leading: Icon(
              Icons.contact_support,
              color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
            ),
            title: Text(S.of(context).contactUs), // Use localized string
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
            ),
            onTap: () {
              if (Users.isGuestUser()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Text(
                            S
                                .of(context)
                                .loginToContactSupport, // Localized message
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: const Color.fromARGB(255, 247, 234, 117),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Contact_us_page()),
                );
              }
            },
          ),

          Divider(
            color: isDarkMode
                ? const Color.fromARGB(255, 16, 24, 20)
                : Colors.white,
          ),

          if (!Users.isGuestUser()) ...[
            ListTile(
              leading: Icon(Icons.logout_sharp,
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
              title: Text(
                S.of(context).logout, // Localized string for logout
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: isDarkMode
                          ? scheme.onSecondary
                          : scheme.secondaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        S.of(context).alertWarning, // Localized alert title
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      content: Text(
                        S.of(context).confirmLogout, // Localized logout message
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(S.of(context).no), // Localized "No"
                        ),
                        TextButton(
                          onPressed: () async {
                            GoogleSignIn googleSignIn = GoogleSignIn();
                            await googleSignIn.signOut();
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(S.of(context).yes), // Localized "Yes"
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
