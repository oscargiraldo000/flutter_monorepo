import 'package:flutter/material.dart';
import 'package:qrscan_native/features/scanner/widgets/scanner_overlay_painter.dart';

class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({super.key});

  @override
  _ScannerOverlayState createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
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
          painter: QrScannerOverlayPainter.ScannerOverlayPainter(
            cutOutWidth: 300,
            cutOutHeight: 300,
            scanLineProgress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}
