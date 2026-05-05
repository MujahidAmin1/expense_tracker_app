import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/features/transaction/controller/transaction_ctrl.dart';
import 'package:expense_tracker_app/features/transaction/model/transaction.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:expense_tracker_app/utils/thousands_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker_app/features/transaction/view/transaction_detail_screen.dart';

class CategoryTransactionsScreen extends ConsumerWidget {
  final CategoryType category;

  const CategoryTransactionsScreen({
    super.key,
    required this.category,
  });

  IconData _iconForCategory(CategoryType category) => switch (category) {
        CategoryType.food => Icons.restaurant,
        CategoryType.travel => Icons.directions_bus,
        CategoryType.subscription => Icons.subscriptions,
        CategoryType.shop => Icons.shopping_bag_outlined,
        CategoryType.utility => Icons.home_rounded,
        CategoryType.other => Icons.more_horiz,
      };

  Color _colorForCategory(CategoryType category) => switch (category) {
        CategoryType.food => const Color(0xFFE53935),
        CategoryType.travel => AppColors.primaryBlue,
        CategoryType.subscription => const Color(0xFF7B1FA2),
        CategoryType.shop => const Color(0xFFFF8F00),
        CategoryType.utility => const Color(0xFF1565C0),
        CategoryType.other => AppColors.textGrey,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionService = ref.watch(transactionRepositoryProvider);
    final transactions = transactionService.getByCategory(category);
    final categoryColor = _colorForCategory(category);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundGrey,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _iconForCategory(category),
                color: categoryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              category.name[0].toUpperCase() + category.name.substring(1),
              style: const TextStyle(
                color: AppColors.darkText,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: AppColors.symbolGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Transactions in this category will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _TransactionTile(
                  transaction: transaction,
                  categoryColor: categoryColor,
                );
              },
            ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final Color categoryColor;

  const _TransactionTile({
    required this.transaction,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TransactionDetailScreen(transaction: transaction),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.categoryBorder),
          ),
          child: Row(
            children: [
              // Amount Circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: transaction.type == TransactionType.expense
                      ? categoryColor.withOpacity(0.1)
                      : const Color(0xFF43A047).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    transaction.type == TransactionType.expense ? '-' : '+',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: transaction.type == TransactionType.expense
                          ? categoryColor
                          : const Color(0xFF43A047),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              
              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.note ?? 'No note',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          DateFormat('MMM dd, yyyy').format(transaction.date),
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (transaction.isRecurring) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.sync,
                                  size: 10,
                                  color: AppColors.primaryBlue,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  transaction.recurrence?.name.toUpperCase() ?? '',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryBlue,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Amount
              Text(
                '${transaction.type == TransactionType.expense ? '-' : '+'}${AppFormatter.currency(transaction.amount, decimalDigits: 0)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: transaction.type == TransactionType.expense
                      ? categoryColor
                      : const Color(0xFF43A047),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
