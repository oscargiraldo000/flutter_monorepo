import 'dart:math';

import 'package:flutter/material.dart';

class QrScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutWidth;
  final double cutOutHeight;
  final double cutOutBottomOffset;
  final bool isBorderAnimated;
  final Color borderAnimationColor;
  final String helpText;
  final TextStyle helpTextStyle;
  final Gradient gradient;
  final Color scanLineColor;
  final double scanLineHeight;
  final double scanLineProgress;

  QrScannerOverlayPainter({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.borderRadius = 0,
    this.borderLength = 40,
    required this.cutOutWidth,
    required this.cutOutHeight,
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
    this.scanLineProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
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

    final scanLineY = cutOutRect.top + (cutOutRect.height * scanLineProgress);
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
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
}