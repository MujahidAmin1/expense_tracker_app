import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import 'package:expense_tracker_app/features/insights/view/controller/insight_controller.dart';
import 'package:expense_tracker_app/features/insights/view/widgets/spending_velocity_card.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_toggle_tile.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/ledger_cards_row.dart';
import 'package:expense_tracker_app/features/insights/view/widgets/allocation_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _showExportPreview(BuildContext context, WidgetRef ref) async {
    final state = ref.read(insightControllerProvider);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: const BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.switchTrackInactive.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'EXPORT SUMMARY',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGrey,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Data Insight Preview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Spending Distribution',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 12),
              AllocationCard(
                totalSpent: state.totalSpent,
                categorySpending: state.categorySpending,
              ),
              const SizedBox(height: 24),
              const Text(
                'Spending Velocity',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 12),
              SpendingVelocityCard(
                dailySpending: state.dailySpending,
                velocityChange: state.velocityChange,
                budgetRemaining: state.totalRemaining,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _exportCsv(context, ref);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Download CSV Report',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
  try {
    final state = ref.read(insightControllerProvider);
    
    List<List<dynamic>> rows = [];
    // Add header row
    rows.add(["Category", "Total Spent"]);
    
    // Add category spending data
    state.categorySpending.forEach((category, amount) {
      final categoryName = category.toString().split('.').last.toUpperCase();
      rows.add([categoryName, amount.toStringAsFixed(2)]);
    });
    
    // Add an empty row and summary data
    rows.add([]);
    rows.add(["Total Budget", state.totalBudget.toStringAsFixed(2)]);
    rows.add(["Total Spent", state.totalSpent.toStringAsFixed(2)]);
    rows.add(["Remaining", state.totalRemaining.toStringAsFixed(2)]);

    // Encode the list of rows into a CSV string using the preferred Csv().encode method
    String csvData = Csv().encode(rows);
    
    // Get the directory to save the file
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/insights_export_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);
    await file.writeAsString(csvData);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported to ${path.split('/').last}'),
          backgroundColor: AppColors.primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to export CSV'),
          backgroundColor: Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(insightControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Sovereign Ledger',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkText,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.darkText,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // User Profile Card
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: UserProfileCard(
                  name: 'Alexander Sterling',
                  membershipType: 'PRO MEMBER',
                  imageUrl: 'https://via.placeholder.com/60',
                ),
              ),

              const SizedBox(height: 16),

              // Ledger Cards Row
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: LedgerCardsRow(),
              ),

              const SizedBox(height: 24),

              // Security & Access Section
              const SettingsSectionHeader(title: 'SECURITY & ACCESS'),
              const SizedBox(height: 8),
              SettingsToggleTile(
                icon: Icons.fingerprint,
                iconColor: AppColors.primaryBlue,
                title: 'Biometrics',
                subtitle: 'FaceID or TouchID Enabled',
                value: true,
                onChanged: (value) {},
              ),
              const SizedBox(height: 8),
              SettingsTile(
                icon: Icons.lock_outline,
                iconColor: AppColors.primaryBlue,
                title: 'User Password',
                subtitle: 'Last updated 5 days ago',
                onTap: () {},
              ),

              const SizedBox(height: 24),

              const SizedBox(height: 24),
              // Preferences Section
              const SettingsSectionHeader(title: 'PREFERENCES'),
              const SizedBox(height: 8),
              SettingsTile(
                icon: Icons.attach_money,
                iconColor: AppColors.primaryBlue,
                title: 'Currency',
                subtitle: 'USD (\$)',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              SettingsTile(
                icon: Icons.language,
                iconColor: AppColors.primaryBlue,
                title: 'Language',
                subtitle: 'English (US)',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              SettingsTile(
                icon: Icons.help_outline,
                iconColor: AppColors.primaryBlue,
                title: 'Help Center',
                subtitle: 'FAQs and direct support',
                onTap: () {},
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              const SettingsSectionHeader(title: 'QUICK INSIGHTS'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AllocationCard(
                  totalSpent: state.totalSpent,
                  categorySpending: state.categorySpending,
                ),
              ),
              const SizedBox(height: 24),

              const SettingsSectionHeader(title: 'DATA MANAGEMENT'),
              const SizedBox(height: 8),
              SettingsTile(
                icon: Icons.download_rounded,
                iconColor: AppColors.primaryBlue,
                title: 'Export Data',
                subtitle: 'Download Insights to CSV',
                onTap: () => _showExportPreview(context, ref),
              ),
              const SizedBox(height: 24),

              // Sign Out Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE5E5),
                      foregroundColor: const Color(0xFFE53935),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Version Text
              const Center(
                child: Text(
                  'SOVEREIGN LEDGER V2.4.0',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
