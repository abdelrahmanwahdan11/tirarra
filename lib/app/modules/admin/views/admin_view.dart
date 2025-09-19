import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils.dart';
import '../../../theme/glass_widgets.dart';
import '../controllers/admin_controller.dart';

class AdminView extends GetView<AdminController> {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
        title: Text('admin.title'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.recomputePreview,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'admin.weights'.tr,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _WeightSlider(
                label: 'Views',
                value: controller.viewsWeight,
                onChanged: (value) {
                  controller.viewsWeight.value = value;
                  controller.recomputePreview();
                },
              ),
              _WeightSlider(
                label: 'Saves',
                value: controller.savesWeight,
                onChanged: (value) {
                  controller.savesWeight.value = value;
                  controller.recomputePreview();
                },
              ),
              _WeightSlider(
                label: 'Shares',
                value: controller.sharesWeight,
                onChanged: (value) {
                  controller.sharesWeight.value = value;
                  controller.recomputePreview();
                },
              ),
              _WeightSlider(
                label: 'Clicks',
                value: controller.clicksWeight,
                onChanged: (value) {
                  controller.clicksWeight.value = value;
                  controller.recomputePreview();
                },
              ),
              _WeightSlider(
                label: 'Recency',
                value: controller.recencyBoost,
                onChanged: (value) {
                  controller.recencyBoost.value = value;
                  controller.recomputePreview();
                },
              ),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text('admin.half_life'.trParams({
                      'hours': controller.halfLife.value.toStringAsFixed(0),
                    })),
                    Slider(
                      value: controller.halfLife.value,
                      min: 12,
                      max: 96,
                      divisions: 14,
                      onChanged: (value) {
                        controller.halfLife.value = value;
                        controller.recomputePreview();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'admin.preview'.tr,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Column(
                  children: controller.previewItems
                      .map(
                        (item) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(item.imageUrl),
                          ),
                          title: Text(item.name),
                          subtitle: Text(
                            'admin.score'.trParams({
                              'score': (item.trendScore ?? 0).toStringAsFixed(1),
                            }),
                          ),
                          trailing: Text(
                            Formatters.currency(item.estimatedPrice ?? item.basePrice,
                                symbol: '\$'),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeightSlider extends StatelessWidget {
  const _WeightSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final RxDouble value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label • ${(value.value * 100).toStringAsFixed(0)}%'),
          Slider(
            value: value.value,
            min: 0.05,
            max: 0.6,
            divisions: 11,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
