import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:expense_tracker_app/features/navbar/nav_ctrl.dart';

class MobileLayout extends ConsumerWidget {
  const MobileLayout({
    super.key,
    required this.currentScreen,
    required this.screens,
  });

  final int currentScreen;
  final List<Widget> screens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: screens[currentScreen],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        onDestinationSelected: (value) => navigateTo(ref, value),
        destinations: [
          NavigationDestination(
            selectedIcon: SvgPicture.asset("assets/svgs/overview_filled.svg"),
            icon: SvgPicture.asset("assets/svgs/overview.svg"),
            label: 'Dashboard',
          ),
          NavigationDestination(
            selectedIcon: SvgPicture.asset("assets/svgs/budgets_filled.svg"),
            icon: SvgPicture.asset("assets/svgs/budgets.svg"),
            label: 'Budget',
          ),
          NavigationDestination(
            selectedIcon: SvgPicture.asset("assets/svgs/insights_filled.svg"),
            icon: SvgPicture.asset("assets/svgs/insights.svg"),
            label: 'Insights',
          ),
          NavigationDestination(
            selectedIcon: SvgPicture.asset("assets/svgs/settings_filled.svg"),
            icon: SvgPicture.asset("assets/svgs/settings.svg"),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
