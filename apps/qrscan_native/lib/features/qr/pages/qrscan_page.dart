import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscan_native/features/qr/blocs/qrhistory/qrhistory_bloc.dart';
import 'package:qrscan_native/pigeons/pigeon_api.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  //final  _qrScannerApi = ScannerApi();
  String _scannedResult = "";

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
      return const Center(child: Text('No hay qr codes escaneados'));
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
            subtitle: Text(
              item.code,
              overflow: TextOverflow.ellipsis,
            ),
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
        try {
          scanQrCode();
        } catch (e) {
          print(e);
        }
        //const String code = 'https://www.google.com';
        //context.read<QRScanBloc>().add(Scan(code));
        //context.read<QRHistoryBloc>().add(LoadHistory());
      },
      child: const Icon(Icons.qr_code),
    );
  }

  void _startQrScanner() async {
    //_qrScannerApi.startQrScanner();
    await Future.delayed(Duration(seconds: 2)); // Simula el tiempo de escaneo
    //_scannedResult = await _qrScannerApi.getScannedResult();
    setState(() {});
  }

  void scanQrCode() async {
  try {
    //await _qrScannerApi.startQrScanner();
     await Future.delayed(Duration(seconds: 2)); // Simula el tiempo de escaneo
    //_scannedResult = await _qrScannerApi.getScannedResult();
    print('Resultado del escaneo: $_scannedResult');
  } on PlatformException catch (e) {
    print("Error al iniciar escáner: ${e.message}");
  }
}
}
