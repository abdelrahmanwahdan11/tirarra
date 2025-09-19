import 'package:get/get.dart';

import '../../../data/models/item.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../data/repositories/price_estimator.dart';
import '../../../data/repositories/trend_engine.dart';

class ExploreController extends GetxController {
  ExploreController({
    required this.repository,
    required this.priceEstimator,
    required this.trendEngine,
  });

  final MockRepository repository;
  final PriceEstimator priceEstimator;
  final TrendEngine trendEngine;

  final RxList<TrendItem> newDrops = <TrendItem>[].obs;
  final RxList<TrendItem> accessories = <TrendItem>[].obs;
  final RxList<TrendItem> moodPicks = <TrendItem>[].obs;
  final RxString selectedMood = 'bold'.obs;

  late final List<TrendItem> _baseItems;

  List<TrendItem> get baseItems => _baseItems;

  List<String> get categories {
    final items = _baseItems.isNotEmpty ? _baseItems : repository.loadExploreItems();
    return items.map((item) => item.category).toSet().toList()..sort();
  }

  final Map<String, List<String>> moodTags = {
    'bold': ['bomber', 'boots', 'techwear'],
    'earthy': ['sustainable', 'recycled'],
    'minimal': ['set', 'unisex'],
    'nightout': ['limited', 'drops'],
  };

  @override
  void onInit() {
    super.onInit();
    _baseItems = repository.loadExploreItems().map((item) {
      final estimated = priceEstimator.estimate(item);
      return trendEngine.applyScore(item.copyWith(estimatedPrice: estimated));
    }).toList();

    newDrops.assignAll(_baseItems
        .where((item) => DateTime.now().difference(item.dropDate).inDays <= 3)
        .toList());
    accessories.assignAll(
        _baseItems.where((item) => item.category == 'Accessories').toList());
    _applyMood();
  }

  void selectMood(String mood) {
    selectedMood.value = mood;
    _applyMood();
  }

  void _applyMood() {
    final tags = moodTags[selectedMood.value] ?? <String>[];
    moodPicks.assignAll(
      _baseItems.where(
        (item) => item.tags.any(
          (tag) => tags.any((element) => tag.toLowerCase().contains(element)),
        ),
      ),
    );
  }
}
