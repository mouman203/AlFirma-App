import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Profile/Settings/Security_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings,
            style: TextStyle(
                fontWeight:
                    FontWeight.bold)), // Use localized string for appBar title
        backgroundColor: isDarkMode ? colorScheme.surface : colorScheme.surface,
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
  leading: Icon(
    Icons.language,
    color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
  ),
  title: Text(
    S.of(context).language,
    style: TextStyle(
      color: isDarkMode ? Colors.white : Colors.black,
    ),
  ),
  trailing: LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth * 0.4, // ✅ make it responsive instead of fixed width
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color.fromARGB(255, 16, 24, 20)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<Locale>(
            dropdownStyleData: DropdownStyleData(
              offset: const Offset(0, 0),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color.fromARGB(255, 16, 24, 20)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            value: languageProvider.locale,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
            iconStyleData: IconStyleData(
              iconEnabledColor: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C),
              iconDisabledColor: isDarkMode
                  ? const Color(0xFF90D5AE)
                  : const Color(0xFF256C4C),
            ),
            onChanged: (newLocale) {
              if (newLocale != null) {
                languageProvider.changeLanguage(newLocale);
              }
            },
            selectedItemBuilder: (context) {
              return [
                const Locale('ar'),
                const Locale('fr'),
                const Locale('en'),
              ].map((locale) {
                String text;
                if (locale.languageCode == 'ar') {
                  text = S.of(context).languageArabic;
                } else if (locale.languageCode == 'fr') {
                  text = S.of(context).languageFrench;
                } else {
                  text = S.of(context).languageEnglish;
                }
                return Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },
            items: [
              DropdownMenuItem(
                value: const Locale('ar'),
                child: Text(
                  S.of(context).languageArabic,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: const Locale('fr'),
                child: Text(
                  S.of(context).languageFrench,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: const Locale('en'),
                child: Text(
                  S.of(context).languageEnglish,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
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
              leading: Icon(
                Icons.logout_sharp,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              ),
              title: Text(
                S.of(context).logout,
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: colorScheme.secondaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        S.of(context).alertWarning,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red, // Red color for the heading
                        ),
                      ),
                      content: Text(
                        S.of(context).confirmLogout,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red, // No red for "No" button
                                foregroundColor: isDarkMode
                                    ? Colors.black
                                    : Colors.white, // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Rounded edges
                                ),
                                minimumSize: Size(90, 45), // Button size
                              ),
                              child: Text(S.of(context).no,
                                  style: TextStyle(fontSize: 18)),
                            ),
                            SizedBox(width: 10), // Space between the buttons
                            ElevatedButton(
                              onPressed: () async {
                                GoogleSignIn googleSignIn = GoogleSignIn();
                                googleSignIn.disconnect();
                                await FirebaseAuth.instance.signOut();
                                await FirebaseAuth.instance.signInAnonymously();

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "home_page", (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode
                                    ? const Color(0xFF90D5AE)
                                    : const Color(
                                        0xFF256C4C), // Red color for "Yes" button
                                foregroundColor: isDarkMode
                                    ? Colors.black
                                    : Colors.white, // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Rounded edges
                                ),
                                minimumSize: Size(90, 45), // Button size
                              ),
                              child: Text(S.of(context).yes,
                                  style: TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ],
      ),
    );
  }
}
