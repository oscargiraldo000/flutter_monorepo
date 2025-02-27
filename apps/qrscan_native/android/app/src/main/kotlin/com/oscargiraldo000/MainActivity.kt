package com.oscargiraldo000.qrscannative

import android.os.Bundle
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.PlatformApi

class MainActivity : FlutterActivity() {
/*

    private class PlatformVersionApiImpl : PlatformApi.PlatformVersionApi {
        override fun getPlatformVersion(): PlatformApi.Version {
            // Obtener la versión de Android
            val androidVersion = Build.VERSION.RELEASE
            // Crear y devolver un objeto Version
            return PlatformApi.Version(versionString = androidVersion)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Registrar la implementación de PlatformVersionApi
        PlatformApi.PlatformVersionApi.setUp(flutterEngine.dartExecutor.binaryMessenger, PlatformVersionApiImpl())
    }
 */
}