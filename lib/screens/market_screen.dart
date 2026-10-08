import 'package:flutter/material.dart';
import '../models/crypto_token.dart';
import '../theme/app_theme.dart';
import '../widgets/crypto_watchlist_item.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _categoryIndex = 0;
  final List<String> _categories = ['All Coins', 'DeFi', 'Layer 1', 'Metaverse', 'AI & Big Data'];
  final List<CryptoToken> _tokens = CryptoToken.mockTokens;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final filtered = _tokens.where((t) {
      return t.name.toLowerCase().contains(query) || t.symbol.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Crypto Markets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search coins (e.g. BTC, Solana)...',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.cardBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.cardBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 16),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.asMap().entries.map((entry) {
                  final isSel = _categoryIndex == entry.key;
                  return GestureDetector(
                    onTap: () => setState(() => _categoryIndex = entry.key),
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
            ),
            const SizedBox(height: 20),

            // Market Trend Highlight Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B2C24), Color(0xFF121B1F)],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.trending_up, color: AppColors.green, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Market is up +4.8% today', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        SizedBox(height: 2),
                        Text('Global crypto market cap is \$2.68T across 12,400+ assets.', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Tokens (${filtered.length})',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            ...filtered.map((token) => CryptoWatchlistItem(token: token)),
          ],
        ),
      ),
    );
  }
}
