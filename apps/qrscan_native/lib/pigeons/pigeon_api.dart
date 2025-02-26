import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut:  'lib/pigeons/pigeon_api_generated.dart',
  javaOut:  'android/app/src/main/java/com/oscargiraldo000/qrscan_native/PigeonApi.java',
  kotlinOut:'android/app/src/main/kotlin/com/oscargiraldo000/qrscan_native/PigeonApi.kts',
  javaOptions: JavaOptions(
    package: 'com.oscargiraldo000.qrscannative',
  ),
  kotlinOptions: KotlinOptions(
    package: 'com.oscargiraldo000.qrscannative',
  ),
  dartPackageName: "com.oscargiraldo000.qrscannative",
  swiftOut: "ios/Runner/PigeonApi.m",
))
@HostApi()
abstract class ScannerApi {
  void startQrScanner();
  void stopQrScanner();
  String getScannedResult();
}
