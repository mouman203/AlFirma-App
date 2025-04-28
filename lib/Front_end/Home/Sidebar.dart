import 'package:agriplant/Back_end/User.dart';
import 'package:agriplant/Front_end/Profile/Settings/settings.dart';
import 'package:agriplant/Front_end/Providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

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
                    ? 'Light Mode'
                    : 'Dark Mode',
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
                'Settings',
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

            // Show "Log out" only for authenticated users
            if (!Users.isGuestUser())
              ListTile(
                leading: Icon(
                  Icons.logout_sharp,
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
                title: Text(
                  'Log out',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                onTap: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("login_page", (route) => false);
                },
              ),

            // Show "Login / Sign Up" for guest users only
            if (Users.isGuestUser())
              ListTile(
                leading: Icon(
                  IconlyBold.profile,
                  color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
                ),
                title: Text(
                  'Login ',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'login_page');
                },
              ),

            ListTile(
              title: const Text("About Us"),
              leading: Icon(
                IconlyLight.infoSquare,
                color: isDarkMode ? Colors.white : const Color(0xFF256C4C),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
