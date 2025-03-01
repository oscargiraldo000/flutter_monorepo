import Flutter
import UIKit

// Importa QRViewFactory

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
         guard let controller = window?.rootViewController as? FlutterViewController else {
             fatalError("RootViewController no es de tipo FlutterViewController")
         }

         // Registra la fábrica de vistas nativas
         if let registrar = controller.registrar(forPlugin: "FlutterQrPlusPlugin") {
             let qrViewFactory = QRViewFactory(withRegistrar: registrar)
             registrar.register(
                 qrViewFactory,
                 withId: "com.oscargiraldo000.qrscannative/qrview"
             )
         } else {
             fatalError("No se pudo obtener el registrar para FlutterQrPlusPlugin")
         }
         

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
