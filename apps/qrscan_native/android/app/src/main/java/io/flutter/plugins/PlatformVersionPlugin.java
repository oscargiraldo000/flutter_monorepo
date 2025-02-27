/**
 * 
 package io.flutter.plugins;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.PlatformVersionPigeon.PlatformVersionApi;
import io.flutter.plugins.PlatformVersionPigeon.Version;

public class PlatformVersionPlugin implements FlutterPlugin, PlatformVersionApi {

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    BinaryMessenger messenger = binding.getBinaryMessenger();
    PlatformVersionApi.setUp(messenger, this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    PlatformVersionApi.setUp(binding.getBinaryMessenger(), null);
  }

  @NonNull
  @Override
  public Version getPlatformVersion() {
    Version version = new Version();
    version.setString("Android " + android.os.Build.VERSION.RELEASE);
    return version;
  }
}
 */
