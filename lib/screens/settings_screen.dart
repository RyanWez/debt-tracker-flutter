import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nhost_flutter_auth/nhost_flutter_auth.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final auth = NhostAuthProvider.of(context);
    final user = auth?.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (user != null) ...[
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.account_circle,
                      color: Color(0xFFFACC15),
                      size: 40,
                    ),
                    title: Text(
                      (user.metadata?['shop_name'] as String?) ?? 'Shop Owner',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(user.email ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      onPressed: () {
                        auth?.signOut();
                        // The AuthGate in main.dart will handle the redirection
                        // but we can pop to be safe or just let the stream handle it
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.brightness_6,
                    color: Color(0xFFFACC15),
                  ),
                  title: Text(
                    l10n.theme,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    themeProvider.themeMode == ThemeMode.system
                        ? l10n.systemTheme
                        : themeProvider.themeMode == ThemeMode.light
                        ? l10n.lightTheme
                        : l10n.darkTheme,
                  ),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.systemTheme),
                  value: ThemeMode.system,
                  // ignore: deprecated_member_use
                  groupValue: themeProvider.themeMode,
                  // ignore: deprecated_member_use
                  onChanged: (value) {
                    if (value != null) themeProvider.setThemeMode(value);
                  },
                  activeColor: const Color(0xFFFACC15),
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.lightTheme),
                  value: ThemeMode.light,
                  // ignore: deprecated_member_use
                  groupValue: themeProvider.themeMode,
                  // ignore: deprecated_member_use
                  onChanged: (value) {
                    if (value != null) themeProvider.setThemeMode(value);
                  },
                  activeColor: const Color(0xFFFACC15),
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.darkTheme),
                  value: ThemeMode.dark,
                  // ignore: deprecated_member_use
                  groupValue: themeProvider.themeMode,
                  // ignore: deprecated_member_use
                  onChanged: (value) {
                    if (value != null) themeProvider.setThemeMode(value);
                  },
                  activeColor: const Color(0xFFFACC15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: Color(0xFFFACC15)),
                  title: Text(
                    l10n.language,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    languageProvider.locale.languageCode == 'my'
                        ? l10n.myanmar
                        : l10n.english,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(l10n.english),
                  leading: Radio<String>(
                    value: 'en',
                    // ignore: deprecated_member_use
                    groupValue: languageProvider.locale.languageCode,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value != null) {
                        languageProvider.setLocale(Locale(value));
                      }
                    },
                    activeColor: const Color(0xFFFACC15),
                  ),
                  onTap: () => languageProvider.setLocale(const Locale('en')),
                ),
                ListTile(
                  title: Text(l10n.myanmar),
                  leading: Radio<String>(
                    value: 'my',
                    // ignore: deprecated_member_use
                    groupValue: languageProvider.locale.languageCode,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      if (value != null) {
                        languageProvider.setLocale(Locale(value));
                      }
                    },
                    activeColor: const Color(0xFFFACC15),
                  ),
                  onTap: () => languageProvider.setLocale(const Locale('my')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.appVersion,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData ? snapshot.data!.version : '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
