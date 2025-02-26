import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'qr_scan_event.dart';
part 'qr_scan_state.dart';

/// Bloc que maneja los eventos y estados relacionados con el escaneo de códigos QR.
class QRScanBloc extends Bloc<QRScanEvent, QRScanState> {
  /// Caso de uso para guardar un código QR.
  final SaveQRCode _saveQRCode;

  /// Caso de uso para obtener el historial de códigos QR.
  final GetQRHistory _getQRHistory;

  /// Constructor que inicializa el Bloc con los casos de uso necesarios.
  QRScanBloc()
      : _saveQRCode = SaveQRCode(),
        _getQRHistory = GetQRHistory(),
        super(QRInitial()) {
    on<ScanQR>(_onScanQR);
    on<LoadHistory>(_onLoadHistory);
  }

  /// Maneja el evento de escanear un código QR.
  /// Emite estados de carga, éxito o error según el resultado.
  void _onScanQR(ScanQR event, Emitter<QRScanState> emit) async {
    emit(QRLoading());
    try {
      final entity = QREntity(code: event.code, timestamp: DateTime.now());
      await _saveQRCode.call(entity);
      emit(QRScannedSuccess(event.code));
    } catch (e) {
      emit(QRScanError('Error al guardar el código QR: ${e.toString()}'));
    }
  }

  /// Maneja el evento de cargar el historial de códigos QR.
  /// Emite estados de carga, éxito o error según el resultado.
  void _onLoadHistory(LoadHistory event, Emitter<QRScanState> emit) async {
    emit(QRHistoryLoading());
    try {
      final history = await _getQRHistory.call();
      emit(QRHistoryLoaded(history));
    } catch (e) {
      emit(QRHistoryError('Error al cargar el historial: ${e.toString()}'));
    }
  }
}
