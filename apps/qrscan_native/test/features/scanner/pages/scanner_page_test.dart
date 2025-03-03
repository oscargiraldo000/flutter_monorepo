import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrscan_native/features/scanner/bloc/scanner_bloc.dart';
import 'package:qrscan_native/features/scanner/pages/scanner_page.dart';
import 'package:qrscan_native/features/scanner/widgets/qr_view.dart';

QRView createDummyQRView() {
  return QRView(
    key: GlobalKey(debugLabel: 'QR'),
    onQRViewCreated: (controller) {},
  );
}

void main() {
  late ScannerBloc scannerBloc;

  setUp(() {
    // Inicializar el ScannerBloc antes de cada test
    scannerBloc = ScannerBloc();
  });

  tearDown(() {
    // Cerrar el ScannerBloc después de cada test
    scannerBloc.close();
  });

  Future<void> _buildScannerPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ScannerBloc>.value(
          value: scannerBloc,
          child: ScannerPage(),
        ),
      ),
    );
  }

  testWidgets('Debe renderizar un AppBar con título Escáner de QR', (
    WidgetTester tester,
  ) async {
    await _buildScannerPage(tester);

    // Verifica que el AppBar se renderiza correctamente
    expect(find.byType(AppBar), findsOneWidget);

    // Verifica que el título del AppBar es 'Escáner de QR'
    expect(find.text('Escáner de QR'), findsOneWidget);
  });

  testWidgets('Debe renderizar dos acciones en el AppBar', (
    WidgetTester tester,
  ) async {
    await _buildScannerPage(tester);

    // Verifica que hay dos IconButton en el AppBar
    expect(find.byType(IconButton), findsNWidgets(2));
  });

  testWidgets('Debe renderizar el QRView en la página', (
    WidgetTester tester,
  ) async {
    await _buildScannerPage(tester);

    // Verifica que el QRView está presente en la pantalla
    expect(find.byType(QRView), findsOneWidget);
  });
}
