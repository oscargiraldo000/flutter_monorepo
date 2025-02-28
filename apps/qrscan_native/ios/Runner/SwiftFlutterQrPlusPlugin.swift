import Flutter
import UIKit

// Clase principal del plugin que implementa `FlutterPlugin`.
public class SwiftFlutterQrPlusPlugin: NSObject, FlutterPlugin {
    
    // Instancia de la fábrica de vistas para crear `QRView`.
    private var factory: QRViewFactory
    
    // Inicializador que recibe el `FlutterPluginRegistrar`.
    public init(with registrar: FlutterPluginRegistrar) {
        // Inicializa la fábrica de vistas.
        self.factory = QRViewFactory(withRegistrar: registrar)
        
        // Registra la fábrica de vistas con un identificador único.
        registrar.register(factory, withId: "com.oscargiraldo000.qrscannative/qrview")
    }
    
    // Método estático para registrar el plugin en Flutter.
    public static func register(with registrar: FlutterPluginRegistrar) {
        // Registra el plugin como delegado de la aplicación.
        registrar.addApplicationDelegate(SwiftFlutterQrPlusPlugin(with: registrar))
    }
    
    // Método del ciclo de vida de la aplicación: se llama cuando la aplicación entra en segundo plano.
    public func applicationDidEnterBackground(_ application: UIApplication) {
        // Puedes agregar lógica adicional aquí si es necesario.
    }
    
    // Método del ciclo de vida de la aplicación: se llama cuando la aplicación está a punto de terminar.
    public func applicationWillTerminate(_ application: UIApplication) {
        // Puedes agregar lógica adicional aquí si es necesario.
    }
}
