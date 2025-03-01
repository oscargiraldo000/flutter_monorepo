import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';

/// Clase que maneja los eventos del ciclo de vida de la aplicación.
/// Extiende [WidgetsBindingObserver] para observar cambios en el estado de la aplicación.
class LifecycleEventHandler extends WidgetsBindingObserver {
  /// Constructor de la clase.
  ///
  /// [resumeCallBack]: Callback que se ejecuta cuando la aplicación entra en estado `resumed`.
  LifecycleEventHandler({required this.resumeCallBack});

  /// Callback asíncrono que se ejecuta cuando la aplicación se reanuda.
  late final AsyncCallback resumeCallBack;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // Maneja los cambios en el estado del ciclo de vida de la aplicación.
    switch (state) {
      case AppLifecycleState.resumed:
        // Cuando la aplicación se reanuda, ejecuta el callback proporcionado.
        await resumeCallBack();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // No se realiza ninguna acción en estos estados.
        break;
    }
  }
}
