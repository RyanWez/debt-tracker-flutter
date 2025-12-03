import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default language: English

  Locale get locale => _locale;

  // Load saved language preference
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // Change language and save preference
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    notifyListeners();
  }

  // Toggle between Myanmar and English
  Future<void> toggleLanguage() async {
    if (_locale.languageCode == 'en') {
      await setLocale(const Locale('my'));
    } else {
      await setLocale(const Locale('en'));
    }
  }
}
