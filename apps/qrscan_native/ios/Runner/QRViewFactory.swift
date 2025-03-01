//
//  QRViewFactory.swift
//  Runner
//
//  Created by Oscar Giraldo on 28/02/25.
//

import Foundation
import Flutter

public class QRViewFactory: NSObject, FlutterPlatformViewFactory {
    private weak var registrar: FlutterPluginRegistrar?

    // Inicializador de la fábrica con el registrar de Flutter
    public init(withRegistrar registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }

    // Método para crear una instancia de QRView
    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        guard let registrar = registrar else {
            fatalError("El registrar no puede ser nil al crear una instancia de QRView.")
        }

        let params = (args as? [String: Any]) ?? [:] // Manejo más flexible de parámetros
        return QRView(
            withFrame: frame,
            withRegistrar: registrar,
            withId: viewId,
            params: params
        )
    }

    // Método para crear el codec de argumentos
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
