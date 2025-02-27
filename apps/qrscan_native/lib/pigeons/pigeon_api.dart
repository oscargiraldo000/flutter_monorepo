import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeons/messages.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/app/src/main/kotlin/com/oscargiraldo000/qrscan_native/Messages.g.kt', // Paquete de destino
  kotlinOptions: KotlinOptions(),
  javaOut: 'android/app/src/main/java/io/flutter/plugins/Messages.java',
  javaOptions: JavaOptions(),
  swiftOut: 'ios/Runner/Messages.g.swift',
  swiftOptions: SwiftOptions(),
  //dartPackageName: 'com.oscargiraldo000.qrscannative',
))
enum Code { one, two }

class MessageData {
  MessageData({required this.code, required this.data});
  String? name;
  String? description;
  Code code;
  Map<String, String> data;
}

@HostApi()
abstract class ExampleHostApi {
  String getHostLanguage();

  // These annotations create more idiomatic naming of methods in Objc and Swift.
  @SwiftFunction('add(_:to:)')
  int add(int a, int b);

  @async
  bool sendMessage(MessageData message);
}
