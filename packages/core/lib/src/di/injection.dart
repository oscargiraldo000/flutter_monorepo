import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:core/src/di/injection.config.dart';

final GetIt coreGetIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => coreGetIt.init();
