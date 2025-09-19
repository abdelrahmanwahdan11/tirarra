import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  OnboardingController()
      : selectedLocale = Rx<Locale>(const Locale('en')),
        isSaving = false.obs;

  final Rx<Locale> selectedLocale;
  final RxBool isSaving;

  GetStorage get _storage => Get.find<GetStorage>();

  List<Locale> get supportedLocales => const [Locale('en'), Locale('ar')];

  @override
  void onInit() {
    super.onInit();
    final storedLocaleCode = _storage.read<String>('localeCode');
    if (storedLocaleCode != null) {
      selectedLocale.value = Locale(storedLocaleCode);
    }
  }

  void selectLocale(Locale locale) {
    selectedLocale.value = locale;
    Get.updateLocale(locale);
  }

  Future<void> completeOnboarding() async {
    isSaving.value = true;
    await _storage.write('localeCode', selectedLocale.value.languageCode);
    isSaving.value = false;
    Get.offAllNamed(Routes.home);
  }
}
