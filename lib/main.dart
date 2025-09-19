import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/bindings.dart';
import 'app/localization/translations.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final translations = await _loadTranslations();
  final storage = GetStorage();
  final storedLocaleCode = storage.read<String>('localeCode');
  final storedDarkMode = storage.read<bool>('isDarkMode');

  runApp(
    TrendWearApp(
      translations: translations,
      initialLocale:
          storedLocaleCode != null ? Locale(storedLocaleCode) : null,
      storedDarkMode: storedDarkMode,
    ),
  );
}

Future<AppTranslations> _loadTranslations() async {
  final enJson = await rootBundle.loadString('assets/locales/en.json');
  final arJson = await rootBundle.loadString('assets/locales/ar.json');

  return AppTranslations(
    {
      'en': Map<String, String>.from(jsonDecode(enJson) as Map<String, dynamic>),
      'ar': Map<String, String>.from(jsonDecode(arJson) as Map<String, dynamic>),
    },
  );
}

class TrendWearApp extends StatelessWidget {
  const TrendWearApp({
    super.key,
    required this.translations,
    this.initialLocale,
    this.storedDarkMode,
  });

  final AppTranslations translations;
  final Locale? initialLocale;
  final bool? storedDarkMode;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TrendWear',
      debugShowCheckedModeBanner: false,
      translations: translations,
      locale: initialLocale ?? Get.deviceLocale ?? const Locale('en'),
      fallbackLocale: const Locale('en'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _resolveThemeMode(),
      defaultTransition: Transition.fadeIn,
      enableLog: true,
    );
  }

  ThemeMode _resolveThemeMode() {
    if (storedDarkMode == null) {
      return ThemeMode.system;
    }
    return storedDarkMode! ? ThemeMode.dark : ThemeMode.light;
  }
}
