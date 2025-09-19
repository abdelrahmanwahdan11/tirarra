import 'package:get/get.dart';

class AppTranslations extends Translations {
  AppTranslations(this._translations);

  final Map<String, Map<String, String>> _translations;

  @override
  Map<String, Map<String, String>> get keys => _translations;
}
