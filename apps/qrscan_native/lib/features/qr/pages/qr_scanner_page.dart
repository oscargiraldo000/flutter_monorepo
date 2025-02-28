import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscan_native/features/qr/blocs/qrscan/qrscan_bloc.dart';
import 'package:qrscan_native/features/qr/pages/qr_historial_page.dart';
import 'package:qrscan_native/features/qr/widget/qr_code_scanner.dart'; // Para SystemNavigator.pop()

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool _flashOn = false;
  bool _frontCamera = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        // Pausar la cámara cuando se detecta un código QR
        await controller.pauseCamera();

        // Mostrar un diálogo para preguntar si desea guardar el código
        final guardar = await _mostrarDialogoGuardarQR(context, scanData.code!);

        if (guardar == true) {
          // Guardar el código QR en el BLoC
          final myBloc = BlocProvider.of<QRScanBloc>(context);
          myBloc.add(Scan(scanData.code!));
        }

        // Reanudar la cámara después de que el usuario tome una decisión
        await controller.resumeCamera();
      }
    });
  }

  Future<bool?> _mostrarDialogoGuardarQR(
    BuildContext context,
    String codigoQR,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Código QR detectado'),
          content: Text('¿Deseas guardar el código QR?\n\nCódigo: $codigoQR'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // No guardar
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Guardar
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _verHistorial() {
    // Navegar a la pantalla de historial
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                QRHistorialPage(), // Reemplaza con tu pantalla de historial
      ),
    );
  }

  void _salir() {
    // Cerrar la aplicación
    //SystemNavigator.pop();
  }

  void _toggleFlash() {
    setState(() {
      _flashOn = !_flashOn;
      controller?.toggleFlash();
    });
  }

  void _toggleCamera() {
    setState(() {
      _frontCamera = !_frontCamera;
      controller?.flipCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escáner de QR'),
        actions: [
          IconButton(
            icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleFlash,
            tooltip: _flashOn ? 'Apagar flash' : 'Encender flash',
          ),
          IconButton(
            icon: Icon(_frontCamera ? Icons.camera_front : Icons.camera_rear),
            onPressed: _toggleCamera,
            tooltip:
                _frontCamera ? 'Usar cámara trasera' : 'Usar cámara frontal',
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated:
                  (qrViewController) =>
                      _onQRViewCreated(qrViewController, context),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'historialButton',
            onPressed: _verHistorial,
            child: Icon(Icons.history),
            tooltip: 'Ver historial',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'salirButton',
            onPressed: _salir,
            child: Icon(Icons.exit_to_app),
            tooltip: 'Salir',
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
