part of 'historical_bloc.dart';

/// Clase base para todos los estados relacionados con el escaneo de QR.@immutable
@immutable
sealed class HistoricalBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Estado inicial del escaneo de QR.
class InitialHistory extends HistoricalBlocState {}

/// Estado cuando el escaneo de QR está cargando.
class InProgressHistory extends HistoricalBlocState {}

/// Estado cuando el escaneo de QR ha sido exitoso.
class LoadedHistory extends HistoricalBlocState {
  // Historial de escaneos de QR.
  final List<QREntity> history;

  LoadedHistory(this.history);

  @override
  List<Object?> get props => [history];
}

class FailedHistory extends HistoricalBlocState {
  // Mensaje de error.
  final String errorMessage;

  /// Constructor que inicializa el estado con el mensaje de error.
  FailedHistory(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
