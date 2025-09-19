import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String currency(num value, {String locale = 'en', String symbol = '\$'}) {
    final formatter = NumberFormat.currency(locale: locale, symbol: symbol);
    return formatter.format(value);
  }

  static String compactCurrency(num value, {String locale = 'en'}) {
    final formatter = NumberFormat.compactCurrency(locale: locale, symbol: '');
    return formatter.format(value);
  }

  static String distance(double kilometers, {String locale = 'en'}) {
    final formatter = NumberFormat('#,##0.0', locale);
    return '${formatter.format(kilometers)} km';
  }

  static String dateTime(DateTime value, {String locale = 'en'}) {
    final formatter = DateFormat.yMMMMEEEEd(locale).add_jm();
    return formatter.format(value);
  }

  static String countdown(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, "0");
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, "0");
    return '${hours.toString().padLeft(2, "0")}:$minutes:$seconds';
  }
}

class WebPerformanceToggles {
  WebPerformanceToggles._();

  static bool isInstagramInAppBrowser({String? userAgent}) {
    if (!kIsWeb) {
      return false;
    }
    final normalized = userAgent?.toLowerCase() ?? '';
    return normalized.contains('instagram');
  }

  static bool shouldReduceEffects({String? userAgent}) {
    return isInstagramInAppBrowser(userAgent: userAgent);
  }
}
