import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CryptoToken {
  final String id;
  final String name;
  final String symbol;
  final double currentPrice;
  final double changePercentage24h;
  final double changeAmount24h;
  final double balance; // Tokens owned by user
  final double fiatBalance; // USD value owned
  final List<double> sparkline1D;
  final List<double> sparkline1W;
  final List<double> sparkline1M;
  final List<double> sparkline1Y;
  final LinearGradient gradient;
  final IconData iconData;
  final String marketCap;
  final String volume24h;
  final String allTimeHigh;
  final String circulatingSupply;
  final String rank;
  final String dominance;
  final String about;

  CryptoToken({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.changePercentage24h,
    required this.changeAmount24h,
    required this.balance,
    required this.fiatBalance,
    required this.sparkline1D,
    required this.sparkline1W,
    required this.sparkline1M,
    required this.sparkline1Y,
    required this.gradient,
    required this.iconData,
    required this.marketCap,
    required this.volume24h,
    required this.allTimeHigh,
    required this.circulatingSupply,
    required this.rank,
    required this.dominance,
    required this.about,
  });

  bool get isPositive => changePercentage24h >= 0;

  static List<CryptoToken> get mockTokens => [
        CryptoToken(
          id: 'bitcoin',
          name: 'Bitcoin',
          symbol: 'BTC',
          currentPrice: 68420.50,
          changePercentage24h: 5.42,
          changeAmount24h: 3512.20,
          balance: 0.2450,
          fiatBalance: 16763.02,
          sparkline1D: [64800, 65200, 64900, 66100, 65800, 67200, 66900, 68420.50],
          sparkline1W: [61200, 62400, 63100, 62800, 65000, 66700, 68420.50],
          sparkline1M: [58000, 59500, 61000, 60200, 64000, 63500, 68420.50],
          sparkline1Y: [34000, 42000, 48000, 64000, 56000, 61000, 68420.50],
          gradient: AppColors.btcGradient,
          iconData: Icons.currency_bitcoin,
          marketCap: '\$1.34 Trillion',
          volume24h: '\$34.82 Billion',
          allTimeHigh: '\$73,750.07',
          circulatingSupply: '19.72M BTC',
          rank: '#1',
          dominance: '54.2%',
          about:
              'Bitcoin is the first decentralized digital currency, enabling peer-to-peer transfers across the globe without intermediaries. Introduced in 2008 by Satoshi Nakamoto.',
        ),
        CryptoToken(
          id: 'ethereum',
          name: 'Ethereum',
          symbol: 'ETH',
          currentPrice: 3540.80,
          changePercentage24h: 3.18,
          changeAmount24h: 109.20,
          balance: 1.450,
          fiatBalance: 5134.16,
          sparkline1D: [3420, 3450, 3410, 3490, 3470, 3510, 3500, 3540.80],
          sparkline1W: [3200, 3280, 3350, 3310, 3440, 3490, 3540.80],
          sparkline1M: [2900, 3050, 3180, 3120, 3380, 3420, 3540.80],
          sparkline1Y: [1800, 2200, 2600, 3900, 3100, 3300, 3540.80],
          gradient: AppColors.ethGradient,
          iconData: Icons.diamond_outlined,
          marketCap: '\$425.80 Billion',
          volume24h: '\$18.45 Billion',
          allTimeHigh: '\$4,891.70',
          circulatingSupply: '120.2M ETH',
          rank: '#2',
          dominance: '17.1%',
          about:
              'Ethereum is a global, decentralized platform for smart contracts and decentralized applications (dApps), powered by its native cryptocurrency, Ether.',
        ),
        CryptoToken(
          id: 'solana',
          name: 'Solana',
          symbol: 'SOL',
          currentPrice: 178.60,
          changePercentage24h: 8.94,
          changeAmount24h: 14.65,
          balance: 12.50,
          fiatBalance: 2232.50,
          sparkline1D: [162, 165, 163, 169, 168, 174, 172, 178.60],
          sparkline1W: [142, 149, 155, 152, 166, 171, 178.60],
          sparkline1M: [120, 134, 145, 139, 162, 168, 178.60],
          sparkline1Y: [24, 45, 90, 202, 130, 155, 178.60],
          gradient: AppColors.solGradient,
          iconData: Icons.bolt,
          marketCap: '\$82.90 Billion',
          volume24h: '\$6.12 Billion',
          allTimeHigh: '\$260.06',
          circulatingSupply: '464.1M SOL',
          rank: '#5',
          dominance: '3.4%',
          about:
              'Solana is a high-performance blockchain supporting builders across the world creating crypto apps that scale today with lightning-fast speeds and near-zero fees.',
        ),
        CryptoToken(
          id: 'cardano',
          name: 'Cardano',
          symbol: 'ADA',
          currentPrice: 0.584,
          changePercentage24h: -1.24,
          changeAmount24h: -0.007,
          balance: 1230.0,
          fiatBalance: 718.32,
          sparkline1D: [0.595, 0.592, 0.589, 0.591, 0.586, 0.582, 0.585, 0.584],
          sparkline1W: [0.54, 0.56, 0.58, 0.59, 0.61, 0.59, 0.584],
          sparkline1M: [0.45, 0.48, 0.52, 0.55, 0.60, 0.59, 0.584],
          sparkline1Y: [0.25, 0.38, 0.48, 0.77, 0.50, 0.54, 0.584],
          gradient: AppColors.adaGradient,
          iconData: Icons.all_inclusive,
          marketCap: '\$20.75 Billion',
          volume24h: '\$480.12 Million',
          allTimeHigh: '\$3.10',
          circulatingSupply: '35.6B ADA',
          rank: '#10',
          dominance: '0.8%',
          about:
              'Cardano is a proof-of-stake blockchain platform that says its goal is to allow changemakers, innovators and visionaries to bring about positive global change.',
        ),
      ];
}
