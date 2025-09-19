import 'package:get/get.dart';

import '../../../data/models/item.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../data/repositories/price_estimator.dart';
import '../../../data/repositories/trend_engine.dart';
import '../../home/controllers/home_controller.dart';
import '../../../routes/app_routes.dart';

class TrendingController extends GetxController {
  TrendingController({
    required this.repository,
    required this.trendEngine,
    required this.priceEstimator,
    required this.homeController,
  });

  final MockRepository repository;
  final TrendEngine trendEngine;
  final PriceEstimator priceEstimator;
  final HomeController homeController;

  final RxList<TrendItem> items = <TrendItem>[].obs;
  final RxList<TrendItem> visibleItems = <TrendItem>[].obs;
  final RxSet<String> selectedCategories = <String>{}.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  List<String> get categories =>
      items.map((item) => item.category).toSet().toList()..sort();

  @override
  void onInit() {
    super.onInit();
    loadTrendingItems();
  }

  Future<void> loadTrendingItems() async {
    isLoading.value = true;
    final loaded = repository.loadTrendingItems().map((item) {
      final estimated = priceEstimator.estimate(item);
      return trendEngine.applyScore(item.copyWith(estimatedPrice: estimated));
    }).toList();
    items.assignAll(loaded);
    _applyFilters();
    isLoading.value = false;
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    _applyFilters();
  }

  void updateSearch(String value) {
    searchQuery.value = value;
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchQuery.value.toLowerCase();
    final categoriesFilter = selectedCategories.toSet();
    final filtered = items.where((item) {
      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.brand.toLowerCase().contains(query) ||
          item.tags.any((tag) => tag.toLowerCase().contains(query));
      final matchesCategory = categoriesFilter.isEmpty ||
          categoriesFilter.contains(item.category);
      return matchesQuery && matchesCategory;
    }).toList();
    filtered.sort(
      (a, b) => (b.trendScore ?? 0).compareTo(a.trendScore ?? 0),
    );
    visibleItems.assignAll(filtered);
  }

  void openItem(TrendItem item) {
    Get.toNamed(
      Routes.itemDetail,
      arguments: item,
      preventDuplicates: false,
    );
  }

  void toggleFavorite(String itemId) {
    homeController.toggleFavorite(itemId);
    items.refresh();
    visibleItems.refresh();
  }

  bool isFavorite(String itemId) => homeController.isFavorite(itemId);
}
