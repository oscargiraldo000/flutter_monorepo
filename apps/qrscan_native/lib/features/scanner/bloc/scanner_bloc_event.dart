part of 'scanner_bloc.dart';

/// Eventos relacionados con el escaneo de códigos QR.
@immutable
sealed class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object> get props => [];
}

/// Evento para escanear un código QR.
class Scan extends ScannerEvent {
  final String qrData;

  /// Constructor que inicializa el evento con el código QR escaneado.
  const Scan(this.qrData);

  @override
  List<Object> get props => [qrData];
}

class ToggleFlash extends ScannerEvent {}

class ToggleCamera extends ScannerEvent {}
