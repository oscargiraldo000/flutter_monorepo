import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qrscan_native/features/qr_scan/pages/qr_scan_page.dart';
import 'package:qrscan_native/features/qr_scan/presentation/bloc/qr_scan_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Hive
  await HiveInitializer.initialize();
  // Configura DI
  //configureDependencies();
  runApp(
    MultiProvider(
      providers: [
        // Proporciona un Bloc
        BlocProvider<QRScanBloc>(
          create: (_) => QRScanBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
