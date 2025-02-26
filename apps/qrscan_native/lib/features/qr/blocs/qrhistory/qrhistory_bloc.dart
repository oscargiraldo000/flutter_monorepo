import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'qrhistory_event.dart';
part 'qrhistory_state.dart';

/// Bloc que maneja los eventos y estados relacionados con el escaneo de códigos QR.
class QRHistoryBloc extends Bloc<QRHistoryEvent, QRHistoryState> {
  // Caso de uso para obtener el historial de códigos QR escaneados.
  final GetQRHistory _getHistoryQrUseCase;

  /// Constructor que inicializa el Bloc con los casos de uso necesarios.
  QRHistoryBloc()
      : _getHistoryQrUseCase = GetQRHistory(),
        super(InitialHistory()) {
    // Se suscribe y cancela el evento actual si llega uno nuevo y ejecuta el nuevo.
    on<LoadHistory>(_onLoadHistory, transformer: restartable());
  }

  /// Maneja el evento de escanear un código QR.
  /// Emite estados de carga, éxito o error según el resultado.
  void _onLoadHistory(LoadHistory event, Emitter<QRHistoryState> emit) async {
    // Se emite el estado de carga.
    emit(InProgressHistory());
    try {
      // Se obtiene el historial de códigos QR escaneados.
      final history = await _getHistoryQrUseCase.call();
      print('QRHistoryBloc._onLoadHistory: history :: $history');
      emit(LoadedHistory(history));
    } catch (e) {
      emit(FailedHistory('Error al cargar el historial: ${e.toString()}'));
    }
  }
}
