import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'scanner_bloc_event.dart';
part 'scanner_bloc_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  /// Caso de uso para guardar un código QR.
  late SaveQRCode _saveQrCodeUseCase;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;

  /// Constructor que inicializa el Bloc con los casos de uso necesarios.
  ScannerBloc({SaveQRCode? saveQrCodeUseCase}) : _saveQrCodeUseCase = saveQrCodeUseCase ?? SaveQRCode(), super(InitialScan()) {
    // Se suscribe y ignora eventos nuevos si ya hay uno en ejecución.
    on<Scan>(_onScanQR, transformer: droppable());
    on<ToggleFlash>(_onToggleFlash, transformer: sequential());
    on<ToggleCamera>(_onToggleCamera, transformer: sequential());
  }

  /// Método que se ejecuta cuando se escanea un código QR.
  void _onScanQR(Scan event, Emitter<ScannerState> emit) async {
    // Se emite el estado de carga.
    emit(ScanInProgress());
    try {
      // Se crea la entidad con el código QR y la fecha de escaneo.
      final entity = QREntity(code: event.qrData, timestamp: DateTime.now());
      // Se guarda el código QR escaneado.
      await _saveQrCodeUseCase.call(entity);
      // Se emite el estado de éxito.
      emit(ScanCompleted(event.qrData));
    } catch (e) {
      emit(ScanFailed('Error al guardar el código QR: ${e.toString()}'));
    }
  }

  void _onToggleFlash(ToggleFlash event, Emitter<ScannerState> emit) {
    _isFlashOn = !_isFlashOn;
    emit(FlashToggled(_isFlashOn));
  }

  void _onToggleCamera(ToggleCamera event, Emitter<ScannerState> emit) {
    _isFrontCamera = !_isFrontCamera;
    emit(CameraToggled(_isFrontCamera));
  }
}
