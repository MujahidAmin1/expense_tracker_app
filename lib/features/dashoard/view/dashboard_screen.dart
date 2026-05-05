import 'package:expense_tracker_app/features/budgets/controller/budget_ctrl.dart';
import 'package:expense_tracker_app/features/dashoard/widgets/allocations_section.dart';
import 'package:expense_tracker_app/features/dashoard/widgets/dashboard_app_bar.dart';
import 'package:expense_tracker_app/features/dashoard/widgets/expandable_fab.dart';
import 'package:expense_tracker_app/features/dashoard/widgets/portfolio_card.dart';
import 'package:expense_tracker_app/features/dashoard/widgets/recent_ledger_tile.dart';
import 'package:expense_tracker_app/features/dashoard/widgets/spending_trend_chart.dart';
import 'package:expense_tracker_app/features/transaction/controller/transaction_ctrl.dart';
import 'package:expense_tracker_app/features/transaction/view/add_transaction.dart';
import 'package:expense_tracker_app/utils/animated_item.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:expense_tracker_app/utils/navigator_helper.dart';
import 'package:expense_tracker_app/utils/screen_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetListProvider);
    final transactions = ref.watch(transactionListProvider);
    final budgetService = ref.watch(budgetServiceProvider);

    final balance = budgetService.getTotalIncome() - budgetService.getTotalSpent();
    final isDesktop = context.isDesktop;
    final horizontalPad = isDesktop ? 32.0 : (context.isTablet ? 24.0 : 16.0);

    // ── Left Column ────────────────────────────────────────────────────────────
    final leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isDesktop) ...[
          const AnimatedItem(index: 0, child: DashboardAppBar()),
          const SizedBox(height: 24),
        ],

        AnimatedItem(
          index: isDesktop ? 0 : 1,
          child: PortfolioCard(balance: balance, isDesktop: isDesktop),
        ),
        const SizedBox(height: 28),

        if (!isDesktop) ...[
          AnimatedItem(
            index: 2,
            child: _SectionHeader(
              title: 'Allocations',
              actionLabel: 'View All',
              onAction: () {},
            ),
          ),
          const SizedBox(height: 12),
          AnimatedItem(
            index: 3,
            child: AllocationsSection(
              budgets: budgets,
              budgetService: budgetService,
              horizontal: true,
            ),
          ),
          const SizedBox(height: 32),
        ],

        AnimatedItem(
          index: isDesktop ? 1 : 4,
          child: SpendingTrendChart(
            dailyData: budgetService.getDailySpendingForWeek(),
          ),
        ),
        const SizedBox(height: 32),

        AnimatedItem(
          index: isDesktop ? 2 : 5,
          child: _SectionHeader(title: 'Recent Ledger', actionLabel: 'VIEW ALL', onAction: () {}),
        ),
        const SizedBox(height: 12),

        if (transactions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            alignment: Alignment.center,
            child: const Text(
              'No transactions yet',
              style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w500),
            ),
          )
        else
          ...transactions.take(5).mapIndexed(
            (i, t) => AnimatedItem(
              index: isDesktop ? 3 + i : 6 + i,
              child: RecentLedgerTile(transaction: t),
            ),
          ),

        const SizedBox(height: 80),
      ],
    );

    // ── Right Column (desktop only) ─────────────────────────────────────────
    final rightColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedItem(
          index: 1,
          child: _SectionHeader(title: 'Allocations', actionLabel: 'View All', onAction: () {}),
        ),
        const SizedBox(height: 12),
        AnimatedItem(
          index: 2,
          child: AllocationsSection(
            budgets: budgets,
            budgetService: budgetService,
            horizontal: false,
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      floatingActionButton: !isDesktop
          ? FloatingActionButton(
              onPressed: () => context.push(const AddTransactionScreen()),
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.add, color: AppColors.white),
            )
          : null,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 6, child: leftColumn),
                            const SizedBox(width: 32),
                            Expanded(flex: 4, child: rightColumn),
                          ],
                        )
                      : leftColumn,
                ),
              ),
            ),
          ),
          if (!isDesktop)
            ExpandableFab(
              onManualEntry: () => context.push(const AddTransactionScreen()),
              onScanReceipt: () {},
              onAttachFile: () {},
            ),
        ],
      ),
    );
  }
}

// ── Reusable section header ────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.darkText,
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBlue,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Extension to map with index ────────────────────────────────────────────────
extension _IndexedMap<T> on Iterable<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T item) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}
