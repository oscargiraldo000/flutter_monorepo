import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Caso de uso para obtener el historial de códigos QR.
@lazySingleton
class GetQRHistory {
  final QRRepository repository;

  /// Constructor que recibe una instancia de [QRRepository].
  GetQRHistory(this.repository);

  /// Llama al repositorio para obtener la lista de historiales de códigos QR.
  ///
  /// Retorna una lista de objetos [QrHistory].
  Future<List<QREntity>> call() async {
    try {
      final qrHistoryList = await repository.getHistory();
      if (qrHistoryList.isEmpty) {
        //throw NotFoundException(); // Validación de datos
        return [];
      }
      return qrHistoryList;
    } on DataException catch (e) {
      throw DomainException(
        e.message,
      ); // Convertir excepciones de datos en excepciones de dominio
    } catch (e) {
      throw Exception('Error en el caso de uso GetQRHistory: $e');
    }
  }
}
