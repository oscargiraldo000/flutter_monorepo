import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: QRRepository)
class QRRepositoryImpl implements QRRepository {
  final QRDataSource _qrDataSource;

  QRRepositoryImpl(this._qrDataSource);

  /// Guarda una entidad de código QR utilizando el data source
  @override
  Future<void> saveQRCode(QREntity entity) async {
    try {
      await _qrDataSource.saveQRCode(entity);
    } catch (e) {
      throw DataException('Error al guardar el código QR: $e');
    }
  }

  /// Obtiene el historial de entidades de códigos QR utilizando el data source
  @override
  Future<List<QREntity>> getHistory() async {
    try {
      return await _qrDataSource.getHistory();
    } catch (e) {
      throw DataException('Error al obtener el historial: $e');
    }
  }
}
