import 'package:pigeon/pigeon.dart';

class Version {
  String? version;
}

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/pigeons/platform_api.g.dart',
    dartOptions: DartOptions(),
    // kotlinOut: 'android/app/src/main/kotlin/com/oscargiraldo000/qrscan_native/Messages.g.kt', // Paquete de destino
    //kotlinOptions: KotlinOptions(),
    javaOut: 'android/app/src/main/java/io/flutter/plugins/PlatformApi.java',
    javaOptions: JavaOptions(
      useGeneratedAnnotation: true,
      package: 'io.flutter.plugins',
    ),
    //swiftOut: 'ios/Runner/Messages.g.swift',
    //swiftOptions: SwiftOptions(),
    dartPackageName: 'com.oscargiraldo000.qrscannative',
  ),
)
@HostApi()
abstract class PlatformVersionApi {
  Version getPlatformVersion();
}
