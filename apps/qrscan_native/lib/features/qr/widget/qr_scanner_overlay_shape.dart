import 'dart:math';
import 'package:flutter/material.dart';

/// Clase que define la forma y el diseño de la superposición del escáner de QR.
/// Permite personalizar el color del borde, el ancho del borde, el color de la superposición,
/// el radio de las esquinas, la longitud del borde y el tamaño del área de recorte.
class QrScannerOverlayShape extends ShapeBorder {
  /// Constructor de la clase.
  /// 
  /// [borderColor]: Color del borde del área de escaneo. Por defecto es rojo.
  /// [borderWidth]: Ancho del borde. Por defecto es 3.0.
  /// [overlayColor]: Color de la superposición fuera del área de escaneo. Por defecto es semi-transparente.
  /// [borderRadius]: Radio de las esquinas del área de escaneo. Por defecto es 0 (esquinas rectas).
  /// [borderLength]: Longitud de los bordes en las esquinas. Por defecto es 40.
  /// [cutOutSize]: Tamaño del área de recorte (ancho y alto). Si no se especifica, se usa 250.
  /// [cutOutWidth]: Ancho del área de recorte. Si no se especifica, se usa [cutOutSize].
  /// [cutOutHeight]: Alto del área de recorte. Si no se especifica, se usa [cutOutSize].
  /// [cutOutBottomOffset]: Desplazamiento vertical del área de recorte. Por defecto es 0.
  QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.borderRadius = 0,
    this.borderLength = 40,
    double? cutOutSize,
    double? cutOutWidth,
    double? cutOutHeight,
    this.cutOutBottomOffset = 0,
  })  : cutOutWidth = cutOutWidth ?? cutOutSize ?? 250,
        cutOutHeight = cutOutHeight ?? cutOutSize ?? 250 {
    // Validación para asegurar que la longitud del borde no sea mayor que el área de recorte.
    assert(
      borderLength <= min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2,
      "La longitud del borde no puede ser mayor que ${min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2}",
    );

    // Validación para asegurar que solo se use `cutOutSize` o `cutOutWidth` y `cutOutHeight`.
    assert(
      (cutOutWidth == null && cutOutHeight == null) ||
          (cutOutSize == null && cutOutWidth != null && cutOutHeight != null),
      'Usa solo cutOutWidth y cutOutHeight o solo cutOutSize',
    );
  }

  final Color borderColor; // Color del borde.
  final double borderWidth; // Ancho del borde.
  final Color overlayColor; // Color de la superposición.
  final double borderRadius; // Radio de las esquinas.
  final double borderLength; // Longitud de los bordes en las esquinas.
  final double cutOutWidth; // Ancho del área de recorte.
  final double cutOutHeight; // Alto del área de recorte.
  final double cutOutBottomOffset; // Desplazamiento vertical del área de recorte.

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // Retorna un camino (Path) que representa el área interna del borde.
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // Retorna un camino (Path) que representa el área externa del borde.
    return Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width; // Ancho total del área de dibujo.
    final height = rect.height; // Alto total del área de dibujo.
    final borderOffset = borderWidth / 2; // Offset para ajustar el borde.
    final _borderLength = min(borderLength, min(cutOutWidth, cutOutHeight) / 2); // Longitud ajustada del borde.
    final _cutOutWidth = min(cutOutWidth, width - borderOffset * 2); // Ancho ajustado del área de recorte.
    final _cutOutHeight = min(cutOutHeight, height - borderOffset * 2); // Alto ajustado del área de recorte.

    // Define el rectángulo de recorte centrado en el área de dibujo.
    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - _cutOutWidth / 2,
      rect.top + height / 2 - _cutOutHeight / 2 - cutOutBottomOffset,
      _cutOutWidth,
      _cutOutHeight,
    );

    // Pincel para dibujar la superposición.
    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    // Dibuja la superposición en todo el rectángulo.
    canvas.drawRect(rect, backgroundPaint);

    // Pincel para dibujar el área de recorte (transparente).
    final cutOutPaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.dstOut;

    // Dibuja el área de recorte con esquinas redondeadas.
    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      cutOutPaint,
    );

    // Pincel para dibujar los bordes.
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Dibuja los bordes en las esquinas del área de recorte.
    _drawBorderCorners(canvas, cutOutRect, borderPaint, _borderLength);
  }

  /// Método auxiliar para dibujar los bordes en las esquinas del área de recorte.
  void _drawBorderCorners(Canvas canvas, Rect rect, Paint paint, double borderLength) {
    final cornerRadius = Radius.circular(borderRadius); // Radio de las esquinas.

    // Esquina superior izquierda.
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rect.left,
        rect.top,
        rect.left + borderLength,
        rect.top + borderLength,
        topLeft: cornerRadius,
      ),
      paint,
    );

    // Esquina superior derecha.
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rect.right - borderLength,
        rect.top,
        rect.right,
        rect.top + borderLength,
        topRight: cornerRadius,
      ),
      paint,
    );

    // Esquina inferior izquierda.
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rect.left,
        rect.bottom - borderLength,
        rect.left + borderLength,
        rect.bottom,
        bottomLeft: cornerRadius,
      ),
      paint,
    );

    // Esquina inferior derecha.
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rect.right - borderLength,
        rect.bottom - borderLength,
        rect.right,
        rect.bottom,
        bottomRight: cornerRadius,
      ),
      paint,
    );
  }

  @override
  ShapeBorder scale(double t) {
    // Escala la forma manteniendo las proporciones.
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
      borderRadius: borderRadius,
      borderLength: borderLength,
      cutOutWidth: cutOutWidth,
      cutOutHeight: cutOutHeight,
      cutOutBottomOffset: cutOutBottomOffset,
    );
  }
}