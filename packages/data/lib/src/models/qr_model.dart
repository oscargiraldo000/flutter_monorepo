import 'package:hive/hive.dart';
part 'qr_model.g.dart'; // Archivo generado por Hive

@HiveType(typeId: 0) // typeId debe ser único para cada modelo
class QRModel {
  /// Código del QR
  @HiveField(0) // Cada campo debe tener un HiveField único
  final String code;

  /// Marca de tiempo de cuando se generó el QR
  @HiveField(1)
  final DateTime timestamp;

  QRModel({required this.code, required this.timestamp});

  /// Convierte el modelo a un mapa
  Map<String, dynamic> toMap() {
    return {'code': code, 'timestamp': timestamp.toIso8601String()};
  }

  /// Crea una instancia de QRModel desde un mapa
  factory QRModel.fromMap(Map<String, dynamic> map) {
    return QRModel(
      code: map['code'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
