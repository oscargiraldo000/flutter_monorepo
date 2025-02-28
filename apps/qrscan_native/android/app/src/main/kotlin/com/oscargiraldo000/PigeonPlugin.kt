/**
package com.oscargiraldo000.qrscannative

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
 */

/** PigeonPlugin */
/*
class PigeonPlugin: FlutterPlugin, PlatformApi.PlatformVersionApi {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    PlatformApi.PlatformVersionApi.setup(flutterPluginBinding.binaryMessenger, this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    PlatformApi.PlatformVersionApi.setup(binding.binaryMessenger, null)
  }

  override fun getPlatformVersion(): PlatformApi.Version {
    var result = PlatformApi.Version()
    result.string = "Android ${android.os.Build.VERSION.RELEASE}"
    return result
  }
}
 */
