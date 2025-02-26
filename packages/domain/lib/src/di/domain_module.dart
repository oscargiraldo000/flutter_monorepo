import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DomainModule {
  @lazySingleton
  SaveQRCode get saveQRCode => SaveQRCode(sl<QRRepository>());

  @lazySingleton
  GetQRHistory get getQRHistory => GetQRHistory(sl<QRRepository>());
}
