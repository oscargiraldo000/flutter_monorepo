import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan_native/features/qr/blocs/qrhistory/qrhistory_bloc.dart';
import 'package:qrscan_native/features/qr/pages/qr_scanner_page.dart';

class QRHistorialPage extends StatefulWidget {
  const QRHistorialPage({super.key});

  @override
  State<QRHistorialPage> createState() => _QRHistorialPageState();
}

class _QRHistorialPageState extends State<QRHistorialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner Native')),
      body: BlocConsumer<QRHistoryBloc, QRHistoryState>(
        builder: _builderHistory,
        listener: _listenerHistory,
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _builderHistory(BuildContext context, QRHistoryState state) {
    if (state is InitialHistory || state is InProgressHistory) {
      return _buildLoading();
    } else if (state is LoadedHistory) {
      return _buildHistoryList(state);
    } else if (state is FailedHistory) {
      return _buildError(state.errorMessage);
    }
    return Container();
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 1),
          SizedBox(height: 8),
          Text('Cargando historial de QRs...'),
        ],
      ),
    );
  }

  Widget _buildHistoryList(LoadedHistory state) {
    if (state.history.isEmpty) {
      return const Center(child: Text('No hay códigos QR escaneados'));
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: state.history.length,
      itemBuilder: (context, index) {
        final item = state.history[index];
        return FadeInLeft(
          child: ListTile(
            title: Text(item.getQrType()),
            subtitle: Text(item.code, overflow: TextOverflow.ellipsis),
            trailing: Text(item.getHumanReadableDate()),
          ),
        );
      },
    );
  }

  Widget _buildError(String errorMessage) {
    return Center(child: Text(errorMessage));
  }

  void _listenerHistory(BuildContext context, QRHistoryState state) {
    if (state is FailedHistory) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await _checkCameraPermission(context);
      },
      child: const Icon(Icons.qr_code),
    );
  }

  /// Verifica y solicita permisos de la cámara.
  Future<void> _checkCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      // Permiso ya concedido, navega al escáner.
      _navigateToQRScannerPage(context);
    } else if (status.isDenied || status.isRestricted) {
      // Permiso no concedido o restringido, solicita permiso.
      final result = await Permission.camera.request();
      if (result.isGranted) {
        _navigateToQRScannerPage(context);
      } else if (result.isPermanentlyDenied) {
        // Permiso denegado permanentemente, muestra diálogo.
        _showPermissionDeniedDialog(context);
      }
    } else if (status.isPermanentlyDenied) {
      // Permiso denegado permanentemente, muestra diálogo.
      _showPermissionDeniedDialog(context);
    }
  }

  /// Navega a la página del escáner de QR.
  void _navigateToQRScannerPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => QRScannerPage()),
      (Route<dynamic> route) => false,
    );
  }

  /// Muestra un diálogo informando que el permiso de la cámara fue denegado permanentemente
  /// y ofrece la opción de abrir la configuración de la aplicación.
  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Permiso de cámara denegado'),
            content: const Text(
              'Para escanear códigos QR, necesitas conceder permiso para usar la cámara. '
              'Por favor, habilita el permiso manualmente en la configuración de la aplicación.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Cierra el diálogo.
                  await openAppSettings(); // Abre la configuración de la aplicación.
                },
                child: const Text('Abrir configuración'),
              ),
            ],
          ),
    );
  }
}
