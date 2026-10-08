import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const CryptoWalletApp());
}

class CryptoWalletApp extends StatelessWidget {
  const CryptoWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apex Crypto Wallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationScreen(),
      builder: (context, child) {
        return Container(
          color: AppColors.background,
          alignment: Alignment.topCenter,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              if (w > 0 && w < 360) {
                final scale = w / 360.0;
                final h = constraints.maxHeight;
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 360,
                    height: h > 0 ? h / scale : null,
                    child: child,
                  ),
                );
              }
              return SizedBox(
                width: w <= 480 ? double.infinity : 480,
                height: double.infinity,
                child: child ?? const SizedBox(),
              );
            },
          ),
        );
      },
    );
  }
}
