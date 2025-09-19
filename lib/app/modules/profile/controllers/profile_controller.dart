// TODO(Auth + FCM):
// 1) تفعيل Firebase Auth (Email/Phone/Anonymous) وربط المستخدم بالمزايدات والمفضلات
// 2) استخدام FCM لتوجيه إشعارات الفوز بالمزاد والعروض الفورية
// 3) مزامنة الإعدادات عبر Cloud Firestore (تفضيل اللغة والوضع الداكن)
// 4) إضافة Social Login وإدارة الجلسة على الويب مع persistence

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/item.dart';
import '../../home/controllers/home_controller.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.homeController,
    required this.storage,
  });

  final HomeController homeController;
  final GetStorage storage;

  late final Rx<Locale> locale;

  @override
  void onInit() {
    super.onInit();
    final stored = storage.read<String>('localeCode');
    locale = (stored != null ? Locale(stored) : Get.locale ?? const Locale('en')).obs;
  }

  void toggleDarkMode(bool value) {
    homeController.toggleDarkMode(value);
  }

  void toggleReduceEffects(bool value) {
    homeController.toggleReduceEffects(value);
  }

  void toggleNotifications(bool value) {
    homeController.toggleNotifications(value);
  }

  void switchLanguage(Locale newLocale) {
    locale.value = newLocale;
    storage.write('localeCode', newLocale.languageCode);
    Get.updateLocale(newLocale);
  }

  bool get isDarkMode => homeController.isDarkMode.value;
  bool get reduceEffects => homeController.reduceEffects.value;
  bool get notificationsEnabled => homeController.notificationsEnabled.value;

  List<TrendItem> get favorites => homeController.favoriteItems();
}
