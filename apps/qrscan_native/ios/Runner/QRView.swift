//
//  QRView.swift
//
//  Created by Oscar Giraldo [Deadlock-oscargiraldo000] on 21/12/18.
//  update 28/02/25 by [Deadlock-oscargiraldo000]
//

import Foundation
import MTBBarcodeScanner

public class QRView: NSObject, FlutterPlatformView {
    // Vista de previsualización para la cámara.
    @IBOutlet var previewView: UIView!
    
    // Instancia del escáner de códigos QR.
    var scanner: MTBBarcodeScanner?
    
    // Registrar y canal de comunicación con Flutter.
    var registrar: FlutterPluginRegistrar
    var channel: FlutterMethodChannel
    
    // Cámara actual (frontal o trasera).
    var cameraFacing: MTBCamera
    
    // Mapeo de tipos de códigos QR soportados.
    // Nota: Algunos tipos no soportados se reemplazan con QR.
    var QRCodeTypes = [
        0: AVMetadataObject.ObjectType.aztec,
        1: AVMetadataObject.ObjectType.qr,
        2: AVMetadataObject.ObjectType.code39,
        3: AVMetadataObject.ObjectType.code93,
        4: AVMetadataObject.ObjectType.code128,
        5: AVMetadataObject.ObjectType.dataMatrix,
        6: AVMetadataObject.ObjectType.ean8,
        7: AVMetadataObject.ObjectType.ean13,
        8: AVMetadataObject.ObjectType.interleaved2of5,
        9: AVMetadataObject.ObjectType.qr,
        10: AVMetadataObject.ObjectType.pdf417,
        11: AVMetadataObject.ObjectType.qr,
        12: AVMetadataObject.ObjectType.qr,
        13: AVMetadataObject.ObjectType.qr,
        14: AVMetadataObject.ObjectType.ean13,
        15: AVMetadataObject.ObjectType.upce
    ]
    
    // Inicializador de la vista.
    public init(withFrame frame: CGRect, withRegistrar registrar: FlutterPluginRegistrar, withId id: Int64, params: Dictionary<String, Any>) {
        self.registrar = registrar
        self.previewView = UIView(frame: frame)
        
        // Configura la cámara frontal o trasera según los parámetros.
        self.cameraFacing = MTBCamera.init(rawValue: UInt(Int(params["cameraFacing"] as! Double))) ?? MTBCamera.back
        
        // Crea un canal de comunicación con Flutter.
        self.channel = FlutterMethodChannel(name: "com.oscargiraldo000.qrscannative/qrview_\(id)", binaryMessenger: registrar.messenger())
    }
    
    // Liberación de recursos.
    deinit {
        scanner?.stopScanning()
    }
    
