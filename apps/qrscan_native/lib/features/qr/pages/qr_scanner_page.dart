import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscan_native/features/qr/blocs/qrscan/qrscan_bloc.dart';
import 'package:qrscan_native/features/qr/pages/qr_historial_page.dart';
import 'package:qrscan_native/features/qr/widget/qr_code_scanner.dart'; // Para SystemNavigator.pop()

class QRScannerPage extends StatelessWidget {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escáner de QR'),
        actions: [
          BlocBuilder<QRScanBloc, QRScanState>(
            builder: (context, state) {
              final isFlashOn = state is FlashToggled ? state.isFlashOn : false;
              return IconButton(
                icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
                onPressed: () => context.read<QRScanBloc>().add(ToggleFlash()),
                tooltip: isFlashOn ? 'Apagar flash' : 'Encender flash',
              );
            },
          ),
          BlocBuilder<QRScanBloc, QRScanState>(
            builder: (context, state) {
              final isFrontCamera =
                  state is CameraToggled ? state.isFrontCamera : false;
              return IconButton(
                icon: Icon(
                  isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                ),
                onPressed: () => context.read<QRScanBloc>().add(ToggleCamera()),
                tooltip:
                    isFrontCamera
                        ? 'Usar cámara trasera'
                        : 'Usar cámara frontal',
              );
            },
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
            onPressed: () => _verHistorial(context),
            child: Icon(Icons.history),
            tooltip: 'Ver historial',
          ),
          SizedBox(height: 10),
          //buildBtnSalir(),
        ],
      ),
    );
  }

  FloatingActionButton buildBtnSalir() {
    return FloatingActionButton(
          heroTag: 'salirButton',
          onPressed: _salir,
          child: Icon(Icons.exit_to_app),
          tooltip: 'Salir',
          backgroundColor: Colors.red,
        );
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        await controller.pauseCamera();
        final guardar = await _mostrarDialogoGuardarQR(context, scanData.code!);
        if (guardar == true) {
          context.read<QRScanBloc>().add(Scan(scanData.code!));
        }
        await controller.resumeCamera();
      }
    });

    // Configurar el flash y la cámara
    context.read<QRScanBloc>().stream.listen((state) {
      if (state is FlashToggled) {
        controller.toggleFlash();
      }
      if (state is CameraToggled) {
        controller.flipCamera();
      }
    });
  }

  Future<bool?> _mostrarDialogoGuardarQR(
    BuildContext context,
    String codigoQR,
  ) async {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Código QR detectado'),
          content: Text('¿Deseas guardar el código QR?\n\nCódigo: $codigoQR'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _verHistorial(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => QRHistorialPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _salir() {
    // Cerrar la aplicación
    //SystemNavigator.pop();
  }
}
