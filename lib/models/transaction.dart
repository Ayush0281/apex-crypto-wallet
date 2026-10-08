import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum TransactionType { send, receive, buy, swap }

class WalletTransaction {
  final String id;
  final String title;
  final String subtitle;
  final double cryptoAmount;
  final String cryptoSymbol;
  final double fiatAmount;
  final DateTime date;
  final TransactionType type;
  final String status;
  final String hash;

  WalletTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.cryptoAmount,
    required this.cryptoSymbol,
    required this.fiatAmount,
    required this.date,
    required this.type,
    this.status = 'Completed',
    required this.hash,
  });

  IconData get icon {
    switch (type) {
      case TransactionType.send:
        return Icons.arrow_outward_rounded;
      case TransactionType.receive:
        return Icons.south_west_rounded;
      case TransactionType.buy:
        return Icons.add_shopping_cart_rounded;
      case TransactionType.swap:
        return Icons.swap_horiz_rounded;
    }
  }

  Color get color {
    switch (type) {
      case TransactionType.send:
        return AppColors.red;
      case TransactionType.receive:
        return AppColors.green;
      case TransactionType.buy:
        return AppColors.secondary;
      case TransactionType.swap:
        return AppColors.accentPurple;
    }
  }

  bool get isCredit => type == TransactionType.receive || type == TransactionType.buy;

  static List<WalletTransaction> get mockTransactions => [
        WalletTransaction(
          id: 'tx1',
          title: 'Received Bitcoin',
          subtitle: 'From 0x9b3...4e1',
          cryptoAmount: 0.045,
          cryptoSymbol: 'BTC',
          fiatAmount: 3078.92,
          date: DateTime.now().subtract(const Duration(minutes: 24)),
          type: TransactionType.receive,
          hash: '0x8f23...a9c4',
        ),
        WalletTransaction(
          id: 'tx2',
          title: 'Bought Solana',
          subtitle: 'Via Apple Pay',
          cryptoAmount: 5.00,
          cryptoSymbol: 'SOL',
          fiatAmount: 893.00,
          date: DateTime.now().subtract(const Duration(hours: 3)),
          type: TransactionType.buy,
          hash: '0x3a4b...c5d6',
        ),
        WalletTransaction(
          id: 'tx3',
          title: 'Sent Ethereum',
          subtitle: 'To Vitalik.eth',
          cryptoAmount: 0.35,
          cryptoSymbol: 'ETH',
          fiatAmount: 1239.28,
          date: DateTime.now().subtract(const Duration(days: 1)),
          type: TransactionType.send,
          hash: '0x1d2e...3f4a',
        ),
        WalletTransaction(
          id: 'tx4',
          title: 'Swapped USDT to BTC',
          subtitle: 'Uniswap V3',
          cryptoAmount: 0.0073,
          cryptoSymbol: 'BTC',
          fiatAmount: 500.00,
          date: DateTime.now().subtract(const Duration(days: 2)),
          type: TransactionType.swap,
          hash: '0x99a1...bb02',
        ),
        WalletTransaction(
          id: 'tx5',
          title: 'Received Cardano',
          subtitle: 'Staking Reward',
          cryptoAmount: 85.00,
          cryptoSymbol: 'ADA',
          fiatAmount: 49.64,
          date: DateTime.now().subtract(const Duration(days: 4)),
          type: TransactionType.receive,
          hash: '0x77c8...ff31',
        ),
      ];
}
