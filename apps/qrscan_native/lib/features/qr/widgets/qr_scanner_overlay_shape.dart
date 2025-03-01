import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

/// Clase que define la forma y el diseño de la superposición del escáner de QR.
/// Permite personalizar el color del borde, el ancho del borde, el color de la superposición,
/// el radio de las esquinas, la longitud del borde, el tamaño del área de recorte, el degradado y más.
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
  /// [isBorderAnimated]: Si el borde debe animarse para resaltar el área de escaneo. Por defecto es true.
  /// [borderAnimationColor]: Color de la animación del borde. Por defecto es blanco.
  /// [helpText]: Texto de ayuda para el usuario. Por defecto es "Escanea el código QR".
  /// [helpTextStyle]: Estilo del texto de ayuda. Por defecto es un texto blanco con tamaño 16.
  /// [gradient]: Degradado para el área de escaneo. Por defecto es un degradado transparente.
  /// [scanLineColor]: Color de la línea de escaneo. Por defecto es blanco.
  /// [scanLineHeight]: Altura de la línea de escaneo. Por defecto es 2.0.
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
    this.isBorderAnimated = true,
    this.borderAnimationColor = Colors.white,
    this.helpText = "Escanea el código QR",
    this.helpTextStyle = const TextStyle(color: Colors.white, fontSize: 16),
    this.gradient = const LinearGradient(
      colors: [Colors.transparent, Colors.transparent],
    ),
    this.scanLineColor = Colors.white,
    this.scanLineHeight = 2.0,
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
  final bool isBorderAnimated; // Si el borde debe animarse.
  final Color borderAnimationColor; // Color de la animación del borde.
  final String helpText; // Texto de ayuda para el usuario.
  final TextStyle helpTextStyle; // Estilo del texto de ayuda.
  final Gradient gradient; // Degradado para el área de escaneo.
  final Color scanLineColor; // Color de la línea de escaneo.
  final double scanLineHeight; // Altura de la línea de escaneo.

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final _borderLength = min(borderLength, min(cutOutWidth, cutOutHeight) / 2);
    final _cutOutWidth = min(cutOutWidth, width - borderOffset * 2);
    final _cutOutHeight = min(cutOutHeight, height - borderOffset * 2);

    // Define el rectángulo de recorte.
    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - _cutOutWidth / 2,
      rect.top + height / 2 - _cutOutHeight / 2 - cutOutBottomOffset,
      _cutOutWidth,
      _cutOutHeight,
    );

    // Dibuja la superposición.
    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, backgroundPaint);

    // Dibuja el área de recorte.
    final cutOutPaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.dstOut;
    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      cutOutPaint,
    );

    // Dibuja el degradado dentro del área de escaneo.
    final gradientPaint = Paint()
      ..shader = gradient.createShader(cutOutRect)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      gradientPaint,
    );

    // Dibuja los bordes.
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    _drawBorderCorners(canvas, cutOutRect, borderPaint, _borderLength);

    // Dibuja la animación del borde si está habilitada.
    if (isBorderAnimated) {
      final animationPaint = Paint()
        ..color = borderAnimationColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..shader = LinearGradient(
          colors: [borderAnimationColor.withOpacity(0), borderAnimationColor],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, _cutOutWidth, _cutOutHeight));

      final animationPath = Path()
        ..moveTo(cutOutRect.left, cutOutRect.top)
        ..lineTo(cutOutRect.right, cutOutRect.top)
        ..lineTo(cutOutRect.right, cutOutRect.bottom)
        ..lineTo(cutOutRect.left, cutOutRect.bottom)
        ..close();

      canvas.drawPath(animationPath, animationPaint);
    }

    // Dibuja la línea de escaneo.
    final scanLinePaint = Paint()
      ..color = scanLineColor
      ..strokeWidth = scanLineHeight;

    // Calcula la posición vertical de la línea de escaneo.
    final scanLineY = cutOutRect.top + (cutOutRect.height * _scanLineProgress);
    canvas.drawLine(
      Offset(cutOutRect.left, scanLineY),
      Offset(cutOutRect.right, scanLineY),
      scanLinePaint,
    );

    // Dibuja el texto de ayuda.
    final textSpan = TextSpan(text: helpText, style: helpTextStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      rect.center.dx - textPainter.width / 2,
      cutOutRect.bottom + 20,
    );
    textPainter.paint(canvas, textOffset);
  }

  /// Progreso de la línea de escaneo (0.0 a 1.0).
  double _scanLineProgress = 0.0;

  /// Actualiza el progreso de la línea de escaneo.
  void updateScanLineProgress(double progress) {
    _scanLineProgress = progress;
  }

  /// Método auxiliar para dibujar los bordes en las esquinas.
  void _drawBorderCorners(Canvas canvas, Rect rect, Paint paint, double borderLength) {
    final cornerRadius = Radius.circular(borderRadius);

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
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
      borderRadius: borderRadius,
      borderLength: borderLength,
      cutOutWidth: cutOutWidth,
      cutOutHeight: cutOutHeight,
      cutOutBottomOffset: cutOutBottomOffset,
      isBorderAnimated: isBorderAnimated,
      borderAnimationColor: borderAnimationColor,
      helpText: helpText,
      helpTextStyle: helpTextStyle,
      gradient: gradient,
      scanLineColor: scanLineColor,
      scanLineHeight: scanLineHeight,
    );
  }
}