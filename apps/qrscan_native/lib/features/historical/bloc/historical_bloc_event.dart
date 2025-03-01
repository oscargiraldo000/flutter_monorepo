part of 'historical_bloc.dart';

@immutable
sealed class HistoricalBlocEvent {}

/// Evento para cargar el historial de escaneos de QR.
class LoadHistory extends HistoricalBlocEvent {}
