import 'package:flutter/material.dart';
import 'package:qrscan_native/features/qr/widgets/qr_scanner_overlay_painter.dart';
import 'package:qrscan_native/features/qr/widgets/qr_scanner_overlay_shape.dart';

class QrScannerOverlay extends StatefulWidget {
  @override
  _QrScannerOverlayState createState() => _QrScannerOverlayState();
}

class _QrScannerOverlayState extends State<QrScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: QrScannerOverlayPainter(
            cutOutWidth: 250,
            cutOutHeight: 250,
            scanLineProgress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}
