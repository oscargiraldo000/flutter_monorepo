import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscan_native/core/di/injection.dart';
import 'package:qrscan_native/features/qr_scan/presentation/bloc/qr_scan_bloc.dart';

class QRScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<QRScanBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text('QR Scanner')),
        body: _blocBuilder(),
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );

    /**
     return Scaffold(
      appBar: AppBar(title: Text('QR Scanner')),
      body: buildOld(),
      floatingActionButton: buildBtnOld(context),
    );
     */
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // TODO implementar logica nativa de escanner como `qr_code_scanner`
        //final code = await scanQRCode();
        String code = 'https://www.google.com';
        Future.delayed(Duration(seconds: 1), () {
          // Navigator.of(context).pop();
        });

        if (code.isNotEmpty) {
          context.read<QRScanBloc>().add(ScanQR(code));
          context.read<QRScanBloc>().add(LoadHistory());
        }
      },
      child: Icon(Icons.qr_code),
    );
  }

  BlocBuilder<QRScanBloc, QRScanState> _blocBuilder() {
    return BlocBuilder<QRScanBloc, QRScanState>(
      builder: (context, state) {
        if (state is QRHistoryLoaded) {
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
        } else if (state is QRScanError) {
          return Center(child: Text(state.error));
        } else if (state is QRLoading || state is QRHistoryLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Center(child: Text('Escanee un código QR'));
      },
    );
  }
}
