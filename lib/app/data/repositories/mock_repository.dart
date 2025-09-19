import 'dart:math';

import '../models/auction.dart';
import '../models/deal.dart';
import '../models/item.dart';
import '../models/store.dart';

class MockRepository {
  MockRepository();

  final Random _random = Random(23);

  List<TrendItem> loadTrendingItems() {
    final now = DateTime.now();
    return _baseItems.map((item) {
      final score = 0.45 * item.metrics.views +
          0.25 * item.metrics.saves +
          0.15 * item.metrics.shares +
          0.15 * item.metrics.clicks +
          max(0, 72 - now.difference(item.metrics.lastInteraction).inHours) * 1.2;
      return item.copyWith(
        estimatedPrice: item.basePrice * (1.05 + _random.nextDouble() * 0.25),
        trendScore: score,
      );
    }).toList();
  }

  List<TrendItem> loadExploreItems() {
    return _baseItems;
  }

  List<Store> loadNearbyStores() {
    return _stores;
  }

  List<Auction> loadAuctions() {
    return _auctions;
  }

  List<Deal> loadDeals() {
    return _deals;
  }

  List<TrendItem> get _baseItems => [
        TrendItem(
          id: 'item_1',
          name: 'Aurora Haze Bomber',
          category: 'Jackets',
          brand: 'Nebula Atelier',
          description:
              'Gradient satin bomber with reflective trims and insulated mesh lining.',
          basePrice: 320,
          imageUrl:
              'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=800&q=80',
          tags: const ['bomber', 'streetwear', 'unisex'],
          metrics: TrendMetrics(
            views: 1220,
            saves: 480,
            shares: 210,
            clicks: 340,
            lastInteraction: DateTime.now().subtract(const Duration(hours: 6)),
          ),
          storeId: 'store_1',
          dropDate: DateTime.now().subtract(const Duration(days: 1)),
          rating: 4.8,
        ),
        TrendItem(
          id: 'item_2',
          name: 'Velvet Flux Boots',
          category: 'Footwear',
          brand: 'Orbit Lace',
          description:
              'High-ankle boots with memory foam sole and interchangeable holographic straps.',
          basePrice: 410,
          imageUrl:
              'https://images.unsplash.com/photo-1514996937319-344454492b37?auto=format&fit=crop&w=800&q=80',
          tags: const ['boots', 'limited', 'drops'],
          metrics: TrendMetrics(
            views: 980,
            saves: 540,
            shares: 260,
            clicks: 420,
            lastInteraction: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          storeId: 'store_2',
          dropDate: DateTime.now().subtract(const Duration(days: 2)),
          rating: 4.6,
        ),
        TrendItem(
          id: 'item_3',
          name: 'Prism Pulse Tote',
          category: 'Bags',
          brand: 'Luma Line',
          description:
              'Semi-transparent tote with modular pockets and recycled marine nylon base.',
          basePrice: 220,
          imageUrl:
              'https://images.unsplash.com/photo-1521572166865-93b36db37c12?auto=format&fit=crop&w=800&q=80',
          tags: const ['bag', 'sustainable'],
          metrics: TrendMetrics(
            views: 1450,
            saves: 620,
            shares: 310,
            clicks: 510,
            lastInteraction: DateTime.now().subtract(const Duration(hours: 4)),
          ),
          storeId: 'store_3',
          dropDate: DateTime.now().subtract(const Duration(days: 3)),
          rating: 4.9,
        ),
        TrendItem(
          id: 'item_4',
          name: 'Chrono-Wrap Cuff',
          category: 'Accessories',
          brand: 'Pulsecraft',
          description:
              'Graphene layered cuff with modular smartwatch adapter and e-ink ticker.',
          basePrice: 180,
          imageUrl:
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
          tags: const ['accessory', 'techwear'],
          metrics: TrendMetrics(
            views: 760,
            saves: 320,
            shares: 140,
            clicks: 205,
            lastInteraction: DateTime.now().subtract(const Duration(hours: 8)),
          ),
          storeId: 'store_2',
          dropDate: DateTime.now().subtract(const Duration(days: 5)),
          rating: 4.4,
        ),
        TrendItem(
          id: 'item_5',
          name: 'Nebula Flow Set',
          category: 'Athleisure',
          brand: 'Motion Arc',
          description:
              'Two-piece seamless set with adaptive cooling mesh and reflective seams.',
          basePrice: 260,
          imageUrl:
              'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
          tags: const ['athleisure', 'set'],
          metrics: TrendMetrics(
            views: 890,
            saves: 410,
            shares: 185,
            clicks: 295,
            lastInteraction: DateTime.now().subtract(const Duration(hours: 12)),
          ),
          storeId: 'store_1',
          dropDate: DateTime.now().subtract(const Duration(days: 4)),
          rating: 4.7,
        ),
      ];

  List<Store> get _stores => [
        Store(
          id: 'store_1',
          name: 'Neon District Flagship',
          address: 'Downtown D3, Neon District',
          latitude: 25.1972,
          longitude: 55.2744,
          imageUrl:
              'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800&q=80',
          phone: '+971-555-112233',
          website: 'https://neondistrict.example.com',
          distanceKm: 2.4,
          openingHours: '10:00 - 22:00',
        ),
        Store(
          id: 'store_2',
          name: 'Skyline Collective',
          address: 'Highline Mall Level 3',
          latitude: 25.2048,
          longitude: 55.2708,
          imageUrl:
              'https://images.unsplash.com/photo-1529333166437-7750a6dd5a70?auto=format&fit=crop&w=800&q=80',
          phone: '+971-555-998877',
          website: 'https://skylinecollective.example.com',
          distanceKm: 4.2,
          openingHours: '11:00 - 23:00',
        ),
        Store(
          id: 'store_3',
          name: 'The Loop Boutique',
          address: 'Arts Avenue, Warehouse 9',
          latitude: 25.1800,
          longitude: 55.2600,
          imageUrl:
              'https://images.unsplash.com/photo-1521335629791-ce4aec67dd47?auto=format&fit=crop&w=800&q=80',
          distanceKm: 5.8,
          openingHours: '12:00 - 21:00',
        ),
      ];

  List<Auction> get _auctions => [
        Auction(
          id: 'auction_1',
          item: _baseItems.first,
          startingPrice: 320,
          currentPrice: 360,
          endTime: DateTime.now().add(const Duration(hours: 5)),
          minIncrement: 20,
          bids: const [
            AuctionBid(userId: 'user_1', amount: 330, timestamp: DateTime(2024, 5, 12, 10, 0)),
            AuctionBid(userId: 'user_2', amount: 350, timestamp: DateTime(2024, 5, 12, 11, 0)),
            AuctionBid(userId: 'user_3', amount: 360, timestamp: DateTime(2024, 5, 12, 12, 0)),
          ],
          isLive: true,
        ),
        Auction(
          id: 'auction_2',
          item: _baseItems[1],
          startingPrice: 410,
          currentPrice: 450,
          endTime: DateTime.now().add(const Duration(hours: 2)),
          minIncrement: 25,
          bids: const [
            AuctionBid(userId: 'user_4', amount: 430, timestamp: DateTime(2024, 5, 12, 8, 0)),
            AuctionBid(userId: 'user_5', amount: 450, timestamp: DateTime(2024, 5, 12, 9, 30)),
          ],
          isLive: true,
        ),
      ];

  List<Deal> get _deals => [
        Deal(
          id: 'deal_1',
          item: _baseItems[2],
          discountPercent: 25,
          startTime: DateTime.now().subtract(const Duration(hours: 1)),
          endTime: DateTime.now().add(const Duration(hours: 11)),
          badgeLabel: 'Flash 25%',
        ),
        Deal(
          id: 'deal_2',
          item: _baseItems[3],
          discountPercent: 18,
          startTime: DateTime.now().subtract(const Duration(hours: 3)),
          endTime: DateTime.now().add(const Duration(hours: 5)),
          badgeLabel: 'Evening Drop',
        ),
      ];
}
