import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:domain/domain.dart';
import 'package:qrscan_native/features/scanner/bloc/scanner_bloc.dart';

// Mock para SaveQRCode
class MockSaveQRCode extends Mock implements SaveQRCode {}

// Función para crear una instancia dummy de QREntity
QREntity createDummyQREntity() {
  return QREntity(code: 'dummy_code', timestamp: DateTime.now());
}

void main() {
  late ScannerBloc scannerBloc;
  late MockSaveQRCode mockSaveQRCode;

  setUpAll(() {
    // Registrar un valor de respaldo para QREntity
    registerFallbackValue(createDummyQREntity());
  });

  setUp(() {
    mockSaveQRCode = MockSaveQRCode();
    scannerBloc = ScannerBloc(saveQrCodeUseCase: mockSaveQRCode);
  });

  tearDown(() {
    scannerBloc.close();
  });

  group('ScannerBloc', () {
    const qrData = '12345';

    // Prueba de guardado de codigo qr exitoso
    blocTest<ScannerBloc, ScannerState>(
      'emite [ScanInProgress, ScanCompleted] cuando el escaneo es exitoso',
      build: () {
        // Simular un guardado exitoso
        when(() => mockSaveQRCode.call(any())).thenAnswer((_) async {});
        return scannerBloc;
      },
      act: (bloc) => bloc.add(Scan(qrData)),
      expect: () => [ScanInProgress(), ScanCompleted(qrData)],
      verify: (_) {
        // Verificar que el caso de uso fue llamado con la entidad correcta
        verify(
          () => mockSaveQRCode.call(
            any(
              that: isA<QREntity>()
                  .having((e) => e.code, 'code', qrData)
                  .having((e) => e.timestamp, 'timestamp', isA<DateTime>()),
            ),
          ),
        ).called(1);
      },
    );

    // Prueba de guardado de codigo qr fallido
    blocTest<ScannerBloc, ScannerState>(
      'emite [ScanInProgress, ScanFailed] cuando el guardado falla',
      build: () {
        // Simular un error
        when(
          () => mockSaveQRCode.call(any()),
        ).thenThrow(Exception('Error al guardar'));
        return scannerBloc;
      },
      act: (bloc) => bloc.add(Scan(qrData)),
      expect:
          () => [
            ScanInProgress(),
            ScanFailed(
              'Error al guardar el código QR: Exception: Error al guardar',
            ),
          ],
    );

    // Prueba de cambio de flash
    blocTest<ScannerBloc, ScannerState>(
      'emite [FlashToggled] cuando se activa/desactiva el flash',
      build: () => scannerBloc,
      act: (bloc) => bloc.add(ToggleFlash()),
      expect:
          () => [
            FlashToggled(
              true,
            ), // El estado inicial es false, por lo que el primer evento lo cambia a true
          ],
    );

    // Prueba de cambio de camara
    blocTest<ScannerBloc, ScannerState>(
      'emite [CameraToggled] cuando se cambia la cámara',
      build: () => scannerBloc,
      act: (bloc) => bloc.add(ToggleCamera()),
      expect:
          () => [
            CameraToggled(
              true,
            ), // El estado inicial es false, por lo que el primer evento lo cambia a true
          ],
    );
  });
}
