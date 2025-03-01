//
//  SwiftFlutterQrPlusPlugin.swift
//  Runner
//
//  Created by Oscar Giraldo on 28/02/25.
//

import Flutter
import UIKit

public class SwiftFlutterQrPlusPlugin: NSObject, FlutterPlugin {
    private var factory: QRViewFactory

    // Inicializador del plugin con el registrar de Flutter
    public init(with registrar: FlutterPluginRegistrar) {
        self.factory = QRViewFactory(withRegistrar: registrar)
        super.init()
        // Registro de la fábrica de vistas nativas
        registrar.register(factory, withId: "com.oscargiraldo000.qrscannative/qrview")
    }

    // Método estático para registrar el plugin
    public static func register(with registrar: FlutterPluginRegistrar) {
        _ = SwiftFlutterQrPlusPlugin(with: registrar)
    }
}
