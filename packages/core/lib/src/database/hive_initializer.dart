import 'package:data/data.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveInitializer {
  // Método estático para inicializar Hive
  static Future<void> initialize() async {
    // Obtener el directorio de la aplicación para almacenar las cajas de Hive
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    // Registrar adaptadores para los modelos
    Hive.registerAdapter(QRModelAdapter());

    // Abrir la caja (box) que se va a utilizar
    await Hive.openBox<QRModel>('qr_box');
  }
}


/**
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
 */