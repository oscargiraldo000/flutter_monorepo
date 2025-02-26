import 'package:data/data.dart';
import 'package:domain/domain.dart';

/// Caso de uso para guardar un código QR
class SaveQRCode {
  //final QRRepository repository = QRRepositoryImpl();

  /// Constructor que recibe una instancia del repositorio de códigos QR
  //SaveQRCode(this.repository);

  /// Llama al repositorio para guardar una entidad de código QR
  ///
  /// Valida que el código no esté vacío y que el timestamp sea posterior al año 2000
  ///
  /// Lanza [InvalidQRCodeException] si la validación falla
  /// Lanza [SaveQRCodeException] si ocurre un error al guardar el código QR
  Future<void> call(QREntity entity) async {
    try {
      // Validación de que el código no esté vacío
      if (entity.code.isEmpty) {
        //throw InvalidQRCodeException();
        throw Exception('Código QR inválido');
      }
      // Validación de que el timestamp sea posterior al año 2000
      if (entity.timestamp.isBefore(DateTime(2000))) {
        //throw InvalidQRCodeException();
        throw Exception('Timestamp inválido');
      }
      Future.delayed(Duration(seconds: 2));
      // Llamada al repositorio para guardar el código QR
      await QRRepositoryImpl().saveQRCode(entity);
    } catch (e) {
      // Manejo de errores y lanzamiento de excepción específica
      throw Exception('Error en el caso de uso SaveQRCode: $e');
    }
  }
}
