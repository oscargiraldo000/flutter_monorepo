part of 'qrscan_bloc.dart';

/// Clase base para todos los estados relacionados con el escaneo de QR.@immutable
@immutable
sealed class QRScanState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Estado inicial del escaneo de QR.
class InitialScan extends QRScanState {}

/// Estado cuando el escaneo de QR está en progreso.
class ScanInProgress extends QRScanState {}

/// Estado cuando el escaneo de QR ha sido exitoso.
class ScanCompleted extends QRScanState {
  /// Código QR escaneado.
  final String qrData;

  ScanCompleted(this.qrData);

  @override
  List<Object?> get props => [qrData];
}

/// Estado cuando ocurre un error durante el escaneo de QR.
class ScanFailed extends QRScanState {
  /// Mensaje de error.
  final String errorMessage;

  /// Constructor que inicializa el estado con el mensaje de error.
  ScanFailed(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class FlashToggled extends QRScanState {
  final bool isFlashOn;

  FlashToggled(this.isFlashOn);

  @override
  List<Object> get props => [isFlashOn];
}

class CameraToggled extends QRScanState {
  final bool isFrontCamera;

  CameraToggled(this.isFrontCamera);

  @override
  List<Object> get props => [isFrontCamera];
}
