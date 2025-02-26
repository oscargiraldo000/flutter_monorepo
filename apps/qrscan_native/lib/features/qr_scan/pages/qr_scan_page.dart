import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscan_native/features/qr_scan/presentation/bloc/qr_scan_bloc.dart';

class QRScanPage extends StatelessWidget {
  const QRScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Scanner')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<QRScanBloc, QRScanState>(
              
              builder: (context, state) {
                print('State: $state');
                if (state is QRInitial) {
                  return _buildInitial();
                } else if (state is QRLoading) {
                  return _buildLoading();
                } else if (state is QRScannedSuccess) {
                  return _buildScannedSuccess(state);
                } else if (state is QRScanError) {
                  return _buildError(state);
                } else {
                  return _buildUnknownState();
                }

/**
if (state is QRHistoryLoaded) {
                  return _buildHistoryList(state);
                } else if (state is QRScanError) {
                  return _buildError(state);
                } else if (state is QRLoading || state is QRHistoryLoading) {
                  return _buildLoading();
                } else if (state is QRInitial) {
                  return _buildInitial();
                } else if (state is QRScannedSuccess) {
                  return _buildScannedSuccess(state);
                }
                return _buildUnknownState();
 */
              },
            ),
          ),
          Divider(),
          Expanded(child: _buildHistorySection(context),          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildHistoryList(QRHistoryLoaded state) {
    return ListView.builder(
      itemCount: state.history.length,
      itemBuilder: (context, index) {
        final item = state.history[index];
        return ListTile(
          title: Text(item.code),
          subtitle: Text(item.timestamp.toString()),
        );
      },
    );
  }

   Widget _buildHistoryError(QRHistoryError state) {
    return Center(child: Text(state.error));
  }

  Widget _buildError(QRScanError state) {
    return Center(child: Text(state.error));
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildInitial() {
    return Center(child: Text('Escanee un código QR'));
  }

  Widget _buildScannedSuccess(QRScannedSuccess state) {
    return Center(child: Text('Código escaneado: ${state.code}'));
  }

  Widget _buildUnknownState() {
    return Center(child: Text('Estado desconocido'));
  }

  Widget _buildHistorySection(BuildContext context) {
    return BlocBuilder<QRScanBloc, QRScanState>(
      builder: (context, state) {
        if (state is QRHistoryLoaded) {
          return _buildHistoryList(state);
        } else if (state is QRHistoryLoading) {
          return _buildLoading();
        } else if (state is QRHistoryError) {
          return _buildHistoryError(state);
        }
        _getList(context);
        return Center(child: Text('No hay historial disponible'));
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        //await Future.delayed(Duration(seconds: 2));
        String code = '';
        context.read<QRScanBloc>().add(ScanQR(code));
        //context.read<QRScanBloc>().add(LoadHistory());

        /**
         if (code.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Escaneo cancelado o fallido')),
          );
        } else {
          context.read<QRScanBloc>().add(ScanQR(code));
          context.read<QRScanBloc>().add(LoadHistory());
        }
         */
      },
      child: Icon(Icons.qr_code),
    );
  }
  
  void _getList(BuildContext context) {
    context.read<QRScanBloc>().add(LoadHistory());
  }
}
