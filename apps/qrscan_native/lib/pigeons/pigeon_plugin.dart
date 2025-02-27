import 'dart:async';
//import 'package:qrscan_native/pigeons/platform_version_pigeon.g.dart';

//import 'messages.dart';

class PigeonPlugin {
  //static late PlatformVersionApi _api = PlatformVersionApi();
  static Future<String> get platformVersion async {
   // Version version = await _api.getPlatformVersion();
    //return version.string!;
    return '0.0.1';
  }
}