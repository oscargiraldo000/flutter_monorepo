part of 'scanner_bloc.dart';

/// Clase base para todos los estados relacionados con el escaneo de QR.@immutable
@immutable
sealed class ScannerState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Estado inicial del escaneo de QR.
class InitialScan extends ScannerState {}

/// Estado cuando el escaneo de QR está en progreso.
class ScanInProgress extends ScannerState {}

/// Estado cuando el escaneo de QR ha sido exitoso.
class ScanCompleted extends ScannerState {
  /// Código QR escaneado.
  final String qrData;

  ScanCompleted(this.qrData);

  @override
  List<Object?> get props => [qrData];
}

/// Estado cuando ocurre un error durante el escaneo de QR.
class ScanFailed extends ScannerState {
  /// Mensaje de error.
  final String errorMessage;

  /// Constructor que inicializa el estado con el mensaje de error.
  ScanFailed(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class FlashToggled extends ScannerState {
  final bool isFlashOn;

  FlashToggled(this.isFlashOn);

  @override
  List<Object> get props => [isFlashOn];
}

class CameraToggled extends ScannerState {
  final bool isFrontCamera;

  CameraToggled(this.isFrontCamera);

  @override
  List<Object> get props => [isFrontCamera];
}
