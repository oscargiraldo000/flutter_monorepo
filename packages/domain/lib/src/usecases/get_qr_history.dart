import 'package:data/data.dart';
import 'package:domain/domain.dart';

/// Caso de uso para obtener el historial de códigos QR.
//@lazySingleton
class GetQRHistory {
  final QRRepository repository = QRRepositoryImpl();

  /// Constructor que recibe una instancia de [QRRepository].
  //GetQRHistory(this.repository);

  /// Llama al repositorio para obtener la lista de historiales de códigos QR.
  ///
  /// Retorna una lista de objetos [QrHistory].
  Future<List<QREntity>> call() async {
    try {
      //print('GetQRHistory.call');
      final qrHistoryList = await repository.getHistory();
      //print('GetQRHistory.call $qrHistoryList');
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
