import 'dart:async';

import 'package:get/get.dart';

import '../../../data/models/auction.dart';

class AuctionDetailController extends GetxController {
  AuctionDetailController();

  late final Rx<Auction> auction;
  final Rx<Duration> remaining = const Duration().obs;
  Timer? _ticker;

  @override
  void onInit() {
    super.onInit();
    final Auction initialAuction = Get.arguments as Auction;
    auction = initialAuction.obs;
    remaining.value = initialAuction.endTime.difference(DateTime.now());
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = auction.value.endTime.difference(DateTime.now());
      remaining.value = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }

  void placeBid(double increment) {
    final current = auction.value;
    final updatedPrice = current.currentPrice + increment;
    final bid = AuctionBid(
      userId: 'local_user',
      amount: updatedPrice,
      timestamp: DateTime.now(),
    );
    final bids = [...current.bids, bid];
    auction.value = current.copyWith(currentPrice: updatedPrice, bids: bids, isLive: true);
    auction.refresh();
  }

  void quickBid() {
    placeBid(auction.value.minIncrement);
  }

  List<AuctionBid> get sortedBids {
    final bids = [...auction.value.bids];
    bids.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return bids;
  }
}
