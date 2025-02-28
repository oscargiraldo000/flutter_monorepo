// Importa el archivo de cabecera de la clase FlutterQrPlusPlugin.
#import "FlutterQrPlusPlugin.h"

// Importa directamente el archivo de cabecera generado por Swift.
// Esto asume que el archivo está disponible en el proyecto.
#import "qr_code_scanner_plus-Swift.h"

// Implementación de la clase FlutterQrPlusPlugin.
@implementation FlutterQrPlusPlugin

// Método estático para registrar el plugin en Flutter.
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    // Llama al método de registro de la clase SwiftFlutterQrPlusPlugin.
    [SwiftFlutterQrPlusPlugin registerWithRegistrar:registrar];
}

@end