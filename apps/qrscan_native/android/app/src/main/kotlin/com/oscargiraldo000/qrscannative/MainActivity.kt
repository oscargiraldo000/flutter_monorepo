package com.oscargiraldo000.qrscannative

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import android.util.Log


class MainActivity : FlutterActivity() {

    /**
override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        PigeonApi.setup(flutterEngine.dartExecutor.binaryMessenger, QrScannerApiImpl())


        //PigeonApi.setUp(flutterEngine?.dartExecutor?.binaryMessenger, QrScannerApiImpl())
        //QrScannerApiImpl.setUp(flutterEngine?.dartExecutor?.binaryMessenger) // Línea añadida
        // Configurar EventChannel
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "dev.flutter.pigeon.com.oscargiraldo000.qrscannative.QrScannerApi.startQrScanner").setStreamHandler(
            Log.i("MainActivity $events")
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    LocationEventChannel.setEventSink(events)
                }

                override fun onCancel(arguments: Any?) {
                    LocationEventChannel.setEventSink(null)
                }
            }
        )

        // Configurar MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startLocationService" -> {
                    startLocationService()
                    result.success("Servicio de ubicación iniciado")
                }
                "stopLocationService" -> {
                    stopLocationService()
                    result.success("Servicio de ubicación detenido")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
 */

}