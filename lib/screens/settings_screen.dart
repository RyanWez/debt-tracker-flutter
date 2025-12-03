import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                RadioListTile<String>(
                  title: Text(l10n.english),
                  value: 'en',
                  groupValue: languageProvider.locale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      languageProvider.setLocale(Locale(value));
                    }
                  },
                  activeColor: const Color(0xFFFACC15),
                ),
                RadioListTile<String>(
                  title: Text(l10n.myanmar),
                  value: 'my',
                  groupValue: languageProvider.locale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      languageProvider.setLocale(Locale(value));
                    }
                  },
                  activeColor: const Color(0xFFFACC15),
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
                  const Text(
                    '1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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
