import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agriplant/Front_end/theme_provider.dart';
import 'package:agriplant/Front_end/language_provider.dart';
import 'package:agriplant/Front_end/Contact_us_page.dart';
import 'package:app_settings/app_settings.dart';
import 'Edit_profile_page.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 55, 72, 56) // Dark green in dark mode
            : const Color.fromARGB(255, 42, 103, 34),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Edit Profile
          ListTile(
            leading: Icon(Icons.person,
                color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
            title: const Text('Edit Profile'),
            trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Edit_profile_page()),
              );
            },
          ),
          const Divider(),

          // Dark Mode Toggle
          ListTile(
            leading: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.sunny : Icons.dark_mode,
            color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34),),
            title: Text(themeProvider.themeMode == ThemeMode.dark ? 'Light Mode' : 'Dark Mode'),
            trailing: Switch(
           inactiveThumbColor: const Color.fromARGB(255, 42, 103, 34),
           activeColor: const Color.fromARGB(255, 133, 159, 133),
           value: themeProvider.themeMode == ThemeMode.dark,
           onChanged: (value) {
              themeProvider.toggleTheme(value);
                },
               ),
             ),

          const Divider(),

          // Language Selection
          ListTile(
            leading: Icon(Icons.language,
                color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
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
          const Divider(),

          // Notifications Toggle
          ListTile(
            leading: Icon(Icons.notifications_active,
                color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
            title: const Text('Enable Notifications'),
            trailing: Switch(
              inactiveThumbColor: isDarkMode ? const Color.fromARGB(255, 133, 159, 133) : const Color.fromARGB(255, 42, 103, 34),
              activeColor: isDarkMode ? const Color.fromARGB(255, 133, 159, 133) : const Color.fromARGB(255, 42, 103, 34),
              value: areNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  areNotificationsEnabled = value;
                });

                // Open notification settings if turned on
                if (value) {
                  AppSettings.openAppSettings(type: AppSettingsType.notification);
                }
              },
            ),
          ),
          const Divider(),

          // Contact Us
          ListTile(
            leading: Icon(Icons.contact_support,
                color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
            title: const Text('Contact Us'),
            trailing: Icon(Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white : const Color.fromARGB(255, 42, 103, 34)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Contact_us_page()),
              );
            },
          ),
        ],
      ),
    );
  }
}
