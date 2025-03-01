//
//  FlutterQrPlusPlugin.m
//  Runner
//
//  Created by Oscar Giraldo on 28/02/25.
//

#import <Flutter/Flutter.h>
#import "FlutterQrPlusPlugin.h"
#import "Runner-Swift.h" // Asegúrate de que este encabezado esté generado correctamente

@implementation FlutterQrPlusPlugin

// Método para registrar el plugin con el registrar de Flutter
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    @try {
        [SwiftFlutterQrPlusPlugin registerWithRegistrar:registrar];
    } @catch (NSException *exception) {
        NSLog(@"Error al registrar el plugin: %@", exception.reason);
    }
}

@end
