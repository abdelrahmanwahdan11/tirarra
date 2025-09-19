class TrendMetrics {
  const TrendMetrics({
    required this.views,
    required this.saves,
    required this.shares,
    required this.clicks,
    required this.lastInteraction,
  });

  final int views;
  final int saves;
  final int shares;
  final int clicks;
  final DateTime lastInteraction;
}

class TrendItem {
  const TrendItem({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.description,
    required this.basePrice,
    required this.imageUrl,
    required this.tags,
    required this.metrics,
    required this.storeId,
    required this.dropDate,
    this.estimatedPrice,
    this.rating,
    this.trendScore,
  });

  final String id;
  final String name;
  final String category;
  final String brand;
  final String description;
  final double basePrice;
  final String imageUrl;
  final List<String> tags;
  final TrendMetrics metrics;
  final String storeId;
  final DateTime dropDate;
  final double? estimatedPrice;
  final double? rating;
  final double? trendScore;

  TrendItem copyWith({
    double? estimatedPrice,
    double? trendScore,
  }) {
    return TrendItem(
      id: id,
      name: name,
      category: category,
      brand: brand,
      description: description,
      basePrice: basePrice,
      imageUrl: imageUrl,
      tags: tags,
      metrics: metrics,
      storeId: storeId,
      dropDate: dropDate,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      rating: rating,
      trendScore: trendScore ?? this.trendScore,
    );
  }
}
