import 'package:expense_tracker_app/features/btm_navbar/btm_nav_ctrl.dart';
import 'package:expense_tracker_app/features/budgets/view/budget_view.dart';
import 'package:expense_tracker_app/features/dashoard/view/dashboard_screen.dart';
import 'package:expense_tracker_app/features/insights/view/insights_screen.dart';
import 'package:expense_tracker_app/features/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BtmNavbar extends ConsumerWidget {
  const BtmNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentScreen = ref.watch(currentScreenProvider) ?? 0;
    List<Widget> screens = [
      DashboardScreen(),
      BudgetsView(),
      InsightsScreen(),
      SettingsScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: currentScreen, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        onDestinationSelected: (value) {
          navigateTo(ref, value);
        },
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
