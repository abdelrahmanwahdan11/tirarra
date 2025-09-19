import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/glass_widgets.dart';
import '../controllers/deals_controller.dart';

class DealsView extends GetView<DealsController> {
  const DealsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text('home.deals'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadDeals,
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () {
            if (controller.deals.isEmpty) {
              return Center(child: Text('deals.empty'.tr));
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              itemCount: controller.deals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final deal = controller.deals[index];
                final timeLeft = controller.remainingTime(deal);
                final progress = controller.progress(deal);
                return GestureDetector(
                  onTap: () => Get.toNamed(Routes.itemDetail, arguments: deal.item),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: deal.item.imageUrl,
                            width: 100,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deal.badgeLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                deal.item.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'deals.discount'.trParams({
                                  'percent': deal.discountPercent.toStringAsFixed(0),
                                }),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(value: progress),
                              const SizedBox(height: 6),
                              Text(
                                'deals.ends_in'.trParams({'time': timeLeft}),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Theme.of(context).hintColor),
                              ),
                            ],
                          ),
                        ),
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
