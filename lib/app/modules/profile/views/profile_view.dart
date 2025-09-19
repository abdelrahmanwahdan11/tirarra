import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../theme/glass_widgets.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final locales = const [Locale('en'), Locale('ar')];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text('home.profile'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            onPressed: () => Get.toNamed(Routes.admin),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=120&q=60',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'profile.welcome'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'profile.subtitle'.tr,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('profile.preferences'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Obx(
                () => SwitchListTile.adaptive(
                  value: controller.isDarkMode,
                  onChanged: controller.toggleDarkMode,
                  title: Text('general.dark_mode'.tr),
                ),
              ),
              Obx(
                () => SwitchListTile.adaptive(
                  value: controller.reduceEffects,
                  onChanged: controller.toggleReduceEffects,
                  title: Text('general.reduce_motion'.tr),
                ),
              ),
              Obx(
                () => SwitchListTile.adaptive(
                  value: controller.notificationsEnabled,
                  onChanged: controller.toggleNotifications,
                  title: Text('general.notifications'.tr),
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => Wrap(
                  spacing: 12,
                  children: locales
                      .map(
                        (locale) => ChoiceChip(
                          label: Text('locale.${locale.languageCode}'.tr),
                          selected: controller.locale.value == locale,
                          onSelected: (_) => controller.switchLanguage(locale),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'general.favorites'.tr,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(
                () {
                  final favorites = controller.favorites;
                  if (favorites.isEmpty) {
                    return Text('profile.no_favorites'.tr);
                  }
                  return Column(
                    children: favorites
                        .map(
                          (item) => ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: item.imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(item.name),
                            subtitle: Text(item.brand),
                            trailing: Text(
                              '${item.trendScore?.toStringAsFixed(0) ?? '-'}🔥',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
