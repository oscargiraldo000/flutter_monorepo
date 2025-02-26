import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:qrscan_native/features/qr/blocs/qrscan/qrscan_bloc.dart';

//import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  //getIt.registerSingleton(() => QRScanBloc(saveQRCode: null));

  //getIt.init();
}
