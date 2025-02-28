import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscan_native/core/models/barcode.dart';
import 'package:qrscan_native/features/qr/blocs/qrhistory/qrhistory_bloc.dart';
import 'package:qrscan_native/features/qr/pages/qr_scanner_page.dart';
import 'package:qrscan_native/features/qr/widget/qr_code_scanner.dart';
import 'package:qrscan_native/pigeons/platform_api.g.dart'
    show PlatformVersionApi;

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

    /**
     * 
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
     */
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
        try {
          //scanQrCode();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      QRScannerPage(), // Reemplaza con tu pantalla de historial
            ),
          );

          //await _getPlatformVersion();
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
}
