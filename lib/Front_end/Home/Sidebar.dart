import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Profile/Settings/settings.dart';
import 'package:agriplant/Front_end/Providers/theme_provider.dart';
import 'package:agriplant/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Container(
        color: isDarkMode
            ? const Color.fromARGB(255, 39, 57, 48) // Dark green in dark mode
            : Theme.of(context)
                .colorScheme
                .secondaryContainer, // Light green in light mode
        child: ListView(
          children: [
            ListTile(
              leading: Icon(
                themeProvider.themeMode == ThemeMode.dark
                    ? Icons.sunny
                    : Icons.dark_mode,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              ),
              title: Text(
                themeProvider.themeMode == ThemeMode.dark
                    ? S.of(context).lightMode
                    : S.of(context).darkMode,
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
            ListTile(
              leading: Icon(
                Icons.settings_sharp,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              ),
              title: Text(
                S.of(context).settings,
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            if (!Users.isGuestUser()) ...[
              ListTile(
                leading: Icon(
                  Icons.logout_sharp,
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
                title: Text(
                  S.of(context).logout,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
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
                                  await FirebaseAuth.instance
                                      .signInAnonymously();

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
      ),
    );
  }
}
