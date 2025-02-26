class QREntity {
  /// Código del QR
  final String code;

  /// Marca de tiempo de cuando se generó el QR
  final DateTime timestamp;

  QREntity({required this.code, required this.timestamp});

  String getFormattedTimestamp() {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}';
  }

  /// Obtiene una fecha legible por humanos
  String getHumanReadableDate() {
    return '${timestamp.day} de ${_getMonthName(timestamp.month)} de ${timestamp.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return months[month - 1];
  }
}
