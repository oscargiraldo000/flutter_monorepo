// lib/core/initialization/hive_initializer.dart
import 'package:data/data.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveInitializer {
  /// Caja de Hive
  static late Box<QRModel> _qrBox;

  /// Inicializa Hive y abre la caja de QRModel
  static Future<void> initialize() async {
    await Hive.initFlutter();
    // Registrar el adaptador
    Hive.registerAdapter(QRModelAdapter());
    // Abrir la caja
    _qrBox = await Hive.openBox<QRModel>('qrBox');
    //await Hive.openBox<QRModel>('qrBox'); // Abrir la caja de Hive
  }

  /// Obtener la instancia de la caja de QRModel
  static Box<QRModel> get qrBox => _qrBox;
}
