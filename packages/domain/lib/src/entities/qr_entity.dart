class QREntity {
  /// Código del QR
  final String code;

  /// Marca de tiempo de cuando se generó el QR
  final DateTime timestamp;

  QREntity({required this.code, required this.timestamp});

  String getFormattedTimestamp() {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}';
  }

// Método para identificar el tipo de QR
  String getQrType() {
    if (Uri.tryParse(code)?.hasAbsolutePath ?? false) {
      return "URL";
    } else if (code.startsWith("BEGIN:VCARD")) {
      return "Contacto";
    } else if (code.startsWith("MATMSG:")) {
      return "Correo";
    } else if (code.startsWith("SMSTO:")) {
      return "SMS";
    } else if (code.startsWith("WIFI:")) {
      return "Wi-Fi";
    } else if (code.startsWith("bitcoin:") || code.startsWith("ethereum:")) {
      return "Pago";
    } else if (code.startsWith("geo:")) {
      return "Geolocalización";
    } else if (code.startsWith("BEGIN:VEVENT")) {
      return "Evento";
    } else {
      return "Texto";
    }
  }

  /// Obtiene una fecha legible por humanos
  String getHumanReadableDate() {
    // Formatear la fecha
    final date =
        '${timestamp.day} de ${_getMonthName(timestamp.month)} de ${timestamp.year}';

    // Formatear la hora:minutos:segundos
    final time =
        '${_formatTwoDigits(timestamp.hour)}:${_formatTwoDigits(timestamp.minute)}:${_formatTwoDigits(timestamp.second)}';

    // Combinar fecha y hora
    return '$date $time';
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

  // Método auxiliar para formatear números a dos dígitos
  String _formatTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }
}
