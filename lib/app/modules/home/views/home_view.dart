import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/glass_widgets.dart';
import '../../auctions/views/auctions_view.dart';
import '../../deals/views/deals_view.dart';
import '../../explore/views/explore_view.dart';
import '../../nearby/views/nearby_view.dart';
import '../../profile/views/profile_view.dart';
import '../../trending/views/trending_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBody: true,
        body: PageView(
          controller: controller.pageController,
          onPageChanged: controller.changeTab,
          physics: const BouncingScrollPhysics(),
          children: const [
            TrendingView(),
            ExploreView(),
            NearbyView(),
            AuctionsView(),
            DealsView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: GlassBottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.onNavTapped,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_fire_department_rounded),
              label: 'home.trending'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.explore_outlined),
              label: 'home.explore'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.place_outlined),
              label: 'home.nearby'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.gavel_rounded),
              label: 'home.auctions'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_offer_outlined),
              label: 'home.deals'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              label: 'home.profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
