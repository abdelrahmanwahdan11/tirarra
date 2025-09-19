import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils.dart';
import '../../../theme/glass_widgets.dart';
import '../controllers/auctions_controller.dart';

class AuctionsView extends GetView<AuctionsController> {
  const AuctionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text('home.auctions'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.loadAuctions,
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () {
            if (controller.auctions.isEmpty) {
              return Center(child: Text('auctions.empty'.tr));
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              itemCount: controller.auctions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final auction = controller.auctions[index];
                final remaining = auction.endTime.difference(DateTime.now());
                return GestureDetector(
                  onTap: () => controller.openAuction(auction),
                  child: GlassCard(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundImage: NetworkImage(auction.item.imageUrl),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                auction.item.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'auctions.current_bid'.trParams({
                                  'amount': Formatters.currency(auction.currentPrice,
                                      symbol: '\$'),
                                }),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'auctions.ends_in'.trParams({
                                  'time': Formatters.countdown(remaining),
                                }),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Theme.of(context).hintColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
