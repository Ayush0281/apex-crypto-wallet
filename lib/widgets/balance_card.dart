import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'action_sheet.dart';

class BalanceCard extends StatefulWidget {
  final double totalBalance;
  final double changePercentage;
  final double changeAmount;

  const BalanceCard({
    super.key,
    this.totalBalance = 24850.50,
    this.changePercentage = 12.5,
    this.changeAmount = 2740.10,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppColors.balanceCardGradient,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background ambient gradient orb
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Label & Eye Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary,
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Total Portfolio Value',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textSecondary.withValues(alpha: 0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isBalanceVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Balance Big Text
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      _isBalanceVisible
                          ? currencyFormatter.format(widget.totalBalance)
                          : '••••••••••••',
                      key: ValueKey(_isBalanceVisible),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Change Percentage Tag and Amount
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.green.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up_rounded,
                            color: AppColors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+${widget.changePercentage.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${currencyFormatter.format(widget.changeAmount)} today',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons Row (Send, Receive, Buy, Swap)
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(
                        context,
                        title: 'Send',
                        icon: Icons.arrow_outward_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2C3549), Color(0xFF1E2536)],
                        ),
                        iconColor: AppColors.primary,
                        onTap: () => ActionSheet.showSendSheet(context),
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        context,
                        title: 'Receive',
                        icon: Icons.south_west_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2C3549), Color(0xFF1E2536)],
                        ),
                        iconColor: AppColors.secondary,
                        onTap: () => ActionSheet.showReceiveSheet(context),
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        context,
                        title: 'Buy',
                        icon: Icons.add_rounded,
                        gradient: AppColors.primaryGradient,
                        iconColor: Colors.black,
                        textColor: AppColors.primary,
                        isPrimary: true,
                        onTap: () => ActionSheet.showBuySheet(context),
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        context,
                        title: 'Swap',
                        icon: Icons.swap_horiz_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2C3549), Color(0xFF1E2536)],
                        ),
                        iconColor: AppColors.accentPurple,
                        onTap: () => ActionSheet.showSwapSheet(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Gradient gradient,
    required Color iconColor,
    Color? textColor,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
              border: Border.all(
                color: isPrimary ? Colors.white.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
                width: 1.2,
              ),
              boxShadow: isPrimary
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: textColor ?? AppColors.textPrimary,
              fontSize: 12,
              fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
