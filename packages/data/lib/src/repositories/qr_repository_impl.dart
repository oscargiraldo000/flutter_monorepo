
import 'package:data/data.dart';
import 'package:domain/domain.dart';

//@LazySingleton(as: QRRepository)
class QRRepositoryImpl implements QRRepository {
  final QRDataSource _qrDataSource = QRDataSource();

  //QRRepositoryImpl(this._qrDataSource);

  /// Guarda una entidad de código QR utilizando el data source
  @override
  Future<void> saveQRCode(QREntity entity) async {
    try {
      if(entity.code.isEmpty) {
        throw InvalidQRCodeException();
      }
      if(entity.timestamp.isBefore(DateTime(2000))) {
        throw InvalidQRCodeException();
      }
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
