Pod::Spec.new do |s|
  s.name             = 'qrscan_native'  # Nombre del plugin.
  s.version          = '1.0.0'          # Versión del plugin.
  s.summary          = 'Un complemento de Flutter para escanear códigos QR de forma nativa.'  # Descripción corta.
  s.description      = <<-DESC
  Un complemento de Flutter que proporciona una funcionalidad nativa de escaneo de códigos QR.
                       DESC
  s.homepage         = 'https://github.com/oscargiraldo000/flutter_monorepo/tree/qrscan-feature/qr_scan/apps/qrscan_native/ios'  # URL de la página del plugin.
  s.license          = { :file => '../LICENSE' }  # Archivo de licencia.
  s.author           = { 'Oscar Giraldo' => 'oscargiraldo000@gmail.com' }  # Autor y correo.
  s.source           = { :path => '.' }  # Ruta del código fuente.
  s.source_files = 'Classes/**/*'  # Archivos fuente del plugin.
  s.dependency 'Flutter'  # Dependencia de Flutter.
  s.platform = :ios, '14.0'  # Versión mínima de iOS soportada.
  s.swift_version = '5.0'  # Versión de Swift.
end