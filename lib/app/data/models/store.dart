class Store {
  const Store({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    this.phone,
    this.website,
    this.distanceKm,
    this.openingHours,
  });

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String? phone;
  final String? website;
  final double? distanceKm;
  final String? openingHours;

  Store copyWith({double? distanceKm}) {
    return Store(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
      phone: phone,
      website: website,
      distanceKm: distanceKm ?? this.distanceKm,
      openingHours: openingHours,
    );
  }
}
