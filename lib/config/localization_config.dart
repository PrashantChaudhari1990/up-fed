import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import '../ui/shared_widget/language_selection_model.dart';

class LocaleLanguage {
  String language;
  String langInEnglish;
  String? langShortCode;
  Locale locale;
  LocaleLanguage(
      {required this.language,
      required this.langInEnglish,
      this.langShortCode,
      required this.locale});
}

class LocalizationConfig {
  static const String translationPath = 'assets/translations';

  static final List<LocaleLanguage> supportedLanguages = [
    LocaleLanguage(
        language: 'English',
        langInEnglish: 'English',
        langShortCode: 'Aa',
        locale: const Locale('en', 'IN')),
    LocaleLanguage(
        language: 'हिंदी',
        langInEnglish: 'Hindi',
        langShortCode: 'आ',
        locale: const Locale('hi', 'IN')),
    LocaleLanguage(
        language: 'मराठी',
        langInEnglish: 'Marathi',
        langShortCode: 'एम',
        locale: const Locale('mr', 'IN')),
  ];

  static List<Locale> get supportedLocales {
    return supportedLanguages.map((lang) => lang.locale).toList();
  }

  static changeLang(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return const LanguageSelectionModel();
        }).then((isLanguageChanged) {
      if (isLanguageChanged != null && isLanguageChanged) {
        Restart.restartApp();
      }
    });
  }
}
