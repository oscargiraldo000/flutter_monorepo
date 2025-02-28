package com.oscargiraldo000.qrscannative

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import android.view.View
import io.flutter.plugin.common.StandardMessageCodec

class QRViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val creationParams = args as? HashMap<String, Any>
        // Implementación de la vista de QR
        return QRView(context, messenger, id, creationParams)
    }
}