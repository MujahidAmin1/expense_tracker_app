import 'package:flutter/material.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_toggle_tile.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/upgrade_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sovereign Ledger',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            const UserProfileCard(
              name: 'Alexander Sterling',
              membershipType: 'PRO MEMBER',
              imageUrl: 'https://via.placeholder.com/60',
            ),

            const SizedBox(height: 16),

            // Ledger Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.account_balance_wallet_outlined,
                              color: Colors.blue[700], size: 24),
                          const SizedBox(height: 8),
                          const Text(
                            'Default Ledger',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const Text(
                            'Main Savings',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: UpgradeCard(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Security & Access Section
            const SettingsSectionHeader(title: 'SECURITY & ACCESS'),
            SettingsToggleTile(
              icon: Icons.fingerprint,
              iconColor: Colors.purple,
              title: 'Biometrics',
              subtitle: 'FaceID or TouchID Enabled',
              value: true,
              onChanged: (value) {},
            ),
            SettingsTile(
              icon: Icons.lock_outline,
              title: 'Security PIN',
              subtitle: 'Last updated 12 days ago',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.lock_outline,
              title: 'User Password',
              subtitle: 'Last updated 5 days ago',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.lock_outline,
              title: 'Two-Factor Authentication',
              subtitle: 'Last updated 1 month ago',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Data Management Section
            const SettingsSectionHeader(title: 'DATA MANAGEMENT'),
            SettingsTile(
              icon: Icons.file_download_outlined,
              title: 'Export Data',
              subtitle: 'CSV, PDF, or JSON',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.cloud_outlined,
              title: 'Cloud Backup',
              subtitle: 'Auto-sync enabled',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.analytics_outlined,
              title: 'User Analytics',
              subtitle: 'Real-time insights available',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.description_outlined,
              title: 'Custom Reports',
              subtitle: 'Schedule and automate generation',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Preferences Section
            const SettingsSectionHeader(title: 'PREFERENCES'),
            SettingsTile(
              icon: Icons.attach_money,
              title: 'Currency',
              subtitle: 'USD (\$)',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English (US)',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.access_time,
              title: 'Timezone',
              subtitle: 'UTC -5',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'FAQs and direct support',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.payment,
              title: 'Payment Method',
              subtitle: 'Credit card',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.local_shipping_outlined,
              title: 'Shipping Options',
              subtitle: 'Standard and Express',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.card_giftcard,
              title: 'Loyalty Program',
              subtitle: 'Rewards points system',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Sign Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout),
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
                  fontSize: 12,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
