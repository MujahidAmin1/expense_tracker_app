import 'package:expense_tracker_app/features/budgets/models/budget.dart';
import 'package:expense_tracker_app/features/transaction/model/transaction.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:expense_tracker_app/utils/thousands_formatter.dart';
import 'package:expense_tracker_app/utils/screen_sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  IconData get _icon => switch (transaction.category) {
        CategoryType.food => Icons.restaurant,
        CategoryType.travel => Icons.directions_bus,
        CategoryType.subscription => Icons.subscriptions,
        CategoryType.shop => Icons.shopping_bag_outlined,
        CategoryType.utility => Icons.home_rounded,
        CategoryType.other => Icons.more_horiz,
      };

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final amountColor = isExpense ? const Color(0xFFE53935) : const Color(0xFF2E7D32);
    final sign = isExpense ? '-' : '+';
    final isDesktop = context.isDesktop || context.isTablet;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Hero(
          tag: 'tx_icon_${transaction.id}',
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _icon,
              size: 48,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          transaction.note != null && transaction.note!.isNotEmpty
              ? transaction.note!
              : transaction.category.name[0].toUpperCase() + transaction.category.name.substring(1),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.darkText,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '$sign${AppFormatter.currency(transaction.amount)}',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: amountColor,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.categoryBorder),
          ),
          child: Column(
            children: [
              _buildDetailRow('Category', transaction.category.name.toUpperCase()),
              const Divider(height: 32, color: AppColors.categoryBorder),
              _buildDetailRow('Date', DateFormat('MMMM d, yyyy').format(transaction.date)),
              const Divider(height: 32, color: AppColors.categoryBorder),
              _buildDetailRow('Time', DateFormat.jm().format(transaction.date)),
              if (transaction.isRecurring) ...[
                const Divider(height: 32, color: AppColors.categoryBorder),
                _buildDetailRow('Recurring', transaction.recurrence?.name.toUpperCase() ?? 'YES'),
              ]
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundGrey,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('Transaction Details', style: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: isDesktop
            ? Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: content,
                ),
              )
            : content,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.darkText,
          ),
        ),
      ],
    );
  }
}
