import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils.dart';
import '../../../theme/glass_widgets.dart';
import '../controllers/nearby_controller.dart';

class NearbyView extends GetView<NearbyController> {
  const NearbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text('home.nearby'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            onPressed: controller.loadNearbyStores,
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.stores.isEmpty) {
              return Center(child: Text('nearby.empty'.tr));
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              itemCount: controller.stores.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final store = controller.stores[index];
                return GlassCard(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        imageUrl: store.imageUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(store.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(store.address, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(
                          Formatters.distance(store.distanceKm ?? 0),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(store.openingHours ?? 'nearby.hours'.tr),
                        ElevatedButton(
                          onPressed: () => Get.snackbar(
                            store.name,
                            'nearby.directions'.tr,
                          ),
                          child: Text('nearby.navigate'.tr),
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
