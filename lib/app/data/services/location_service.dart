// TODO(Geo + Maps): خطوات دمج geolocator + Google Maps/Places
// 1) إضافة حزمة geolocator و google_maps_flutter + google_place في pubspec
// 2) طلب أذونات الموقع عبر Geolocator.requestPermission وتوثيقها في AndroidManifest و Info.plist
// 3) استخدام geohash أو GeoQueries في Firestore لجلب المتاجر القريبة
// 4) عرض الخريطة عبر GoogleMap widget ووضع Pins ديناميكية + Lazy loading للصور
//    وثائق: https://pub.dev/packages/geolocator و https://firebase.google.com/docs/firestore/solutions/geoqueries

import 'dart:math';

abstract class LocationService {
  Future<StoreLocation> getUserLocation();
  double calculateDistanceKm({required double fromLat, required double fromLng, required double toLat, required double toLng});
}

class StoreLocation {
  const StoreLocation({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class MockLocationService implements LocationService {
  const MockLocationService();

  @override
  Future<StoreLocation> getUserLocation() async {
    return const StoreLocation(latitude: 25.2048, longitude: 55.2708);
  }

  @override
  double calculateDistanceKm({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) {
    const earthRadiusKm = 6371;
    final dLat = _toRadians(toLat - fromLat);
    final dLng = _toRadians(toLng - fromLng);
    final a =
        (sin(dLat / 2) * sin(dLat / 2)) + cos(_toRadians(fromLat)) * cos(_toRadians(toLat)) * (sin(dLng / 2) * sin(dLng / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _toRadians(double degree) => degree * pi / 180;
}
