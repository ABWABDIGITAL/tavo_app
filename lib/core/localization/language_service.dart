import 'dart:ui';

class LanguageService {
  static String langCode = 'en';

  static void setLocale(Locale locale) {
    langCode = locale.languageCode;
  }
}