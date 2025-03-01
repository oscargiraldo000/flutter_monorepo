import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan_native/core/models/barcode.dart';
import 'package:qrscan_native/core/models/barcode_format.dart';
import 'package:qrscan_native/core/models/camera.dart';
import 'package:qrscan_native/core/models/camera_exception.dart';

import 'lifecycle_event_handler.dart';
import 'scanner_overlay_shape.dart';

/// Callback que se ejecuta cuando la vista del escáner de QR se ha creado.
/// Recibe un objeto [QRViewController] para controlar la cámara y el escaneo.
typedef QRViewCreatedCallback = void Function(QRViewController);

/// Callback que se ejecuta cuando se establecen los permisos de la cámara.
/// Recibe un objeto [QRViewController] y un booleano que indica si los permisos fueron concedidos.
typedef PermissionSetCallback = void Function(QRViewController, bool);

/// [QRView] es el widget que muestra la cámara y el escáner de códigos QR.
class QRView extends StatefulWidget {
  const QRView({
    required Key key,
    required this.onQRViewCreated,
    this.overlay,
    this.overlayMargin = EdgeInsets.zero,
    this.cameraFacing = CameraFacing.back,
    this.onPermissionSet,
    this.formatsAllowed = const <BarcodeFormat>[],
  }) : super(key: key);

  /// Callback que se ejecuta cuando la vista del escáner de QR se ha creado.
  final QRViewCreatedCallback onQRViewCreated;

  /// Overlay personalizado para la vista del escáner.
  /// Se utiliza para definir un área de escaneo específica.
  final ScannerOverlayShape? overlay;

  /// Margen aplicado al overlay.
  final EdgeInsetsGeometry overlayMargin;

  /// Cámara que se utilizará (frontal o trasera).
  /// Por defecto es la cámara trasera.
  final CameraFacing cameraFacing;

  /// Callback que se ejecuta cuando se establecen los permisos de la cámara.
  final PermissionSetCallback? onPermissionSet;

  /// Formatos de códigos de barras permitidos para el escaneo.
  final List<BarcodeFormat> formatsAllowed;

  @override
  State<StatefulWidget> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  MethodChannel? _channel; // Canal de comunicación con la plataforma nativa.
  QRViewController? controller; // Controlador para gestionar la cámara y el escaneo.
  late LifecycleEventHandler _observer; // Observador del ciclo de vida de la aplicación.

  @override
  void initState() {
    super.initState();
    // Inicializa el observador del ciclo de vida para actualizar las dimensiones cuando la app se reanuda.
    _observer = LifecycleEventHandler(resumeCallBack: updateDimensions);
    WidgetsBinding.instance.addObserver(_observer);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotification,
      child: SizeChangedLayoutNotifier(
        child: (widget.overlay != null)
            ? _getPlatformQrViewWithOverlay() // Vista con overlay personalizado.
            : _getPlatformQrView(), // Vista sin overlay.
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Elimina el observador del ciclo de vida y libera los recursos del controlador.
    WidgetsBinding.instance.removeObserver(_observer);
    controller?._disposeImpl();
  }

  /// Actualiza las dimensiones del área de escaneo.
  Future<void> updateDimensions() async {
    if (_channel == null) return;
    await QRViewController.updateDimensions(
        widget.key as GlobalKey<State<StatefulWidget>>, _channel!,
        overlay: widget.overlay);
  }

  /// Maneja las notificaciones para actualizar las dimensiones.
  bool onNotification(notification) {
    updateDimensions();
    return false;
  }

  /// Retorna la vista del escáner con un overlay personalizado.
  Widget _getPlatformQrViewWithOverlay() {
    return Stack(
      children: [
        _getPlatformQrView(), // Vista del escáner.
        Padding(
          padding: widget.overlayMargin,
          child: Container(
            decoration: ShapeDecoration(
              shape: widget.overlay!, // Aplica el overlay personalizado.
            ),
          ),
        ),
      ],
    );
  }

  /// Retorna la vista del escáner según la plataforma (Android, iOS o Web).
  Widget _getPlatformQrView() {
    if (kIsWeb) {
      return Container(); // Web no está soportado en esta implementación.
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return AndroidView(
            viewType: 'com.oscargiraldo000.qrscannative/qrview',
            onPlatformViewCreated: _onPlatformViewCreated,
            creationParams:
                _QrCameraSettings(cameraFacing: widget.cameraFacing).toMap(),
            creationParamsCodec: const StandardMessageCodec(),
          );
        case TargetPlatform.iOS:
          return UiKitView(
            viewType: 'com.oscargiraldo000.qrscannative/qrview',
            onPlatformViewCreated: _onPlatformViewCreated,
            creationParams:
                _QrCameraSettings(cameraFacing: widget.cameraFacing).toMap(),
            creationParamsCodec: const StandardMessageCodec(),
          );
        default:
          throw UnsupportedError(
              "Plataforma no soportada: $defaultTargetPlatform");
      }
    }
  }

  /// Callback que se ejecuta cuando la vista nativa se ha creado.
  void _onPlatformViewCreated(int id) {
    if (!mounted) return;

    // Crea un canal de comunicación con la plataforma nativa.
    _channel = MethodChannel('com.oscargiraldo000.qrscannative/qrview_$id');

    // Inicializa el controlador y comienza el escaneo.
    final newController = QRViewController._(
        _channel!,
        widget.key as GlobalKey<State<StatefulWidget>>?,
        widget.onPermissionSet,
        widget.cameraFacing)
      .._startScan(widget.key as GlobalKey<State<StatefulWidget>>,
          widget.overlay, widget.formatsAllowed);

    // Libera el controlador anterior si existe.
    controller?._disposeImpl();
    controller = newController;

    // Notifica que la vista se ha creado.
    widget.onQRViewCreated(newController);
  }
}

