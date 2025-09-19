import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils.dart';
import '../../../data/models/item.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/glass_widgets.dart';
import '../controllers/explore_controller.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text('home.explore'.tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'explore.headline'.tr,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'explore.subtitle'.tr,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _CategoryScroller(controller: controller),
              const SizedBox(height: 24),
              _SectionHeader(title: 'explore.new_drops'.tr),
              const SizedBox(height: 12),
              _HorizontalCarousel(itemsRx: controller.newDrops),
              const SizedBox(height: 24),
              _SectionHeader(title: 'explore.accessories'.tr),
              const SizedBox(height: 12),
              _AccessoryStrip(controller: controller),
              const SizedBox(height: 24),
              _SectionHeader(title: 'explore.mood_title'.tr),
              const SizedBox(height: 12),
              _MoodSelector(controller: controller),
              const SizedBox(height: 12),
              _MoodGrid(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:
          Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _CategoryScroller extends StatelessWidget {
  const _CategoryScroller({required this.controller});

  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    final categories = controller.categories;
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: EdgeInsets.only(right: index == categories.length - 1 ? 0 : 12),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'explore.items_count'.trParams({
                      'count': controller.baseItems
                          .where((item) => item.category == category)
                          .length
                          .toString(),
                    }),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HorizontalCarousel extends StatelessWidget {
  const _HorizontalCarousel({required this.itemsRx});

  final RxList<TrendItem> itemsRx;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (itemsRx.isEmpty) {
          return Text('general.empty'.tr);
        }
        return SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: itemsRx.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final TrendItem item = itemsRx[index];
              return SizedBox(
                width: 180,
                child: GestureDetector(
                  onTap: () => Get.toNamed(
                    Routes.itemDetail,
                    arguments: item,
                  ),
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
                              placeholder: (context, url) => Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant
                                    .withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Formatters.currency(
                                  item.estimatedPrice ?? item.basePrice,
                                  symbol: '\$',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _AccessoryStrip extends StatelessWidget {
  const _AccessoryStrip({required this.controller});

  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.accessories.isEmpty) {
          return Text('general.empty'.tr);
        }
        return Column(
          children: controller.accessories
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tileColor:
                        Theme.of(context).colorScheme.surface.withOpacity(0.18),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(item.name),
                    subtitle: Text(item.brand),
                    trailing: Text(
                      Formatters.currency(item.estimatedPrice ?? item.basePrice,
                          symbol: '\$'),
                    ),
                    onTap: () => Get.toNamed(Routes.itemDetail, arguments: item),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _MoodSelector extends StatelessWidget {
  const _MoodSelector({required this.controller});

  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: controller.moodTags.keys
            .map(
              (mood) => ChoiceChip(
                label: Text('explore.mood.$mood'.tr),
                selected: controller.selectedMood.value == mood,
                onSelected: (_) => controller.selectMood(mood),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MoodGrid extends StatelessWidget {
  const _MoodGrid({required this.controller});

  final ExploreController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.moodPicks.isEmpty) {
          return Text('general.empty'.tr);
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.moodPicks.length,
          padding: const EdgeInsets.only(top: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, index) {
            final item = controller.moodPicks[index];
            return GestureDetector(
              onTap: () => Get.toNamed(Routes.itemDetail, arguments: item),
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(item.brand, style: Theme.of(context).textTheme.bodySmall),
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
    );
  }
}
