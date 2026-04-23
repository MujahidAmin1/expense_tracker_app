import 'package:flutter/material.dart';
import 'package:expense_tracker_app/utils/app_colors.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_toggle_tile.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/ledger_cards_row.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
