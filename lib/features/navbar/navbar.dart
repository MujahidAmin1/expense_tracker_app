import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker_app/features/navbar/nav_ctrl.dart';
import 'package:expense_tracker_app/features/budgets/view/budget_view.dart';
import 'package:expense_tracker_app/features/dashoard/view/dashboard_screen.dart';
import 'package:expense_tracker_app/features/insights/view/insights_screen.dart';
import 'package:expense_tracker_app/features/settings/view/settings_screen.dart';
import 'package:expense_tracker_app/layout/desktop_layout.dart';
import 'package:expense_tracker_app/layout/mobile_layout.dart';
import 'package:expense_tracker_app/utils/screen_sizes.dart';

class Navbar extends ConsumerWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentScreen = ref.watch(currentScreenProvider) ?? 0;
    List<Widget> screens = [
      DashboardScreen(key: const ValueKey(0)),
      BudgetsView(key: const ValueKey(1)),
      InsightsScreen(key: const ValueKey(2)),
      SettingsScreen(key: const ValueKey(3)),
    ];

    if (context.isDesktop || context.isTablet) {
      return DesktopLayout(currentScreen: currentScreen, screens: screens);
    }
    return MobileLayout(currentScreen: currentScreen, screens: screens);
  }
}
