import 'package:expense_tracker_app/features/navbar/nav_ctrl.dart';
import 'package:expense_tracker_app/features/transaction/view/add_transaction.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:expense_tracker_app/utils/navigator_helper.dart';
import 'package:expense_tracker_app/utils/screen_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DesktopLayout extends ConsumerWidget {
  const DesktopLayout({
    super.key,
    required this.currentScreen,
    required this.screens,
  });

  final int currentScreen;
  final List<Widget> screens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extended = context.isDesktop;

    return Scaffold(
      body: Row(
        children: [
          _SideNav(
            currentIndex: currentScreen,
            extended: extended,
            onDestinationSelected: (i) => navigateTo(ref, i),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: screens[currentScreen],
            ),
          ),
        ],
      ),
    );
  }
}


class _SideNav extends StatelessWidget {
  final int currentIndex;
  final bool extended;
  final ValueChanged<int> onDestinationSelected;

  const _SideNav({
    required this.currentIndex,
    required this.extended,
    required this.onDestinationSelected,
  });

  static const _destinations = [
    _NavDestination(label: 'Dashboard', svgIcon: 'assets/svgs/overview.svg', svgActive: 'assets/svgs/overview_filled.svg'),
    _NavDestination(label: 'Budget',    svgIcon: 'assets/svgs/budgets.svg',   svgActive: 'assets/svgs/budgets_filled.svg'),
    _NavDestination(label: 'Insights',  svgIcon: 'assets/svgs/insights.svg',  svgActive: 'assets/svgs/insights_filled.svg'),
    _NavDestination(label: 'Settings',  svgIcon: 'assets/svgs/settings.svg',  svgActive: 'assets/svgs/settings_filled.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: extended ? 220 : 72,
      color: AppColors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo / Brand
            SizedBox(
              height: 72,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: extended ? 20 : 0),
                child: extended
                    ? const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sovereign\nLedger',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryBlue,
                            height: 1.2,
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.account_balance, color: AppColors.white, size: 18),
                        ),
                      ),
              ),
            ),

            const Divider(height: 1),
            
            if (context.isDesktop)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: _NewActionBtn(extended: extended),
              ),

            const SizedBox(height: 4),
            ...List.generate(_destinations.length, (i) {
              final dest = _destinations[i];
              final isSelected = i == currentIndex;
              return _NavItem(
                destination: dest,
                isSelected: isSelected,
                extended: extended,
                onTap: () => onDestinationSelected(i),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _NavDestination {
  final String label;
  final String svgIcon;
  final String svgActive;

  const _NavDestination({
    required this.label,
    required this.svgIcon,
    required this.svgActive,
  });
}

class _NavItem extends StatefulWidget {
  final _NavDestination destination;
  final bool isSelected;
  final bool extended;
  final VoidCallback onTap;

  const _NavItem({
    required this.destination,
    required this.isSelected,
    required this.extended,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    final bgColor = isSelected
        ? AppColors.primaryBlue.withValues(alpha: 0.1)
        : _hovered
            ? AppColors.primaryBlue.withValues(alpha: 0.07)
            : Colors.transparent;

    final iconColor = isSelected ? AppColors.primaryBlue : AppColors.textGrey;
    final labelColor = isSelected ? AppColors.primaryBlue : AppColors.darkText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.25), width: 1)
                  : null,
            ),
            child: Row(
              mainAxisAlignment: widget.extended ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                // Active indicator bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 3,
                  height: isSelected ? 28 : 0,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                  ),
                ),
                // Icon
                SvgPicture.asset(
                  isSelected ? widget.destination.svgActive : widget.destination.svgIcon,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                if (widget.extended) ...[
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.destination.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: labelColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _NewActionBtn extends StatelessWidget {
  final bool extended;
  const _NewActionBtn({required this.extended});

  @override
  Widget build(BuildContext context) {
    if (!extended) {
      return Center(
        child: InkWell(
          onTap: () => context.push(const AddTransactionScreen()),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: AppColors.white, size: 24),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => context.push(const AddTransactionScreen()),
        icon: const Icon(Icons.add, size: 20),
        label: const Text(
          'Create Transaction',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          elevation: 4,
          shadowColor: AppColors.primaryBlue.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
