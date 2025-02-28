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
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        //context.read<QRScanBloc>().add(Scan(code));
        final myBloc = BlocProvider.of<QRScanBloc>(context);
        myBloc.add(Scan((scanData.code!)));
      }
    });
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
    // Lógica para encender/apagar el flash
  }

  void _toggleCamera() {
    setState(() {
      _frontCamera = !_frontCamera;
      controller?.flipCamera();
    });
    // Lógica para cambiar entre cámara frontal y trasera
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
          /**
           Expanded(
            flex: 1,
            child: Center(
              child:
                  (result != null)
                      ? Text(
                        'Tipo de código: ${describeEnum(result!.format)}   Datos: ${result!.code}',
                      )
                      : Text('Escanea un código'),
            ),
          ),
           */
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
