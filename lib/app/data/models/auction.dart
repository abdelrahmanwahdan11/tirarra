import 'item.dart';

class AuctionBid {
  const AuctionBid({
    required this.userId,
    required this.amount,
    required this.timestamp,
  });

  final String userId;
  final double amount;
  final DateTime timestamp;
}

class Auction {
  const Auction({
    required this.id,
    required this.item,
    required this.startingPrice,
    required this.currentPrice,
    required this.endTime,
    required this.bids,
    required this.minIncrement,
    this.isLive = false,
  });

  final String id;
  final TrendItem item;
  final double startingPrice;
  final double currentPrice;
  final DateTime endTime;
  final List<AuctionBid> bids;
  final double minIncrement;
  final bool isLive;

  Auction copyWith({
    double? currentPrice,
    List<AuctionBid>? bids,
    bool? isLive,
  }) {
    return Auction(
      id: id,
      item: item,
      startingPrice: startingPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      endTime: endTime,
      bids: bids ?? this.bids,
      minIncrement: minIncrement,
      isLive: isLive ?? this.isLive,
    );
  }
}
