import 'package:flutter/material.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:expense_tracker_app/utils/thousands_formatter.dart';

class MonthlyBurnCard extends StatelessWidget {
  const MonthlyBurnCard({
    super.key,
    required this.totalSpent,
    required this.spentPct,
    required this.totalLimit,
    required this.totalRemaining,
    required this.onTrack,
  });

  final double totalSpent;
  final double spentPct;
  final double totalLimit;
  final double totalRemaining;
  final bool onTrack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF002952), Color(0xFF004080)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MONTHLY BURN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white.withValues(alpha: .7),
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: onTrack ? const Color(0xFF43A047) : const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  onTrack ? 'ON TRACK' : 'OVER',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppFormatter.currency(totalSpent),
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: spentPct,
              minHeight: 6,
              backgroundColor: AppColors.white.withValues(alpha: .2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF64B5F6)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(spentPct * 100).toStringAsFixed(0)}% of ${AppFormatter.currency(totalLimit)} limit',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white.withValues(alpha: .7),
                ),
              ),
              Text(
                '${AppFormatter.currency(totalRemaining)} left',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white.withValues(alpha: .7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
