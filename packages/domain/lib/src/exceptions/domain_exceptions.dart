/// Excepción base para errores de dominio.
class DomainException implements Exception {
  final String message;

  /// Constructor que recibe un mensaje de error.
  DomainException(this.message);
}

/// Excepción lanzada cuando el código QR no es válido.
class InvalidQRCodeException extends DomainException {
  /// Constructor que inicializa la excepción con un mensaje predeterminado.
  InvalidQRCodeException() : super('El código QR no es válido.');
}

/// Excepción lanzada cuando no se puede guardar el código QR.
class SaveQRCodeException extends DomainException {
  /// Constructor que inicializa la excepción con un mensaje de error.
  SaveQRCodeException(String message) : super(message);
}

/// Excepción lanzada cuando no se puede obtener el historial de códigos QR.
class GetHistoryException extends DomainException {
  /// Constructor que inicializa la excepción con un mensaje de error.
  GetHistoryException(String message) : super(message);
}