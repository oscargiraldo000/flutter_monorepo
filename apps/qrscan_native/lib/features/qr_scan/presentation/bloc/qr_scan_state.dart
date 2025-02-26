part of 'qr_scan_bloc.dart';

/// Clase base para todos los estados relacionados con el escaneo de QR.
sealed class QRScanState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Estado inicial del escaneo de QR.
class QRInitial extends QRScanState {}

/// Estado cuando el escaneo de QR está cargando.
class QRLoading extends QRScanState {}

/// Estado cuando el escaneo de QR ha sido exitoso.
class QRScannedSuccess extends QRScanState {
  final String code;

  /// Constructor que inicializa el estado con el código QR escaneado.
  QRScannedSuccess(this.code);

  @override
  List<Object?> get props => [code];
}

/// Estado cuando el historial de escaneos de QR está cargando.
class QRHistoryLoading extends QRScanState {}

/// Estado cuando ocurre un error al cargar el historial de escaneos de QR.
class QRHistoryError extends QRScanState {
  final String error;

  /// Constructor que inicializa el estado con el mensaje de error.
  QRHistoryError(this.error);

  @override
  List<Object?> get props => [error];
}

/// Estado cuando el historial de escaneos de QR ha sido cargado.
class QRHistoryLoaded extends QRScanState {
  final List<QREntity> history;

  /// Constructor que inicializa el estado con el historial de escaneos.
  QRHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

/// Estado cuando ocurre un error durante el escaneo de QR.
class QRScanError extends QRScanState {
  final String error;

  /// Constructor que inicializa el estado con el mensaje de error.
  QRScanError(this.error);

  @override
  List<Object?> get props => [error];
}
