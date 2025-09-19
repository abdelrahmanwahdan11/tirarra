import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/home/controllers/home_controller.dart';
import 'app_theme.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.alignment,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final homeController =
        Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    if (homeController == null) {
      return _buildCard(context, reduce: false);
    }
    return Obx(() => _buildCard(context, reduce: homeController.reduceEffects.value));
  }

  Widget _buildCard(BuildContext context, {required bool reduce}) {
    final glassTheme = Theme.of(context).extension<GlassTheme>();
    return Container(
      margin: margin,
      alignment: alignment,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: reduce ? (glassTheme?.blurSigma ?? 16) / 3 : glassTheme?.blurSigma ?? 16,
            sigmaY: reduce ? (glassTheme?.blurSigma ?? 16) / 3 : glassTheme?.blurSigma ?? 16,
          ),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (glassTheme?.tintColor ?? Colors.white.withOpacity(0.2))
                  .withOpacity(
                reduce ? (glassTheme?.opacity ?? 0.2) / 2 : glassTheme?.opacity ?? 0.2,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  spreadRadius: -4,
                  offset: const Offset(0, 12),
                  color: Colors.black.withOpacity(0.08),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);

  @override
  Widget build(BuildContext context) {
    final homeController =
        Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    if (homeController == null) {
      return _buildAppBar(context, reduce: false);
    }
    return Obx(() => _buildAppBar(context, reduce: homeController.reduceEffects.value));
  }

  Widget _buildAppBar(BuildContext context, {required bool reduce}) {
    final glassTheme = Theme.of(context).extension<GlassTheme>();
    final blur = reduce ? (glassTheme?.blurSigma ?? 16) / 3 : glassTheme?.blurSigma ?? 16;
    final opacity = reduce ? (glassTheme?.opacity ?? 0.2) / 2 : glassTheme?.opacity ?? 0.2;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blur,
              sigmaY: blur,
            ),
            child: Container(
              height: preferredSize.height,
              decoration: BoxDecoration(
                color: (glassTheme?.tintColor ?? Colors.white.withOpacity(0.2))
                    .withOpacity(opacity),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: centerTitle,
                title: title,
                leading: leading,
                actions: actions,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassBottomNavigationBar extends StatelessWidget {
  const GlassBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final homeController =
        Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    if (homeController == null) {
      return _buildNav(context, reduce: false);
    }
    return Obx(() => _buildNav(context, reduce: homeController.reduceEffects.value));
  }

  Widget _buildNav(BuildContext context, {required bool reduce}) {
    final glassTheme = Theme.of(context).extension<GlassTheme>();
    final blur = reduce ? (glassTheme?.blurSigma ?? 16) / 3 : glassTheme?.blurSigma ?? 16;
    final opacity = reduce ? (glassTheme?.opacity ?? 0.2) / 2 : glassTheme?.opacity ?? 0.2;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
          ),
          child: BottomNavigationBar(
            items: items,
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor:
                (glassTheme?.tintColor ?? Colors.white).withOpacity(opacity),
            elevation: 0,
            selectedLabelStyle:
                Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
            unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
