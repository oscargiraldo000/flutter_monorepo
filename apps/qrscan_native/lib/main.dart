import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qrscan_native/features/historical/bloc/historical_bloc.dart';
import 'package:qrscan_native/features/historical/pages/historical_page.dart';
import 'package:qrscan_native/features/scanner/bloc/scanner_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Hive
  await HiveInitializer.initialize();

  // Configura DI (Dependency Injection)
  // configureDependencies();

  runApp(
    MultiProvider(
      providers: [
        // Proporciona un Bloc para QRScan
        BlocProvider<ScannerBloc>(create: (_) => ScannerBloc()),
        // Proporciona un Bloc para QRHistory
        BlocProvider<HistoricalBloc>(create: (context) => HistoricalBloc()..add(LoadHistory())),
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
      home: HistoricalPage(),
    );
  }
}