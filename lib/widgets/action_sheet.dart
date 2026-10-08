import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class ActionSheet {
  static void showSendSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSheetContainer(
        context,
        title: 'Send Crypto',
        child: const _SendSheetContent(),
      ),
    );
  }

  static void showReceiveSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSheetContainer(
        context,
        title: 'Receive Crypto',
        child: const _ReceiveSheetContent(),
      ),
    );
  }

  static void showBuySheet(BuildContext context, {String initialToken = 'BTC'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSheetContainer(
        context,
        title: 'Buy Crypto',
        child: _BuySheetContent(selectedToken: initialToken),
      ),
    );
  }

  static void showSwapSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSheetContainer(
        context,
        title: 'Swap Tokens',
        child: const _SwapSheetContent(),
      ),
    );
  }

  static Widget _buildSheetContainer(BuildContext context, {required String title, required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1.5),
        ),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
              ),
            ],
          ),
          const Divider(color: AppColors.cardBorder, height: 24),
          child,
        ],
      ),
    );
  }
}

// ----------------- SEND SHEET -----------------
class _SendSheetContent extends StatefulWidget {
  const _SendSheetContent();

  @override
  State<_SendSheetContent> createState() => _SendSheetContentState();
}

class _SendSheetContentState extends State<_SendSheetContent> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Select Asset
        const Text('Asset', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  gradient: AppColors.btcGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.currency_bitcoin, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Bitcoin (BTC)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const Spacer(),
              const Text('Bal: 0.2450', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Recipient Address
        const Text('Recipient Address', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: _addressController,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Paste wallet address (0x...)',
            hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            filled: true,
            fillColor: AppColors.card,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
                  onPressed: () {},
                ),
                TextButton(
                  onPressed: () {
                    _addressController.text = '0x71C...4e89';
                  },
                  child: const Text('PASTE', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Amount Input
        const Text('Amount', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: const TextStyle(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.card,
            suffixIcon: TextButton(
              onPressed: () {
                _amountController.text = '0.2450';
              },
              child: const Text('MAX', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Network Fee summary
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Network Fee', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            Text('~ \$1.80 (0.000026 BTC)', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 24),

        // Send Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.cardElevated,
                  content: Row(
                    children: const [
                      Icon(Icons.check_circle, color: AppColors.green),
                      SizedBox(width: 10),
                      Text('Transaction broadcasted to network!'),
                    ],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            child: const Text('Send Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

// ----------------- RECEIVE SHEET -----------------
class _ReceiveSheetContent extends StatelessWidget {
  const _ReceiveSheetContent();

  @override
  Widget build(BuildContext context) {
    const walletAddress = '0x8F9aC61dB3821034f54e4Eb02f6A55a9094B4E89';

    return Column(
      children: [
        const Text(
          'Scan QR or copy address to receive funds',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 18),

        // Simulated QR Code in Glass Box
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 4),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 40, height: 40, color: Colors.black),
                          const SizedBox(width: 20),
                          Container(width: 40, height: 40, color: Colors.black),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.currency_bitcoin, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 40, height: 40, color: Colors.black),
                          const SizedBox(width: 20),
                          Container(width: 40, height: 40, color: Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Wallet Address Pill with Copy
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  walletAddress,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, color: AppColors.primary, size: 20),
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: walletAddress));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.cardElevated,
                      content: Text('Address copied to clipboard!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Network Disclaimer
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accentOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accentOrange.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: const [
              Icon(Icons.info_outline, color: AppColors.accentOrange, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Only send BTC/EVM-compatible assets to this address. Sending others may cause permanent loss.',
                  style: TextStyle(color: AppColors.accentOrange, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ----------------- BUY SHEET -----------------
class _BuySheetContent extends StatefulWidget {
  final String selectedToken;
  const _BuySheetContent({required this.selectedToken});

  @override
  State<_BuySheetContent> createState() => _BuySheetContentState();
}

class _BuySheetContentState extends State<_BuySheetContent> {
  final TextEditingController _amountController = TextEditingController(text: '250');
  final String _paymentMethod = 'Apple Pay';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('You Pay (USD)', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: const TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.cardBorder)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.cardBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary)),
          ),
        ),
        const SizedBox(height: 16),

        // Quick amount tags
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [50, 100, 250, 500, 1000].map((amt) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _amountController.text = amt.toString();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text('\$$amt', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // Payment Method Selector
        const Text('Payment Method', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.apple, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text('$_paymentMethod / Credit Card', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              const Spacer(),
              const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.cardElevated,
                  content: Text('Purchased \$${_amountController.text} of ${widget.selectedToken} with $_paymentMethod successfully!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Buy ${widget.selectedToken}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

// ----------------- SWAP SHEET -----------------
class _SwapSheetContent extends StatefulWidget {
  const _SwapSheetContent();

  @override
  State<_SwapSheetContent> createState() => _SwapSheetContentState();
}

class _SwapSheetContentState extends State<_SwapSheetContent> {
  final TextEditingController _payController = TextEditingController(text: '1.0');
  final TextEditingController _receiveController = TextEditingController(text: '19.8');

  @override
  void dispose() {
    _payController.dispose();
    _receiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pay Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('You Pay', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  Text('Balance: 1.45 ETH', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _payController,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.diamond_outlined, color: AppColors.secondary, size: 18),
                        SizedBox(width: 6),
                        Text('ETH', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Swap Icon Button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(Icons.swap_vert_rounded, color: AppColors.accentPurple, size: 24),
          ),
        ),

        // Receive Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('You Receive', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  Text('Balance: 12.5 SOL', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _receiveController,
                      readOnly: true,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.bolt, color: AppColors.primary, size: 18),
                        SizedBox(width: 6),
                        Text('SOL', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Rate: 1 ETH ≈ 19.82 SOL', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Text('Slippage: 0.5%', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.cardElevated,
                  content: Text('Swapped 1.0 ETH to 19.8 SOL successfully!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Confirm Swap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
