import 'package:get/get.dart';

import '../core/bindings.dart';
import '../modules/admin/views/admin_view.dart';
import '../modules/auctions/views/auction_detail_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/item_detail/views/item_detail_view.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.onboarding;

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: InitialBinding.onboarding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: InitialBinding.home(),
    ),
    GetPage(
      name: Routes.itemDetail,
      page: () => const ItemDetailView(),
    ),
    GetPage(
      name: Routes.auctionDetail,
      page: () => const AuctionDetailView(),
    ),
    GetPage(
      name: Routes.admin,
      page: () => const AdminView(),
    ),
  ];
}
