package com.oscargiraldo000.qrscannative

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import android.view.View
import io.flutter.plugin.common.StandardMessageCodec

/// Clase que actúa como una fábrica para crear instancias de [QRView].
/// Extiende [PlatformViewFactory] para permitir la creación de vistas personalizadas en Flutter.
class QRViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    /// Método que crea una instancia de [QRView].
    ///
    /// [context]: Contexto de Android necesario para crear la vista.
    /// [id]: Identificador único para la vista.
    /// [args]: Parámetros de creación pasados desde Flutter. Pueden ser nulos.
    ///
    /// Retorna una instancia de [QRView] configurada con los parámetros proporcionados.
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        // Convierte los parámetros de creación a un HashMap.
        val creationParams = args as? HashMap<String, Any>

        // Retorna una nueva instancia de QRView con los parámetros proporcionados.
        return QRView(context, messenger, id, creationParams)
    }
}