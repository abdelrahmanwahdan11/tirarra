import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/repositories/mock_repository.dart';
import '../data/repositories/price_estimator.dart';
import '../data/repositories/trend_engine.dart';
import '../data/services/location_service.dart';
import '../data/services/notification_service.dart';
import '../modules/admin/controllers/admin_controller.dart';
import '../modules/auctions/controllers/auction_detail_controller.dart';
import '../modules/auctions/controllers/auctions_controller.dart';
import '../modules/deals/controllers/deals_controller.dart';
import '../modules/explore/controllers/explore_controller.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/item_detail/controllers/item_detail_controller.dart';
import '../modules/nearby/controllers/nearby_controller.dart';
import '../modules/onboarding/controllers/onboarding_controller.dart';
import '../modules/profile/controllers/profile_controller.dart';
import '../modules/trending/controllers/trending_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GetStorage>(GetStorage(), permanent: true);
    Get.put<MockRepository>(MockRepository(), permanent: true);
    Get.put<TrendEngine>(const TrendEngine(), permanent: true);
    Get.put<PriceEstimator>(PriceEstimator(), permanent: true);
    Get.put<LocationService>(const MockLocationService(), permanent: true);
    Get.put<NotificationService>(const MockNotificationService(), permanent: true);
  }

  static BindingsBuilder onboarding() {
    return BindingsBuilder(() {
      Get.lazyPut<OnboardingController>(OnboardingController.new);
    });
  }

  static BindingsBuilder home() {
    return BindingsBuilder(() {
      Get.lazyPut<HomeController>(
        () => HomeController(
          repository: Get.find<MockRepository>(),
          notificationService: Get.find<NotificationService>(),
          storage: Get.find<GetStorage>(),
        ),
        fenix: true,
      );
      Get.lazyPut<TrendingController>(
        () => TrendingController(
          repository: Get.find<MockRepository>(),
          trendEngine: Get.find<TrendEngine>(),
          priceEstimator: Get.find<PriceEstimator>(),
          homeController: Get.find<HomeController>(),
        ),
        fenix: true,
      );
      Get.lazyPut<ExploreController>(
        () => ExploreController(
          repository: Get.find<MockRepository>(),
          priceEstimator: Get.find<PriceEstimator>(),
          trendEngine: Get.find<TrendEngine>(),
        ),
        fenix: true,
      );
      Get.lazyPut<NearbyController>(
        () => NearbyController(
          repository: Get.find<MockRepository>(),
          locationService: Get.find<LocationService>(),
        ),
        fenix: true,
      );
      Get.lazyPut<AuctionsController>(
        () => AuctionsController(repository: Get.find<MockRepository>()),
        fenix: true,
      );
      Get.lazyPut<DealsController>(
        () => DealsController(repository: Get.find<MockRepository>()),
        fenix: true,
      );
      Get.lazyPut<ProfileController>(
        () => ProfileController(
          homeController: Get.find<HomeController>(),
          storage: Get.find<GetStorage>(),
        ),
        fenix: true,
      );
      Get.lazyPut<AdminController>(
        () => AdminController(repository: Get.find<MockRepository>()),
        fenix: true,
      );
      Get.lazyPut<ItemDetailController>(
        () => ItemDetailController(
          priceEstimator: Get.find<PriceEstimator>(),
          homeController: Get.find<HomeController>(),
        ),
        fenix: true,
      );
      Get.lazyPut<AuctionDetailController>(
        AuctionDetailController.new,
        fenix: true,
      );
    });
  }
}
