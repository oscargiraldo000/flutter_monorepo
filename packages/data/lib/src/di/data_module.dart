
/// Módulo de inyección de dependencias para la capa de datos.
//@module
abstract class DataModule {
  /// Provee una instancia de [Box<QRModel>] con la caja abierta antes de inyectarla.
  /**
 @preResolve
  Future<Box<QRModel>> get qrBox async {
    await HiveInitializer.initialize();
    return HiveInitializer.qrBox;
  }
  */

  /// Provee una instancia de [QRDataSource] como singleton.
  /**
  @lazySingleton
  QRDataSource provideQRDataSource(Box<QRModel> qrBox) {
    return QRDataSource(qrBox);
  }
   */

  /// Provee una instancia de [QRRepository] como singleton.
  /**
  @lazySingleton
  QRRepository provideQRRepository(QRDataSource qrDataSource) {
    return QRRepositoryImpl(qrDataSource);
  }
   */
}