    // Retorna la vista que se mostrará en Flutter.
    public func view() -> UIView {
        // Configura el manejador de llamadas desde Flutter.
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            
            switch call.method {
            case "setDimensions":
                let arguments = call.arguments as! Dictionary<String, Double>
                self.setDimensions(result,
                                   width: arguments["width"] ?? 0,
                                   height: arguments["height"] ?? 0,
                                   scanAreaWidth: arguments["scanAreaWidth"] ?? 0,
                                   scanAreaHeight: arguments["scanAreaHeight"] ?? 0,
                                   scanAreaOffset: arguments["scanAreaOffset"] ?? 0)
            case "startScan":
                self.startScan(call.arguments as! Array<Int>, result)
            case "flipCamera":
                self.flipCamera(result)
            case "toggleFlash":
                self.toggleFlash(result)
            case "pauseCamera":
                self.pauseCamera(result)
            case "stopCamera":
                self.stopCamera(result)
            case "resumeCamera":
                self.resumeCamera(result)
            case "getCameraInfo":
                self.getCameraInfo(result)
            case "getFlashInfo":
                self.getFlashInfo(result)
            case "getSystemFeatures":
                self.getSystemFeatures(result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        return previewView
    }
    
    // Configura las dimensiones de la vista y el área de escaneo.
    func setDimensions(_ result: @escaping FlutterResult, width: Double, height: Double, scanAreaWidth: Double, scanAreaHeight: Double, scanAreaOffset: Double) {
        previewView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let midX = previewView.bounds.midX
        let midY = previewView.bounds.midY
        
        if let scanner = scanner {
            // Actualiza el frame de la capa de previsualización.
            scanner.previewLayer?.frame = previewView.bounds
        } else {
            // Crea una nueva instancia del escáner.
            scanner = MTBBarcodeScanner(previewView: previewView)
        }
        
        // Configura el área de escaneo si se proporciona.
        if scanAreaWidth != 0 && scanAreaHeight != 0 {
            scanner?.didStartScanningBlock = {
                self.scanner?.scanRect = CGRect(x: Double(midX) - (scanAreaWidth / 2),
                                                y: Double(midY) - (scanAreaHeight / 2),
                                                width: scanAreaWidth,
                                                height: scanAreaHeight)
                
                // Aplica un offset si se proporciona.
                if scanAreaOffset != 0 {
                    self.scanner?.scanRect = self.scanner?.scanRect.offsetBy(dx: 0, dy: CGFloat(-scanAreaOffset)) ?? .zero
                }
            }
        }
        result(width)
    }
    
    // Inicia el escaneo de códigos QR.
    func startScan(_ arguments: Array<Int>, _ result: @escaping FlutterResult) {
        var allowedBarcodeTypes: [AVMetadataObject.ObjectType] = arguments.compactMap { QRCodeTypes[$0] }
        
        MTBBarcodeScanner.requestCameraPermission { [weak self] permissionGranted in
            guard let self = self else { return }
            
            self.channel.invokeMethod("onPermissionSet", arguments: permissionGranted)
            
            if permissionGranted {
                do {
                    try self.scanner?.startScanning(with: self.cameraFacing) { codes in
                        guard let codes = codes else { return }
                        
                        for code in codes {
                            guard let typeString = self.getBarcodeTypeString(code.type),
                                  let resultData = self.getBarcodeResult(code) else { continue }
                            
                            if allowedBarcodeTypes.isEmpty || allowedBarcodeTypes.contains(code.type) {
                                self.channel.invokeMethod("onRecognizeQR", arguments: resultData)
                            }
                        }
                    }
                } catch {
                    result(FlutterError(code: "unknown-error", message: "Unable to start scanning", details: error.localizedDescription))
                }
            }
        }
    }
    
    // Detiene la cámara.
    func stopCamera(_ result: @escaping FlutterResult) {
        scanner?.stopScanning()
        result(nil)
    }
    
    // Obtiene información de la cámara actual.
    func getCameraInfo(_ result: @escaping FlutterResult) {
        result(cameraFacing.rawValue)
    }
    
    // Cambia entre la cámara frontal y trasera.
    func flipCamera(_ result: @escaping FlutterResult) {
        guard let scanner = scanner else {
            return result(FlutterError(code: "404", message: "No barcode scanner found", details: nil))
        }
        
        if scanner.hasOppositeCamera() {
            scanner.flipCamera()
            self.cameraFacing = scanner.camera
        }
        result(scanner.camera.rawValue)
    }
    
    // Obtiene información sobre el flash.
    func getFlashInfo(_ result: @escaping FlutterResult) {
        guard let scanner = scanner else {
            return result(FlutterError(code: "404", message: "No barcode scanner found", details: nil))
        }
        result(scanner.torchMode.rawValue != 0)
    }
    
    // Activa o desactiva el flash.
    func toggleFlash(_ result: @escaping FlutterResult) {
        guard let scanner = scanner else {
            return result(FlutterError(code: "404", message: "No barcode scanner found", details: nil))
        }
        
        if scanner.hasTorch() {
            scanner.toggleTorch()
            result(scanner.torchMode == .on)
        } else {
            result(FlutterError(code: "404", message: "This device doesn't support flash", details: nil))
        }
    }
    
    // Pausa la cámara.
    func pauseCamera(_ result: @escaping FlutterResult) {
        scanner?.freezeCapture()
        result(true)
    }
    
    // Reanuda la cámara.
    func resumeCamera(_ result: @escaping FlutterResult) {
        scanner?.unfreezeCapture()
        result(true)
    }
    
    // Obtiene las características del sistema (cámaras y flash).
    func getSystemFeatures(_ result: @escaping FlutterResult) {
        guard let scanner = scanner else {
            return result(FlutterError(code: "404", message: "No barcode scanner found", details: nil))
        }
        
        let hasBackCamera = scanner.camera == .back || scanner.hasOppositeCamera()
        let hasFrontCamera = scanner.camera == .front || scanner.hasOppositeCamera()
        
        result([
            "hasFrontCamera": hasFrontCamera,
            "hasBackCamera": hasBackCamera,
            "hasFlash": scanner.hasTorch(),
            "activeCamera": scanner.camera.rawValue
        ])
    }
    
    // Método auxiliar para obtener el tipo de código QR como cadena.
    private func getBarcodeTypeString(_ type: AVMetadataObject.ObjectType) -> String? {
        switch type {
        case .aztec: return "AZTEC"
        case .code39: return "CODE_39"
        case .code93: return "CODE_93"
        case .code128: return "CODE_128"
        case .dataMatrix: return "DATA_MATRIX"
        case .ean8: return "EAN_8"
        case .ean13: return "EAN_13"
        case .interleaved2of5: return "ITF"
        case .pdf417: return "PDF_417"
        case .qr: return "QR_CODE"
        case .upce: return "UPC_E"
        default: return nil
        }
    }
    
    // Método auxiliar para obtener el resultado del código QR.
    private func getBarcodeResult(_ code: AVMetadataMachineReadableCodeObject) -> [String: Any]? {
        guard let typeString = getBarcodeTypeString(code.type) else { return nil }
        
        let bytes: Data? = {
            if #available(iOS 11.0, *), let descriptor = code.descriptor {
                switch descriptor {
                case let qrDescriptor as CIQRCodeDescriptor:
                    return qrDescriptor.errorCorrectedPayload
                case let aztecDescriptor as CIAztecCodeDescriptor:
                    return aztecDescriptor.errorCorrectedPayload
                case let pdf417Descriptor as CIPDF417CodeDescriptor:
                    return pdf417Descriptor.errorCorrectedPayload
                case let dataMatrixDescriptor as CIDataMatrixCodeDescriptor:
                    return dataMatrixDescriptor.errorCorrectedPayload
                default:
                    return nil
                }
            }
            return nil
        }()
        
        if let stringValue = code.stringValue {
            return ["code": stringValue, "type": typeString, "rawBytes": bytes ?? Data()]
        } else if let bytes = bytes {
            return ["type": typeString, "rawBytes": bytes]
        }
        return nil
    }
}
