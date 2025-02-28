import 'package:data/data.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';

class HiveInitializer {
  static final Logger _logger = Logger('HiveInitializer');

  // Método estático para inicializar Hive
  static Future<void> initialize() async {
    try {
      // Obtener el directorio de la aplicación para almacenar las cajas de Hive
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);

      // Registrar adaptadores para los modelos
      Hive.registerAdapter(QRModelAdapter());

      // Abrir la caja (box) que se va a utilizar
      await Hive.openBox<QRModel>('qr_box');
      _logger.info('Hive initialized successfully');
    } catch (e) {
      _logger.severe('Failed to initialize Hive', e);
      rethrow;
    }
  }
}


