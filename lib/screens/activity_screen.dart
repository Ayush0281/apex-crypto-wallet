import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';
import '../widgets/transaction_item.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Received', 'Sent', 'Swapped'];
  final List<WalletTransaction> _allTransactions = WalletTransaction.mockTransactions;

  List<WalletTransaction> get _filteredTransactions {
    switch (_selectedFilter) {
      case 1:
        return _allTransactions.where((tx) => tx.type == TransactionType.receive).toList();
      case 2:
        return _allTransactions.where((tx) => tx.type == TransactionType.send).toList();
      case 3:
        return _allTransactions.where((tx) => tx.type == TransactionType.swap).toList();
      default:
        return _allTransactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaction History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.textSecondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.cardElevated,
                  content: Text('Exported transaction statement as CSV!'),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Pills
            Row(
              children: _filters.asMap().entries.map((entry) {
                final isSel = _selectedFilter == entry.key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = entry.key),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.primary : AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSel ? AppColors.primary : AppColors.cardBorder),
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
            const SizedBox(height: 20),

            if (_filteredTransactions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: const [
                      Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textMuted),
                      SizedBox(height: 12),
                      Text('No transactions found', style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              )
            else ...[
              const Text('Recent Activities', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              ..._filteredTransactions.map((tx) => TransactionItem(transaction: tx)),
            ],
          ],
        ),
      ),
    );
  }
}
