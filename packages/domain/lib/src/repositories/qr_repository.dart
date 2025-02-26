// lib/domain/repositories/qr_repository.dart
import 'package:domain/domain.dart';

/// Contrato para el repositorio de códigos QR
abstract class QRRepository {
  /// Guarda una entidad de código QR
  Future<void> saveQRCode(QREntity entity);

  /// Obtiene el historial de códigos QR
  Future<List<QREntity>> getHistory();
}