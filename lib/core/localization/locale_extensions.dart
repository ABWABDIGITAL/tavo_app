// lib/core/extensions/locale_extensions.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

extension LocaleExtensions on BuildContext {
  /// Check if current locale is RTL
  bool get isRtl => locale.languageCode == 'ar';
  
  /// Get text direction based on locale
  TextDirection get textDirection => 
      isRtl ? TextDirection.RTL : TextDirection.LTR;
  
  /// Get current language code safely
  String get languageCode => locale.languageCode;
}