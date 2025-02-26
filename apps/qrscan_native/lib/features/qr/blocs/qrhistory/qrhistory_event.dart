part of 'qrhistory_bloc.dart';

@immutable
sealed class QRHistoryEvent {}

/// Evento para cargar el historial de escaneos de QR.
class LoadHistory extends QRHistoryEvent {}
