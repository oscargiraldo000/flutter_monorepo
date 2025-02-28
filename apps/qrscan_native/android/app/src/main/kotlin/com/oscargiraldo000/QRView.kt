package com.oscargiraldo000.qrscannative

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.view.View
import androidx.core.content.ContextCompat
import com.google.zxing.BarcodeFormat
import com.google.zxing.ResultPoint
import com.journeyapps.barcodescanner.BarcodeCallback
import com.journeyapps.barcodescanner.BarcodeResult
import com.journeyapps.barcodescanner.DefaultDecoderFactory
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView

/**
 * Clase que representa una vista personalizada para escanear códigos QR.
 * Implementa [PlatformView], [MethodChannel.MethodCallHandler] y [PluginRegistry.RequestPermissionsResultListener]
 * para manejar la vista, la comunicación con Flutter y los permisos de la cámara respectivamente.
 */
class QRView(
    private val context: Context,
    messenger: BinaryMessenger,
    private val id: Int,
    private val params: HashMap<String, Any>?
) : PlatformView, MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

    // Código de solicitud de permisos de la cámara
    private val cameraRequestCode = QrShared.CAMERA_REQUEST_ID + this.id

    // Canal de comunicación con Flutter
    private val channel: MethodChannel = MethodChannel(
        messenger, "com.oscargiraldo000.qrscannative/qrview_$id"
    )

    // Constantes para la cámara frontal y trasera
    private val cameraFacingBack = 0
    private val cameraFacingFront = 1

    // Variables de estado
    private var isRequestingPermission = false
    private var isTorchOn = false
    private var isPaused = false
    private var barcodeView: CustomFramingRectBarcodeView? = null
    private var unRegisterLifecycleCallback: UnRegisterLifecycleCallback? = null

    // Inicialización de la vista
    init {
        QrShared.binding?.addRequestPermissionsResultListener(this)

        // Configura el manejador de llamadas del canal
        channel.setMethodCallHandler(this)

        // Registra los callbacks del ciclo de vida de la actividad
        unRegisterLifecycleCallback = QrShared.activity?.registerLifecycleCallbacks(
            onPause = {
                if (!isPaused && hasCameraPermission) barcodeView?.pause()
            },
            onResume = {
                if (!hasCameraPermission && !isRequestingPermission) checkAndRequestPermission()
                else if (!isPaused && hasCameraPermission) barcodeView?.resume()
            }
        )
    }

    // Libera los recursos cuando la vista es destruida
    override fun dispose() {
        unRegisterLifecycleCallback?.invoke()
        QrShared.binding?.removeRequestPermissionsResultListener(this)
        barcodeView?.pause()
        barcodeView = null
    }

    // Devuelve la vista que se mostrará en la plataforma
    override fun getView(): View = initBarCodeView()

    // Maneja las llamadas desde Flutter
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        @Suppress("UNCHECKED_CAST")
        when (call.method) {
            "startScan" -> startScan(call.arguments as? List<Int>, result)
            "stopScan" -> stopScan()
            "flipCamera" -> flipCamera(result)
            "toggleFlash" -> toggleFlash(result)
            "pauseCamera" -> pauseCamera(result)
            "stopCamera" -> pauseCamera(result) // Detener la cámara es lo mismo que pausarla
            "resumeCamera" -> resumeCamera(result)
            "requestPermissions" -> checkAndRequestPermission()
            "getCameraInfo" -> getCameraInfo(result)
            "getFlashInfo" -> getFlashInfo(result)
            "getSystemFeatures" -> getSystemFeatures(result)
            "changeScanArea" -> changeScanArea(
                dpScanAreaWidth = requireNotNull(call.argument<Double>("scanAreaWidth")),
                dpScanAreaHeight = requireNotNull(call.argument<Double>("scanAreaHeight")),
                cutOutBottomOffset = requireNotNull(call.argument<Double>("cutOutBottomOffset")),
                result = result,
            )
            "invertScan" -> setInvertScan(
                isInvert = call.argument<Boolean>("isInvertScan") ?: false,
            )
            else -> result.notImplemented()
        }
    }

    // Inicializa la vista de escaneo de códigos de barras
    private fun initBarCodeView(): CustomFramingRectBarcodeView {
        var barcodeView = barcodeView

        if (barcodeView == null) {
            barcodeView = CustomFramingRectBarcodeView(context).also {
                this.barcodeView = it
            }

            barcodeView.decoderFactory = DefaultDecoderFactory(null, null, null, 2)

            // Configura la cámara frontal o trasera según los parámetros
            if (params?.get(PARAMS_CAMERA_FACING) as Int == 1) {
                barcodeView.cameraSettings?.requestedCameraId = cameraFacingFront
            }
        } else if (!isPaused) {
            barcodeView.resume()
        }

        return barcodeView
    }

    // Obtiene información sobre la cámara actual
    private fun getCameraInfo(result: MethodChannel.Result) {
        val barcodeView = barcodeView ?: return barCodeViewNotSet(result)
        result.success(barcodeView.cameraSettings.requestedCameraId)
    }

    // Obtiene información sobre el estado del flash
    private fun getFlashInfo(result: MethodChannel.Result) {
        if (barcodeView == null) return barCodeViewNotSet(result)
        result.success(isTorchOn)
    }

    // Verifica si el dispositivo tiene flash
    private fun hasFlash(): Boolean {
        return hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)
    }

    // Verifica si el dispositivo tiene cámara trasera
    @SuppressLint("UnsupportedChromeOsCameraSystemFeature")
    private fun hasBackCamera(): Boolean {
        return hasSystemFeature(PackageManager.FEATURE_CAMERA)
    }

    // Verifica si el dispositivo tiene cámara frontal
    private fun hasFrontCamera(): Boolean {
        return hasSystemFeature(PackageManager.FEATURE_CAMERA_FRONT)
    }

    // Verifica si el dispositivo tiene una característica específica
    private fun hasSystemFeature(feature: String): Boolean =
        context.packageManager.hasSystemFeature(feature)

    // Obtiene las características del sistema relacionadas con la cámara
    private fun getSystemFeatures(result: MethodChannel.Result) {
        try {
            result.success(
                mapOf(
                    "hasFrontCamera" to hasFrontCamera(),
                    "hasBackCamera" to hasBackCamera(),
                    "hasFlash" to hasFlash(),
                    "activeCamera" to barcodeView?.cameraSettings?.requestedCameraId
                )
            )
        } catch (e: Exception) {
            result.error("", e.message, null)
        }
    }

    // Cambia la cámara entre frontal y trasera
    private fun flipCamera(result: MethodChannel.Result) {
        val barcodeView = barcodeView ?: return barCodeViewNotSet(result)

        barcodeView.pause()

        val settings = barcodeView.cameraSettings
        if (settings.requestedCameraId == cameraFacingFront) {
            settings.requestedCameraId = cameraFacingBack
        } else settings.requestedCameraId = cameraFacingFront

        barcodeView.resume()

        result.success(settings.requestedCameraId)
    }

    // Alterna el estado del flash
    private fun toggleFlash(result: MethodChannel.Result) {
        val barcodeView = barcodeView ?: return barCodeViewNotSet(result)

        if (hasFlash()) {
            barcodeView.setTorch(!isTorchOn)
            isTorchOn = !isTorchOn
            result.success(isTorchOn)
        } else {
            result.error(ERROR_CODE_NOT_SET, ERROR_MESSAGE_FLASH_NOT_FOUND, null)
        }
    }

    // Pausa la cámara
    private fun pauseCamera(result: MethodChannel.Result) {
        val barcodeView = barcodeView ?: return barCodeViewNotSet(result)

        if (barcodeView.isPreviewActive) {
            isPaused = true
            barcodeView.pause()
        }

        result.success(true)
    }

    // Reanuda la cámara
    private fun resumeCamera(result: MethodChannel.Result) {
        val barcodeView = barcodeView ?: return barCodeViewNotSet(result)

        if (!barcodeView.isPreviewActive) {
            isPaused = false
            barcodeView.resume()
        }

        result.success(true)
    }

    // Inicia el escaneo de códigos QR
    private fun startScan(arguments: List<Int>?, result: MethodChannel.Result) {
        checkAndRequestPermission()

        val allowedBarcodeTypes = getAllowedBarcodeTypes(arguments, result)

        if (arguments == null) {
            barcodeView?.decoderFactory = DefaultDecoderFactory(null, null, null, 2)
        } else {
            barcodeView?.decoderFactory = DefaultDecoderFactory(allowedBarcodeTypes, null, null, 2)
        }

        barcodeView?.decodeContinuous(
            object : BarcodeCallback {
                override fun barcodeResult(result: BarcodeResult) {
                    if (allowedBarcodeTypes.isEmpty() || allowedBarcodeTypes.contains(result.barcodeFormat)) {
                        val code = mapOf(
                            "code" to result.text,
                            "type" to result.barcodeFormat.name,
                            "rawBytes" to result.rawBytes
                        )

                        channel.invokeMethod(CHANNEL_METHOD_ON_RECOGNIZE_QR, code)
                    }
                }

                override fun possibleResultPoints(resultPoints: List<ResultPoint>) = Unit
            }
        )
    }

    // Detiene el escaneo de códigos QR
    private fun stopScan() {
        barcodeView?.stopDecoding()
    }

    // Invierte el escaneo
    private fun setInvertScan(isInvert: Boolean) {
        val barcodeView = barcodeView ?: return
        with(barcodeView) {
            pause()
            cameraSettings.isScanInverted = isInvert
            resume()
        }
    }

    // Cambia el área de escaneo
    private fun changeScanArea(
        dpScanAreaWidth: Double,
        dpScanAreaHeight: Double,
        cutOutBottomOffset: Double,
        result: MethodChannel.Result
    ) {
        setScanAreaSize(dpScanAreaWidth, dpScanAreaHeight, cutOutBottomOffset)
        result.success(true)
    }

    // Establece el tamaño del área de escaneo
    private fun setScanAreaSize(
        dpScanAreaWidth: Double,
        dpScanAreaHeight: Double,
        dpCutOutBottomOffset: Double
    ) {
        barcodeView?.setFramingRect(
            dpScanAreaWidth.convertDpToPixels(),
            dpScanAreaHeight.convertDpToPixels(),
            dpCutOutBottomOffset.convertDpToPixels(),
        )
    }

    // Verifica si se tienen permisos de cámara
    private val hasCameraPermission: Boolean
        get() = Build.VERSION.SDK_INT < Build.VERSION_CODES.M ||
                ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.CAMERA
                ) == PackageManager.PERMISSION_GRANTED

    // Maneja el resultado de la solicitud de permisos
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode != cameraRequestCode) return false
        isRequestingPermission = false

        val permissionGranted =
            grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED

        channel.invokeMethod(CHANNEL_METHOD_ON_PERMISSION_SET, permissionGranted)

        return permissionGranted
    }

    // Verifica y solicita permisos de cámara
    private fun checkAndRequestPermission() {
        if (hasCameraPermission) {
            channel.invokeMethod(CHANNEL_METHOD_ON_PERMISSION_SET, true)
            return
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !isRequestingPermission) {
            QrShared.activity?.requestPermissions(
                arrayOf(Manifest.permission.CAMERA),
                cameraRequestCode
            )
        }
    }

    // Obtiene los formatos de códigos de barras permitidos
    private fun getAllowedBarcodeTypes(
        arguments: List<Int>?,
        result: MethodChannel.Result
    ): List<BarcodeFormat> {
        return try {
            arguments?.map {
                BarcodeFormat.values()[it]
            }.orEmpty()
        } catch (e: Exception) {
            result.error("", e.message, null)
            emptyList()
        }
    }

    // Maneja el error cuando no se ha configurado la vista de códigos de barras
    private fun barCodeViewNotSet(result: MethodChannel.Result) {
        result.error(
            ERROR_CODE_NOT_SET,
            ERROR_MESSAGE_NOT_SET,
            null
        )
    }

    // Convierte dp a píxeles
    private fun Double.convertDpToPixels() =
        (this * context.resources.displayMetrics.density).toInt()

    companion object {
        private const val CHANNEL_METHOD_ON_PERMISSION_SET = "onPermissionSet"
        private const val CHANNEL_METHOD_ON_RECOGNIZE_QR = "onRecognizeQR"

        private const val PARAMS_CAMERA_FACING = "cameraFacing"

        private const val ERROR_CODE_NOT_SET = "404"

        private const val ERROR_MESSAGE_NOT_SET = "No barcode view found"
        private const val ERROR_MESSAGE_FLASH_NOT_FOUND = "This device doesn't support flash"
    }
}