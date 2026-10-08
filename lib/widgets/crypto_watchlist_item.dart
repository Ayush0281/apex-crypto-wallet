import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/crypto_token.dart';
import '../theme/app_theme.dart';
import '../screens/token_detail_screen.dart';
import 'sparkline_chart.dart';

class CryptoWatchlistItem extends StatelessWidget {
  final CryptoToken token;
  final VoidCallback? onTap;

  const CryptoWatchlistItem({
    super.key,
    required this.token,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: token.currentPrice < 1 ? 4 : 2);
    final isPos = token.isPositive;
    final changeColor = isPos ? AppColors.green : AppColors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TokenDetailScreen(token: token),
                  ),
                );
              },
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final showSparkline = constraints.maxWidth > 300;
                return Row(
                  children: [
                    // Token Icon with glowing gradient ring
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: token.gradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: token.gradient.colors.first.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          token.iconData,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Name & Symbol
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            token.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  token.symbol,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                token.rank,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (showSparkline) ...[
                      const SizedBox(width: 8),
                      // Mini Sparkline
                      SparklineChart(
                        data: token.sparkline1D,
                        color: changeColor,
                        width: 50,
                        height: 26,
                      ),
                    ],
                    const SizedBox(width: 10),

                    // Price and 24h percentage
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currencyFormatter.format(token.currentPrice),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: changeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPos ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                  color: changeColor,
                                  size: 16,
                                ),
                                Text(
                                  '${isPos ? '+' : ''}${token.changePercentage24h.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: changeColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
