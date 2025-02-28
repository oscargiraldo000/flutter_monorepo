import 'package:data/data.dart';
import 'package:hive/hive.dart';

//@module
abstract class HiveModule {
  //@preResolve
  Future<Box<QRModel>> get qrBox async {
    return await Hive.openBox<QRModel>('qr_box');
  }
}