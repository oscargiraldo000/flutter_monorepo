import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscan_native/features/historical/pages/historical_page.dart';
import 'package:qrscan_native/features/scanner/bloc/scanner_bloc.dart';
import 'package:qrscan_native/features/scanner/widgets/qr_view.dart';
import 'package:qrscan_native/features/scanner/widgets/scanner_overlay.dart';
// Para SystemNavigator.pop()

class ScannerPage extends StatelessWidget {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isDialogShowing = false;

  ScannerPage({super.key}); // Variable de control

  @override
  Widget build(BuildContext context) {
    var scanArea =
        (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 150.0
            : 300.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Escáner de QR'),
        actions: [
          BlocBuilder<ScannerBloc, ScannerState>(
            builder: (context, state) {
              final isFlashOn = state is FlashToggled ? state.isFlashOn : false;
              return IconButton(
                icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
                onPressed: () => context.read<ScannerBloc>().add(ToggleFlash()),
                tooltip: isFlashOn ? 'Apagar flash' : 'Encender flash',
              );
            },
          ),
          BlocBuilder<ScannerBloc, ScannerState>(
            builder: (context, state) {
              final isFrontCamera =
                  state is CameraToggled ? state.isFrontCamera : false;
              return IconButton(
                icon: Icon(
                  isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                ),
                onPressed:
                    () => context.read<ScannerBloc>().add(ToggleCamera()),
                tooltip:
                    isFrontCamera
                        ? 'Usar cámara trasera'
                        : 'Usar cámara frontal',
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // QRView ocupa toda la pantalla
          Positioned.fill(
            child: QRView(
              //overlay: QrScannerOverlayShape(),
              key: qrKey,
              onQRViewCreated: (qrViewController) {
                _onQRViewCreated(qrViewController, context);
              },
            ),
          ),
          // Superposición centrada para el escáner
          Center(child: ScannerOverlay()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'historialButton',
            onPressed: () => _verHistorial(context),
            tooltip: 'Ver historial',
            child: Icon(Icons.history),
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
      tooltip: 'Salir',
      backgroundColor: Colors.red,
      child: Icon(Icons.exit_to_app),
    );
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

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null && !_isDialogShowing) {
        // Bloquea la apertura de más diálogos
        _isDialogShowing = true;
        // Pausa la cámara
        await controller.pauseCamera();
        final qrCode = scanData.code!;
        final guardar = await _mostrarDialogoGuardarQR(context, scanData.code!);
        if (guardar == true) {
          context.read<ScannerBloc>().add(Scan(qrCode));
        }
        // Reanuda la cámara
        await controller.resumeCamera();
        // Libera el bloqueo cuando se cierra el diálogo
        _isDialogShowing = false;
      }
    });

    // Configurar el flash y la cámara
    context.read<ScannerBloc>().stream.listen((state) {
      if (state is FlashToggled) {
        controller.toggleFlash();
      }
      if (state is CameraToggled) {
        controller.flipCamera();
      }
    });
  }

  void _verHistorial(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HistoricalPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _salir() {
    // Cerrar la aplicación
    //SystemNavigator.pop();
  }
}
