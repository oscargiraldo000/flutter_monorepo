part of 'qr_scan_bloc.dart';

/// Clase base para todos los eventos relacionados con el escaneo de QR.
sealed class QRScanEvent {}

/// Evento para escanear un código QR.
/// Contiene el código QR escaneado.
class ScanQR extends QRScanEvent {
  final String code;

  /// Constructor que inicializa el evento con el código QR escaneado.
  ScanQR(this.code);
}

/// Evento para cargar el historial de escaneos de QR.
class LoadHistory extends QRScanEvent {}

/// Evento para manejar errores durante el escaneo de QR.
class ScanQRError extends QRScanEvent {
  final String error;

  /// Constructor que inicializa el evento con el mensaje de error.
  ScanQRError(this.error);
}
