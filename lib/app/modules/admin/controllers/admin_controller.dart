import 'package:get/get.dart';

import '../../../data/models/item.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../data/repositories/trend_engine.dart';

class AdminController extends GetxController {
  AdminController({required this.repository});

  final MockRepository repository;

  final RxDouble viewsWeight = 0.35.obs;
  final RxDouble savesWeight = 0.25.obs;
  final RxDouble sharesWeight = 0.2.obs;
  final RxDouble clicksWeight = 0.2.obs;
  final RxDouble recencyBoost = 0.6.obs;
  final RxDouble halfLife = 48.0.obs;

  final RxList<TrendItem> previewItems = <TrendItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    recomputePreview();
  }

  void recomputePreview() {
    final engine = TrendEngine(
      weights: TrendWeights(
        views: viewsWeight.value,
        saves: savesWeight.value,
        shares: sharesWeight.value,
        clicks: clicksWeight.value,
        recencyBoost: recencyBoost.value,
      ),
      recencyHalfLifeHours: halfLife.value.toInt(),
    );
    final items = repository.loadTrendingItems();
    previewItems.assignAll(engine.sortByTrend(items).take(5).toList());
  }
}
