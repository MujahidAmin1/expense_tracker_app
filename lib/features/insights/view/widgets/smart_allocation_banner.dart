import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SmartAllocationBanner extends StatelessWidget {
  final double utilizationPct;
  final double totalBudget;

  const SmartAllocationBanner({
    super.key,
    required this.utilizationPct,
    required this.totalBudget,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (utilizationPct * 100).round();
    final isSafe = utilizationPct < 0.75;

    final String message = isSafe
        ? 'You\'ve spent $pct% of your monthly allowance. You\'re on track — consider saving the rest!'
        : 'You\'ve used $pct% of your budget. Re-allocate to avoid overspending this month.';

    final String buttonLabel = isSafe ? 'Save More ›' : 'Reallocate Now';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withValues(alpha: .75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: CircularProgressIndicator(
                        value: utilizationPct,
                        strokeWidth: 6,
                        backgroundColor: AppColors.white.withValues(alpha: .2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    ),
                    Text(
                      '$pct%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Smart Allocation Detected',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.white.withValues(alpha: .85),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primaryBlue,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
