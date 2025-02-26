import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:hive/hive.dart';

//@lazySingleton
class QRDataSource {
  // Getter para acceder a la caja de Hive
  Box<QRModel> get _qrBox => Hive.box<QRModel>('qr_box');

  //final Box<QRModel> _qrBox;

  //QRDataSource(this._qrBox); // Inyectar la caja de Hive

  /// Guarda una entidad de código QR en la base de datos
  Future<void> saveQRCode(QREntity entity) async {
    try {
      final model = QRMapper.toModel(entity);
      await _qrBox.add(model);
    } catch (e) {
      throw DataException('Error al guardar el código QR: $e');
    }
  }

  /// Obtiene el historial de entidades de códigos QR desde la base de datos
  Future<List<QREntity>> getHistory() async {
    try {
      final models = _qrBox.values.toList();
      return models.map((model) => QRMapper.toEntity(model)).toList();
    } catch (e) {
      throw DataException('Error al obtener el historial: $e');
    }
  }
}
