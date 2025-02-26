part of 'qrhistory_bloc.dart';

/// Clase base para todos los estados relacionados con el escaneo de QR.@immutable
@immutable
sealed class QRHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Estado inicial del escaneo de QR.
class InitialHistory extends QRHistoryState {}

/// Estado cuando el escaneo de QR está cargando.
class InProgressHistory extends QRHistoryState {}

/// Estado cuando el escaneo de QR ha sido exitoso.
class LoadedHistory extends QRHistoryState {
  // Historial de escaneos de QR.
  final List<QREntity> history;

  LoadedHistory(this.history);

  @override
  List<Object?> get props => [history];
}

class FailedHistory extends QRHistoryState {
  // Mensaje de error.
  final String errorMessage;

  /// Constructor que inicializa el estado con el mensaje de error.
  FailedHistory(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
