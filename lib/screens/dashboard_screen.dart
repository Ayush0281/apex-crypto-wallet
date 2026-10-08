import 'package:flutter/material.dart';
import '../models/crypto_token.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';
import '../widgets/balance_card.dart';
import '../widgets/crypto_watchlist_item.dart';
import '../widgets/glass_container.dart';
import '../widgets/portfolio_chart.dart';
import '../widgets/transaction_item.dart';
import '../widgets/action_sheet.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const DashboardScreen({super.key, this.onNavigateTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _watchlistFilterIndex = 0; // 0: All, 1: Gainers, 2: Top Holdings
  final List<CryptoToken> _allTokens = CryptoToken.mockTokens;
  final List<WalletTransaction> _transactions = WalletTransaction.mockTransactions;

  List<CryptoToken> get _filteredTokens {
    if (_watchlistFilterIndex == 1) {
      return _allTokens.where((t) => t.isPositive).toList();
    } else if (_watchlistFilterIndex == 2) {
      return _allTokens.where((t) => t.balance > 0).toList();
    }
    return _allTokens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP HEADER (Avatar, Welcome back, Notification, Scanner)
              _buildHeader(context),
              const SizedBox(height: 20),

              // 2. MAIN BALANCE CARD ($24,850.50, +12.5%, Action Buttons)
              const BalanceCard(
                totalBalance: 24850.50,
                changePercentage: 12.5,
                changeAmount: 2740.10,
              ),
              const SizedBox(height: 24),

              // 3. PORTFOLIO TRENDS SECTION WITH INTERACTIVE CHART
              _buildPortfolioSection(),
              const SizedBox(height: 26),

              // 4. CRYPTO WATCHLIST SECTION
              _buildWatchlistSection(context),
              const SizedBox(height: 26),

              // 5. RECENT ACTIVITY / TRANSACTIONS SECTION
              _buildRecentActivitySection(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth > 0 && constraints.maxWidth != double.infinity
            ? constraints.maxWidth
            : 350.0;
        final targetWidth = availableWidth > 350.0 ? availableWidth : 350.0;
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: targetWidth,
            child: Row(
              children: [
                // User Avatar with glowing border & online indicator
                Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.purpleGradient,
                        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.5), width: 1.5),
                      ),
                      child: const Center(
                        child: Text(
                          'AR',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.background, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Welcome Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Welcome back,',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Alex Rivera',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // QR Scanner Icon Button
                _buildHeaderIconButton(
                  icon: Icons.qr_code_scanner_rounded,
                  onTap: () => ActionSheet.showReceiveSheet(context),
                ),
                const SizedBox(width: 8),

                // Notification Icon with Badge
                Stack(
                  children: [
                    _buildHeaderIconButton(
                      icon: Icons.notifications_none_rounded,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppColors.cardElevated,
                            content: Text('No new notifications. All networks operational!'),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderIconButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
      ),
    );
  }

  Widget _buildPortfolioSection() {
    return GlassContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.insights_rounded, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Portfolio Performance',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Live',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const PortfolioChart(),
        ],
      ),
    );
  }

  Widget _buildWatchlistSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Crypto Watchlist',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(1); // navigate to Market
                }
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All Assets', 'Top Gainers', 'My Holdings'].asMap().entries.map((entry) {
              final isSel = _watchlistFilterIndex == entry.key;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _watchlistFilterIndex = entry.key;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.primary : AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSel ? AppColors.primary : AppColors.cardBorder,
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: isSel ? Colors.black : AppColors.textSecondary,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),

        // Watchlist item list
        ..._filteredTokens.map((token) => CryptoWatchlistItem(token: token)),
      ],
    );
  }

  Widget _buildRecentActivitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(2); // navigate to Activity
                }
              },
              child: const Text(
                'History',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._transactions.take(4).map((tx) => TransactionItem(transaction: tx)),
      ],
    );
  }
}
