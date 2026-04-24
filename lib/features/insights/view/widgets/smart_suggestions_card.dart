import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SmartSuggestionsCard extends StatelessWidget {
  final Map<CategoryType, double> categorySpending;
  final CategoryType? topOverspentCategory;

  const SmartSuggestionsCard({
    super.key,
    required this.categorySpending,
    this.topOverspentCategory,
  });

  String _formatCategory(CategoryType type) {
    final name = type.name;
    return '${name[0].toUpperCase()}${name.substring(1)}';
  }

  IconData _iconForCategory(CategoryType type) => switch (type) {
        CategoryType.food => Icons.restaurant,
        CategoryType.travel => Icons.directions_bus,
        CategoryType.subscription => Icons.subscriptions,
        CategoryType.shop => Icons.shopping_bag_outlined,
        CategoryType.utility => Icons.home_rounded,
        CategoryType.other => Icons.more_horiz,
      };

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 1);

    // Build dynamic suggestions
    final suggestions = <_Suggestion>[];

    if (topOverspentCategory != null) {
      final name = _formatCategory(topOverspentCategory!);
      final amount = categorySpending[topOverspentCategory!] ?? 0;
      suggestions.add(_Suggestion(
        icon: _iconForCategory(topOverspentCategory!),
        label: '$name Over Budget',
        tag: 'REVIEW',
        tagColor: Colors.red,
        subtitle: 'You\'ve spent ${currencyFormatter.format(amount)} on $name this period.',
        actionText: 'Review Spending ›',
      ));
    }

    // Subscription-specific nudge
    if (categorySpending.containsKey(CategoryType.subscription)) {
      final amount = categorySpending[CategoryType.subscription]!;
      suggestions.add(_Suggestion(
        icon: Icons.subscriptions_outlined,
        label: 'Optimise Subscriptions',
        tag: 'SAVE MORE',
        tagColor: const Color(0xFF1565C0),
        subtitle: 'You\'re spending ${currencyFormatter.format(amount)} on subscriptions. Review recurring charges.',
        actionText: 'Take Action ›',
      ));
    }

    // Generic rebalance suggestion if many categories are active
    if (categorySpending.length >= 3) {
      suggestions.add(_Suggestion(
        icon: Icons.balance_outlined,
        label: 'Rebalance Allocations',
        tag: 'STRATEGY',
        tagColor: const Color(0xFF00796B),
        subtitle: 'You have active spending in ${categorySpending.length} categories. Consider rebalancing.',
        actionText: 'Review Portfolio ›',
      ));
    }

    if (suggestions.isEmpty) {
      suggestions.add(_Suggestion(
        icon: Icons.thumb_up_alt_outlined,
        label: 'Looking Good!',
        tag: 'ON TRACK',
        tagColor: Colors.green,
        subtitle: 'Your spending is within budget. Keep it up!',
        actionText: '',
      ));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Smart Suggestions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...suggestions.map((s) => _SuggestionTile(suggestion: s)),
        ],
      ),
    );
  }
}

class _Suggestion {
  final IconData icon;
  final String label;
  final String tag;
  final Color tagColor;
  final String subtitle;
  final String actionText;

  _Suggestion({
    required this.icon,
    required this.label,
    required this.tag,
    required this.tagColor,
    required this.subtitle,
    required this.actionText,
  });
}

class _SuggestionTile extends StatelessWidget {
  final _Suggestion suggestion;
  const _SuggestionTile({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(suggestion.icon, size: 20, color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  suggestion.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: suggestion.tagColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  suggestion.tag,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: suggestion.tagColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            suggestion.subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGrey,
              height: 1.4,
            ),
          ),
          if (suggestion.actionText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              suggestion.actionText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
