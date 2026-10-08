import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/crypto_token.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/portfolio_chart.dart';
import '../widgets/action_sheet.dart';

class TokenDetailScreen extends StatefulWidget {
  final CryptoToken token;

  const TokenDetailScreen({
    super.key,
    required this.token,
  });

  @override
  State<TokenDetailScreen> createState() => _TokenDetailScreenState();
}

class _TokenDetailScreenState extends State<TokenDetailScreen> {
  String _selectedPeriod = '1D';
  bool _isFavorite = true;
  late double _displayPrice;

  @override
  void initState() {
    super.initState();
    _displayPrice = widget.token.currentPrice;
  }

  List<double> get _currentSparkline {
    switch (_selectedPeriod) {
      case '1D':
        return widget.token.sparkline1D;
      case '1W':
        return widget.token.sparkline1W;
      case '1M':
        return widget.token.sparkline1M;
      case '1Y':
        return widget.token.sparkline1Y;
      default:
        return widget.token.sparkline1D;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: widget.token.currentPrice < 1 ? 4 : 2,
    );
    final isPos = widget.token.isPositive;
    final changeColor = isPos ? AppColors.green : AppColors.red;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: widget.token.gradient,
                shape: BoxShape.circle,
              ),
              child: Icon(widget.token.iconData, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                '${widget.token.name} (${widget.token.symbol})',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: _isFavorite ? AppColors.accentOrange : AppColors.textSecondary,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.cardElevated,
                  duration: const Duration(milliseconds: 1200),
                  content: Text(_isFavorite ? 'Added to Watchlist' : 'Removed from Watchlist'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.cardElevated,
                  content: Text('Token link copied to clipboard!'),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Live Price Header
                Text(
                  currencyFormatter.format(_displayPrice),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Change Indicator Tag
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: changeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: changeColor.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPos ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                            color: changeColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isPos ? '+' : ''}${widget.token.changePercentage24h.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: changeColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${isPos ? '+' : '-'}${currencyFormatter.format(widget.token.changeAmount24h.abs())} (24h)',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Interactive Price Chart Container
                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      PortfolioChart(
                        customData: _currentSparkline,
                        lineColor: changeColor,
                        showTimeframes: false,
                        onScrub: (val, label) {
                          setState(() {
                            _displayPrice = val;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Timeframe selector
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: ['1D', '1W', '1M', '1Y'].map((period) {
                            final isSel = _selectedPeriod == period;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPeriod = period;
                                    _displayPrice = widget.token.currentPrice;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSel ? changeColor.withValues(alpha: 0.2) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: isSel
                                        ? Border.all(color: changeColor.withValues(alpha: 0.5))
                                        : Border.all(color: Colors.transparent),
                                  ),
                                  child: Text(
                                    period,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSel ? changeColor : AppColors.textSecondary,
                                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Your Holdings Card
                const Text(
                  'Your Holdings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                GlassContainer(
                  gradient: AppColors.cardGradient,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Holding Balance', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.token.balance} ${widget.token.symbol}',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Total Value', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(
                                currencyFormatter.format(widget.token.fiatBalance),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(color: AppColors.cardBorder, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Average Cost', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          Text(
                            currencyFormatter.format(widget.token.currentPrice * 0.88),
                            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Total Profit / Loss', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                          Text(
                            '+ \$2,140.20 (+13.6%)',
                            style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Market Stats Grid
                const Text(
                  'Market Statistics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                  children: [
                    _buildStatCard('Market Cap', widget.token.marketCap, Icons.pie_chart_outline),
                    _buildStatCard('24h Volume', widget.token.volume24h, Icons.bar_chart_rounded),
                    _buildStatCard('All-Time High', widget.token.allTimeHigh, Icons.show_chart_rounded),
                    _buildStatCard('Circulating Supply', widget.token.circulatingSupply, Icons.donut_large_rounded),
                    _buildStatCard('Market Dominance', widget.token.dominance, Icons.leaderboard_rounded),
                    _buildStatCard('Market Rank', widget.token.rank, Icons.emoji_events_outlined),
                  ],
                ),
                const SizedBox(height: 24),

                // About Token
                const Text(
                  'About',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Text(
                    widget.token.about,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar (Buy / Sell Buttons)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.95),
                border: const Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Sell Button
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          ActionSheet.showSwapSheet(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cardElevated,
                          foregroundColor: AppColors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: AppColors.red.withValues(alpha: 0.4)),
                          ),
                        ),
                        child: Text(
                          'Sell ${widget.token.symbol}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Buy Button
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          ActionSheet.showBuySheet(context, initialToken: widget.token.symbol);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          elevation: 4,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Buy ${widget.token.symbol}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
