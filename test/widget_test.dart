import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_wallet_app/main.dart';

void main() {
  testWidgets('Crypto Wallet smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CryptoWalletApp());
    expect(find.text('Apex Crypto Wallet'), findsNothing);
  });
}
