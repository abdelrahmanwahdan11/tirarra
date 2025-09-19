// TODO(Cloud Scheduler + Remote Config):
// 1) جدولة تخفيضات عبر Cloud Functions + Scheduler لتحديث Firestore
// 2) التحكم في نسب الخصم والبدائل عبر Firebase Remote Config
// 3) تشغيل اختبارات A/B لنسخ الرسائل أو زمن العد التنازلي
// 4) تفعيل إشعارات فلاش عبر FCM Topics

import 'dart:async';

import 'package:get/get.dart';

import '../../../core/utils.dart';
import '../../../data/models/deal.dart';
import '../../../data/repositories/mock_repository.dart';

class DealsController extends GetxController {
  DealsController({required this.repository});

  final MockRepository repository;

  final RxList<Deal> deals = <Deal>[].obs;
  final Rx<DateTime> now = DateTime.now().obs;
  Timer? _ticker;

  @override
  void onInit() {
    super.onInit();
    loadDeals();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      now.value = DateTime.now();
    });
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }

  void loadDeals() {
    deals.assignAll(repository.loadDeals());
  }

  String remainingTime(Deal deal) {
    final duration = deal.endTime.difference(now.value);
    return duration.isNegative
        ? '00:00:00'
        : Formatters.countdown(duration);
  }

  double progress(Deal deal) {
    final total = deal.endTime.difference(deal.startTime).inSeconds;
    final elapsed = now.value.difference(deal.startTime).inSeconds;
    if (total <= 0) {
      return 1;
    }
    return (elapsed / total).clamp(0, 1);
  }
}
