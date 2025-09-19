import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/item.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../data/services/notification_service.dart';

class HomeController extends GetxController {
  HomeController({
    required this.repository,
    required this.notificationService,
    required this.storage,
  });

  final MockRepository repository;
  final NotificationService notificationService;
  final GetStorage storage;

  late final PageController pageController;
  final RxInt currentIndex = 0.obs;
  final RxSet<String> favoriteIds = <String>{}.obs;
  final RxBool reduceEffects = false.obs;
  final RxBool notificationsEnabled = false.obs;
  final RxBool isDarkMode = false.obs;

  List<TrendItem> get allItems => repository.loadExploreItems();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex.value);

    final storedFavorites =
        storage.read<List<dynamic>>('favorites')?.cast<String>() ?? <String>[];
    favoriteIds.addAll(storedFavorites);

    reduceEffects.value = storage.read<bool>('reduceEffects') ?? false;
    notificationsEnabled.value =
        storage.read<bool>('notificationsEnabled') ?? false;

    final storedDarkMode = storage.read<bool>('isDarkMode');
    if (storedDarkMode != null) {
      isDarkMode.value = storedDarkMode;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void onNavTapped(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  void toggleFavorite(String itemId) {
    if (favoriteIds.contains(itemId)) {
      favoriteIds.remove(itemId);
    } else {
      favoriteIds.add(itemId);
    }
    storage.write('favorites', favoriteIds.toList());
  }

  bool isFavorite(String itemId) => favoriteIds.toList().contains(itemId);

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    await storage.write('isDarkMode', value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleReduceEffects(bool value) async {
    reduceEffects.value = value;
    await storage.write('reduceEffects', value);
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    await storage.write('notificationsEnabled', value);
    if (value) {
      await notificationService.requestPermission();
      await notificationService.subscribeToTopic('trendwear_global');
    } else {
      await notificationService.unsubscribeFromTopic('trendwear_global');
    }
  }

  List<TrendItem> favoriteItems() {
    final all = allItems;
    final ids = favoriteIds.toList();
    return all.where((item) => ids.contains(item.id)).toList();
  }
}
