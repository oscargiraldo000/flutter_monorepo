/// Excepción base para errores de datos.
class DataException implements Exception {
  final String message;

  /// Constructor que recibe un mensaje de error.
  DataException(this.message);
}

/// Excepción lanzada cuando ocurre un error de red.
class NetworkException extends DataException {
  /// Constructor que inicializa la excepción con un mensaje predeterminado.
  NetworkException() : super('Error de red. Inténtalo de nuevo.');
}

/// Excepción lanzada cuando los datos no son encontrados.
class NotFoundException extends DataException {
  /// Constructor que inicializa la excepción con un mensaje predeterminado.
  NotFoundException() : super('Datos no encontrados.');
}
