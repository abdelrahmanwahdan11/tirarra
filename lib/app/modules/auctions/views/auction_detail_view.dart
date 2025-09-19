import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils.dart';
import '../../../theme/glass_widgets.dart';
import '../controllers/auction_detail_controller.dart';

class AuctionDetailView extends GetView<AuctionDetailController> {
  const AuctionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text('auctions.detail_title'.tr),
      ),
      body: SafeArea(
        child: Obx(
          () {
            final auction = controller.auction.value;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: CachedNetworkImage(
                            imageUrl: auction.item.imageUrl,
                            fit: BoxFit.cover,
                            height: 280,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          auction.item.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          auction.item.brand,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        GlassCard(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('auctions.current_bid'.trParams({
                                'amount': Formatters.currency(auction.currentPrice,
                                    symbol: '\$'),
                              })),
                              const SizedBox(height: 4),
                              Obx(
                                () => Text(
                                  'auctions.ends_in'.trParams({
                                    'time': Formatters.countdown(controller.remaining.value),
                                  }),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: Theme.of(context).hintColor),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'auctions.increment'.trParams({
                                  'amount': Formatters.currency(auction.minIncrement,
                                      symbol: '\$'),
                                }),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Theme.of(context).hintColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'auctions.bid_history'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ...controller.sortedBids.map(
                          (bid) => ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            title: Text(Formatters.currency(bid.amount, symbol: '\$')),
                            subtitle: Text(Formatters.dateTime(bid.timestamp)),
                            trailing: const Icon(Icons.check_circle_outline),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.quickBid,
                            icon: const Icon(Icons.add_circle_outline),
                            label: Text('auctions.place_bid'.tr),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