/// Configuración de la cámara para el escáner de QR.
class _QrCameraSettings {
  _QrCameraSettings({
    this.cameraFacing = CameraFacing.unknown,
  });

  final CameraFacing cameraFacing;

  /// Convierte la configuración a un mapa para enviarla a la plataforma nativa.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cameraFacing': cameraFacing.index,
    };
  }
}

/// Controlador para gestionar la cámara y el escaneo de códigos QR.
class QRViewController {
  QRViewController._(MethodChannel channel, GlobalKey? qrKey,
      PermissionSetCallback? onPermissionSet, CameraFacing cameraFacing)
      : _channel = channel,
        _cameraFacing = cameraFacing {
    // Configura el manejador de llamadas desde la plataforma nativa.
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onRecognizeQR':
          if (call.arguments != null) {
            final args = call.arguments as Map;
            final code = args['code'] as String?;
            final rawType = args['type'] as String;
            final rawBytes = args['rawBytes'] as List<int>?;
            final format = BarcodeTypesExtension.fromString(rawType);
            if (format != BarcodeFormat.unknown) {
              final barcode = Barcode(code, format, rawBytes);
              _scanUpdateController.sink.add(barcode); // Notifica el código escaneado.
            } else {
              throw Exception('Tipo de código QR no reconocido: $rawType');
            }
          }
          break;
        case 'onPermissionSet':
          if (call.arguments != null && call.arguments is bool) {
            _hasPermissions = call.arguments;
            if (onPermissionSet != null) {
              onPermissionSet(this, _hasPermissions); // Notifica el estado de los permisos.
            }
          }
          break;
      }
    });
  }

  bool disposed = false; // Indica si el controlador ha sido liberado.
  final MethodChannel _channel; // Canal de comunicación con la plataforma nativa.
  final CameraFacing _cameraFacing; // Cámara actualmente en uso.
  final StreamController<Barcode> _scanUpdateController =
      StreamController<Barcode>(); // Controlador del stream de códigos escaneados.

  /// Stream que emite los códigos QR escaneados.
  Stream<Barcode> get scannedDataStream => _scanUpdateController.stream;

  bool _hasPermissions = false; // Indica si se han concedido los permisos de la cámara.
  bool get hasPermissions => _hasPermissions;

  /// Inicia el escaneo de códigos QR.
  Future<void> _startScan(GlobalKey key, ScannerOverlayShape? overlay,
      List<BarcodeFormat>? barcodeFormats) async {
    try {
      await QRViewController.updateDimensions(key, _channel, overlay: overlay);
      await _channel.invokeMethod(
          'startScan', barcodeFormats?.map((e) => e.asInt()).toList() ?? []);
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Obtiene información sobre la cámara activa.
  Future<CameraFacing> getCameraInfo() async {
    try {
      var cameraFacing = await _channel.invokeMethod('getCameraInfo') as int;
      if (cameraFacing == -1) return _cameraFacing;
      return CameraFacing.values[cameraFacing];
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Cambia entre la cámara frontal y trasera.
  Future<CameraFacing> flipCamera() async {
    try {
      return CameraFacing.values[await _channel.invokeMethod('flipCamera') as int];
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Obtiene el estado del flash.
  Future<bool?> getFlashStatus() async {
    try {
      return await _channel.invokeMethod('getFlashInfo');
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Activa o desactiva el flash.
  Future<void> toggleFlash() async {
    try {
      await _channel.invokeMethod('toggleFlash');
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Pausa la cámara y el escaneo.
  Future<void> pauseCamera() async {
    try {
      await _channel.invokeMethod('pauseCamera');
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Detiene la cámara y el escaneo.
  Future<void> stopCamera() async {
    try {
      await _channel.invokeMethod('stopCamera');
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Reanuda la cámara y el escaneo.
  Future<void> resumeCamera() async {
    try {
      await _channel.invokeMethod('resumeCamera');
    } on PlatformException catch (e) {
      throw CameraException(e.code, e.message);
    }
  }

  /// Libera los recursos del controlador.
  void _disposeImpl() {
    if (disposed) return;
    disposed = true;
    if (defaultTargetPlatform == TargetPlatform.iOS) stopCamera();
    _scanUpdateController.close(); // Cierra el stream de códigos escaneados.
  }

  /// Actualiza las dimensiones del área de escaneo en la plataforma nativa.
  static Future<bool> updateDimensions(GlobalKey key, MethodChannel channel,
      {ScannerOverlayShape? overlay}) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (key.currentContext == null) return false;
      final renderBox = key.currentContext!.findRenderObject() as RenderBox;
      try {
        await channel.invokeMethod('setDimensions', {
          'width': renderBox.size.width,
          'height': renderBox.size.height,
          'scanAreaWidth': overlay?.cutOutWidth ?? 0,
          'scanAreaHeight': overlay?.cutOutHeight ?? 0,
          'scanAreaOffset': overlay?.cutOutBottomOffset ?? 0
        });
        return true;
      } on PlatformException catch (e) {
        throw CameraException(e.code, e.message);
      }
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      if (overlay == null) return false;
      await channel.invokeMethod('changeScanArea', {
        'scanAreaWidth': overlay.cutOutWidth,
        'scanAreaHeight': overlay.cutOutHeight,
        'cutOutBottomOffset': overlay.cutOutBottomOffset
      });
      return true;
    }
    return false;
  }

  /// Invierte el escaneo (solo en Android).
  Future<void> scanInvert(bool isScanInvert) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _channel.invokeMethod('invertScan', {"isInvertScan": isScanInvert});
      } on PlatformException catch (e) {
        throw CameraException(e.code, e.message);
      }
    }
  }
}
