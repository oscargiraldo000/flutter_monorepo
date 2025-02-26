// Autogenerated from Pigeon (v24.2.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

/// Error class for passing custom error details to Dart side.
final class PigeonError: Error {
  let code: String
  let message: String?
  let details: Sendable?

  init(code: String, message: String?, details: Sendable?) {
    self.code = code
    self.message = message
    self.details = details
  }

  var localizedDescription: String {
    return
      "PigeonError(code: \(code), message: \(message ?? "<nil>"), details: \(details ?? "<nil>")"
      }
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let pigeonError = error as? PigeonError {
    return [
      pigeonError.code,
      pigeonError.message,
      pigeonError.details,
    ]
  }
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func createConnectionError(withChannelName channelName: String) -> PigeonError {
  return PigeonError(code: "channel-error", message: "Unable to establish connection on channel: '\(channelName)'.", details: "")
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

private class PigeonApiPigeonCodecReader: FlutterStandardReader {
}

private class PigeonApiPigeonCodecWriter: FlutterStandardWriter {
}

private class PigeonApiPigeonCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return PigeonApiPigeonCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return PigeonApiPigeonCodecWriter(data: data)
  }
}

class PigeonApiPigeonCodec: FlutterStandardMessageCodec, @unchecked Sendable {
  static let shared = PigeonApiPigeonCodec(readerWriter: PigeonApiPigeonCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol QrScannerApi {
  func startQrScanner() throws
  func stopQrScanner() throws
  func getScannedResult() throws -> String
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class QrScannerApiSetup {
  static var codec: FlutterStandardMessageCodec { PigeonApiPigeonCodec.shared }
  /// Sets up an instance of `QrScannerApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: QrScannerApi?, messageChannelSuffix: String = "") {
    let channelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
    let startQrScannerChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.com.oscargiraldo000.qrscannative.QrScannerApi.startQrScanner\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      startQrScannerChannel.setMessageHandler { _, reply in
        do {
          try api.startQrScanner()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      startQrScannerChannel.setMessageHandler(nil)
    }
    let stopQrScannerChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.com.oscargiraldo000.qrscannative.QrScannerApi.stopQrScanner\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      stopQrScannerChannel.setMessageHandler { _, reply in
        do {
          try api.stopQrScanner()
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      stopQrScannerChannel.setMessageHandler(nil)
    }
    let getScannedResultChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.com.oscargiraldo000.qrscannative.QrScannerApi.getScannedResult\(channelSuffix)", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getScannedResultChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getScannedResult()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getScannedResultChannel.setMessageHandler(nil)
    }
  }
}
/// Generated protocol from Pigeon that represents Flutter messages that can be called from Swift.
protocol QRScanCallbackProtocol {
  func onQRCodeScanned(qrCode qrCodeArg: String, completion: @escaping (Result<Void, PigeonError>) -> Void)
}
class QRScanCallback: QRScanCallbackProtocol {
  private let binaryMessenger: FlutterBinaryMessenger
  private let messageChannelSuffix: String
  init(binaryMessenger: FlutterBinaryMessenger, messageChannelSuffix: String = "") {
    self.binaryMessenger = binaryMessenger
    self.messageChannelSuffix = messageChannelSuffix.count > 0 ? ".\(messageChannelSuffix)" : ""
  }
  var codec: PigeonApiPigeonCodec {
    return PigeonApiPigeonCodec.shared
  }
  func onQRCodeScanned(qrCode qrCodeArg: String, completion: @escaping (Result<Void, PigeonError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.com.oscargiraldo000.qrscannative.QRScanCallback.onQRCodeScanned\(messageChannelSuffix)"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger, codec: codec)
    channel.sendMessage([qrCodeArg] as [Any?]) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(PigeonError(code: code, message: message, details: details)))
      } else {
        completion(.success(()))
      }
    }
  }
}
