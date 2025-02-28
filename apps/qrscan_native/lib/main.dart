import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qrscan_native/features/qr/blocs/qrhistory/qrhistory_bloc.dart';
import 'package:qrscan_native/features/qr/pages/qr_historial_page.dart';
import 'package:qrscan_native/features/qr/blocs/qrscan/qrscan_bloc.dart';

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
        BlocProvider<QRScanBloc>(create: (_) => QRScanBloc()),
        // Proporciona un Bloc para QRHistory
        BlocProvider<QRHistoryBloc>(create: (context) => QRHistoryBloc()..add(LoadHistory())),
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
      home: QRHistorialPage(),
    );
  }
}