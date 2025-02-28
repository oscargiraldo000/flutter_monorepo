part of 'qrscan_bloc.dart';

/// Eventos relacionados con el escaneo de códigos QR.
@immutable
sealed class QRScanEvent extends Equatable {
  const QRScanEvent();

  @override
  List<Object> get props => [];
}

/// Evento para escanear un código QR.
class Scan extends QRScanEvent {
  /// Código QR escaneado.
  final String qrData;

  /// Constructor que inicializa el evento con el código QR escaneado.
  Scan(this.qrData);

  @override
  List<Object> get props => [qrData];
}

class ToggleFlash extends QRScanEvent {}

class ToggleCamera extends QRScanEvent {}
