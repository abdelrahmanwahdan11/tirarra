import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils.dart';
import '../../../data/models/item.dart';
import '../../../theme/glass_widgets.dart';
import '../controllers/trending_controller.dart';

class TrendingView extends GetView<TrendingController> {
  const TrendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text('home.trending'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.loadTrendingItems,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: controller.updateSearch,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: InputBorder.none,
                    hintText: 'general.search'.tr,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: controller.categories
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category),
                              selected: controller.selectedCategories
                                  .contains(category),
                              onSelected: (_) => controller.toggleCategory(category),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(
                  () {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.visibleItems.isEmpty) {
                      return Center(
                        child: Text('general.empty'.tr, textAlign: TextAlign.center),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: controller.loadTrendingItems,
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 96, top: 4),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: controller.visibleItems.length,
                        itemBuilder: (context, index) {
                          final item = controller.visibleItems[index];
                          return _TrendingCard(item: item, controller: controller);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({required this.item, required this.controller});

  final TrendItem item;
  final TrendingController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.openItem(item),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error_outline),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Obx(
                          () => Icon(
                            controller.isFavorite(item.id)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                          ),
                        ),
                        onPressed: () => controller.toggleFavorite(item.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.brand,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.currency(item.estimatedPrice ?? item.basePrice,
                            symbol: '\$'),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.trending_up_rounded, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              Formatters.compactCurrency(item.trendScore ?? 0),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
