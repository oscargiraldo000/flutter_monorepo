/**
package com.oscargiraldo000.qrscannative

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger

class PlatformVersionApiPlugin : FlutterPlugin, PlatformApi.PlatformVersionApi {

    private var binaryMessenger: BinaryMessenger? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessenger = binding.binaryMessenger
        // Registrar la implementación de PlatformVersionApi
        PlatformApi.PlatformVersionApi.setUp(binaryMessenger, this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        PlatformApi.PlatformVersionApi.setUp(binaryMessenger, null)
        binaryMessenger = null
    }

    @NonNull
    override fun getPlatformVersion(): PlatformApi.Version {
        return Version().apply {
            string = "Android " + android.os.Build.VERSION.RELEASE
        }
    }
}
 */
