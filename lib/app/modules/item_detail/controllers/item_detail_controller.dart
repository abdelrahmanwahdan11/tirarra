import 'package:get/get.dart';

import '../../../data/models/item.dart';
import '../../../data/repositories/price_estimator.dart';
import '../../home/controllers/home_controller.dart';

class ItemDetailController extends GetxController {
  ItemDetailController({
    required this.priceEstimator,
    required this.homeController,
  });

  final PriceEstimator priceEstimator;
  final HomeController homeController;

  late final Rx<TrendItem> item;

  bool get isFavorite => homeController.isFavorite(item.value.id);

  @override
  void onInit() {
    super.onInit();
    final TrendItem initialItem = Get.arguments as TrendItem;
    item = initialItem
        .copyWith(estimatedPrice: priceEstimator.estimate(initialItem))
        .obs;
  }

  void toggleFavorite() {
    homeController.toggleFavorite(item.value.id);
    item.refresh();
  }
}
