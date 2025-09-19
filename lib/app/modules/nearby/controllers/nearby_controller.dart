// TODO(Geo + Maps): خطوات دمج geolocator + Google Maps/Places
// 1) طلب إذن الموقع وتشغيل Geolocator.getCurrentPosition
// 2) استخدام geohash مع Firestore أو مزود خارجي لاستعلام المتاجر القريبة
// 3) عرض GoogleMap/Mapbox مع Pins وتفاصيل المتجر وخيارات التوجيه
// 4) استخدام lazy loading للصور وربط الـ Directions API للتنقل

import 'package:get/get.dart';

import '../../../data/models/store.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../data/services/location_service.dart';

class NearbyController extends GetxController {
  NearbyController({
    required this.repository,
    required this.locationService,
  });

  final MockRepository repository;
  final LocationService locationService;

  final RxList<Store> stores = <Store>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<StoreLocation?> userLocation = Rx<StoreLocation?>(null);

  @override
  void onInit() {
    super.onInit();
    loadNearbyStores();
  }

  Future<void> loadNearbyStores() async {
    isLoading.value = true;
    final location = await locationService.getUserLocation();
    userLocation.value = location;
    final loaded = repository.loadNearbyStores().map((store) {
      final distance = locationService.calculateDistanceKm(
        fromLat: location.latitude,
        fromLng: location.longitude,
        toLat: store.latitude,
        toLng: store.longitude,
      );
      return store.copyWith(distanceKm: distance);
    }).toList()
      ..sort((a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));
    stores.assignAll(loaded);
    isLoading.value = false;
  }
}
