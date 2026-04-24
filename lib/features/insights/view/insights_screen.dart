import 'package:expense_tracker_app/features/insights/view/controller/insight_controller.dart';
import 'package:expense_tracker_app/features/insights/view/widgets/allocation_card.dart';
import 'package:expense_tracker_app/features/insights/view/widgets/total_spent_card.dart';
import 'package:expense_tracker_app/features/insights/view/widgets/top_expense_card.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(insightControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text(
          'Insights',
          style: TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundGrey,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TotalSpentCard(
                totalSpent: state.totalSpent,
                totalBudget: state.totalBudget,
              ),
              const SizedBox(height: 24),
              AllocationCard(
                totalSpent: state.totalSpent,
                categorySpending: state.categorySpending,
              ),
              const SizedBox(height: 24),
              TopExpenseCard(
                categorySpending: state.categorySpending,
              ),
            ],
          ),
        ),
      ),
    );
  }
}