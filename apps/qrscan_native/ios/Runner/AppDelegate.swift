import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController
    // Declara qrViewFactory en el ámbito correcto.
    let qrViewFactory = QRViewFactory(withRegistrar: controller)

    // Registra la fábrica de vistas nativas.
    if let registrar = registrar(forPlugin: "FlutterQrPlusPlugin") {
      registrar.register(
          qrViewFactory,
          withId: "com.oscargiraldo000.qrscannative/qrview"
      )
    } else {
      print("Error: No se pudo obtener el registrar para el plugin FlutterQrPlusPlugin")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
