import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:qrscan_native/features/qr_scan/pages/qr_scan_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Hive antes de DI
  await HiveInitializer.initialize();
  // Configura DI
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: QRScanPage(),
    );
  }
}
