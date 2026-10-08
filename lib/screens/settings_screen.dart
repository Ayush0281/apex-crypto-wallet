import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricsEnabled = true;
  bool _pushNotifications = true;
  final String _selectedCurrency = 'USD (\$)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings & Security', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            GlassContainer(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.purpleGradient,
                    ),
                    child: const Center(
                      child: Text('AR', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Alex Rivera', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 2),
                        const Text('alex.rivera@crypto.io', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Verified Tier 2', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Security Section
            const Text('Security & Privacy', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 10),
            GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  _buildSwitchRow(
                    icon: Icons.fingerprint_rounded,
                    iconColor: AppColors.primary,
                    title: 'Biometric Authentication',
                    subtitle: 'Require FaceID / Fingerprint',
                    value: _biometricsEnabled,
                    onChanged: (val) => setState(() => _biometricsEnabled = val),
                  ),
                  const Divider(color: AppColors.cardBorder, height: 16),
                  _buildActionRow(
                    icon: Icons.key_rounded,
                    iconColor: AppColors.accentOrange,
                    title: 'Backup Recovery Phrase',
                    subtitle: 'View 12-word secret phrase',
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
                    onTap: () => _showBackupPhraseDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Preferences
            const Text('Preferences', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 10),
            GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  _buildSwitchRow(
                    icon: Icons.notifications_none_rounded,
                    iconColor: AppColors.secondary,
                    title: 'Push Notifications',
                    subtitle: 'Price alerts & transaction updates',
                    value: _pushNotifications,
                    onChanged: (val) => setState(() => _pushNotifications = val),
                  ),
                  const Divider(color: AppColors.cardBorder, height: 16),
                  _buildActionRow(
                    icon: Icons.attach_money_rounded,
                    iconColor: AppColors.green,
                    title: 'Display Currency',
                    subtitle: 'Default valuation unit',
                    trailing: Text(_selectedCurrency, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                    onTap: () {},
                  ),
                  const Divider(color: AppColors.cardBorder, height: 16),
                  _buildActionRow(
                    icon: Icons.language_rounded,
                    iconColor: AppColors.accentPurple,
                    title: 'Language',
                    subtitle: 'App display language',
                    trailing: const Text('English (US)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Support & About
            GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  _buildActionRow(
                    icon: Icons.help_outline_rounded,
                    iconColor: AppColors.textSecondary,
                    title: 'Help & 24/7 Support',
                    subtitle: 'Contact crypto support desk',
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
                    onTap: () {},
                  ),
                  const Divider(color: AppColors.cardBorder, height: 16),
                  _buildActionRow(
                    icon: Icons.shield_outlined,
                    iconColor: AppColors.textSecondary,
                    title: 'Terms & Privacy Policy',
                    subtitle: 'Legal and data protections',
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.card,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showBackupPhraseDialog(BuildContext context) {
    final words = ['alpha', 'beacon', 'crypto', 'dynamic', 'energy', 'future', 'glacier', 'horizon', 'matrix', 'nexus', 'quantum', 'zenith'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        title: const Text('12-Word Secret Phrase', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Never share this secret phrase with anyone. Anyone with this phrase can steal all your assets.',
              style: TextStyle(color: AppColors.accentOrange, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: words.asMap().entries.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Text('${e.key + 1}. ${e.value}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 12)),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
