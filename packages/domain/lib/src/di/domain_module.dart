
/**
 @module
abstract class DomainModule {
  @lazySingleton
  SaveQRCode get saveQRCode => SaveQRCode(sl<QRRepository>());

  @lazySingleton
  GetQRHistory get getQRHistory => GetQRHistory(sl<QRRepository>());
}
 */
