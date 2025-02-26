import 'package:data/data.dart';
import 'package:domain/domain.dart';

class QRMapper {
  /// Convierte un QRModel a QREntity
  static QREntity toEntity(QRModel model) {
    return QREntity(code: model.code, timestamp: model.timestamp);
  }

  /// Convierte un QREntity a QRModel
  static QRModel toModel(QREntity entity) {
    return QRModel(code: entity.code, timestamp: entity.timestamp);
  }
}
