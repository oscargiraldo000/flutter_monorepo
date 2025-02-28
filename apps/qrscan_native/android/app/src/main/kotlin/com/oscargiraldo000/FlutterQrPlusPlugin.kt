package com.oscargiraldo000.qrscannative

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

// Clase principal del plugin FlutterQrPlusPlugin
class FlutterQrPlusPlugin : FlutterPlugin, ActivityAware {

    /** Registro del plugin usando la incrustación v2 */
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding.platformViewRegistry
            .registerViewFactory(
                VIEW_TYPE_ID,
                QRViewFactory(flutterPluginBinding.binaryMessenger)
            )
    }

    // Método llamado cuando el plugin se separa del motor de Flutter
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // Dejar vacío
        // Anular QrShared.activity y QrShared.binding aquí causará errores si el plugin es separado por otro plugin
    }

    // Método llamado cuando el plugin se adjunta a una actividad
    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        QrShared.activity = activityPluginBinding.activity
        QrShared.binding = activityPluginBinding
    }

    // Método llamado cuando la actividad se separa por cambios de configuración
    override fun onDetachedFromActivityForConfigChanges() {
        QrShared.activity = null
        QrShared.binding = null
    }

    // Método llamado cuando la actividad se vuelve a adjuntar después de cambios de configuración
    override fun onReattachedToActivityForConfigChanges(activityPluginBinding: ActivityPluginBinding) {
        QrShared.activity = activityPluginBinding.activity
        QrShared.binding = activityPluginBinding
    }

    // Método llamado cuando la actividad se separa
    override fun onDetachedFromActivity() {
        QrShared.activity = null
        QrShared.binding = null
    }

    companion object {
        // Identificador del tipo de vista
        private const val VIEW_TYPE_ID = "com.oscargiraldo000.qrscannative/qrview"
        //private const val VIEW_TYPE_ID = "net.touchcapture.qr.flutterqrplus/qrview"
    }
}