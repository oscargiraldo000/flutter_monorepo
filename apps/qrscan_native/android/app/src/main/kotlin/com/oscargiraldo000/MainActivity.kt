package com.oscargiraldo000.qrscannative

import android.os.Bundle
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("com.oscargiraldo000.qrscannative/qrview", QRViewFactory(flutterEngine.dartExecutor.binaryMessenger))
    }
}