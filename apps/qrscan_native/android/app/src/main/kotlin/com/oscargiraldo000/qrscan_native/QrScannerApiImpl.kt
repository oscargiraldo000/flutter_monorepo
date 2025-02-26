package com.oscargiraldo000.qrscannative

import android.app.Activity
import android.content.Intent
import android.util.Log
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import com.oscargiraldo000.qrscannative.PigeonApi.QrScannerApi

class QrScannerApiImpl : QrScannerApi {
    private var scannedResult: String = ""
    private lateinit var qrScannerLauncher: ActivityResultLauncher<Intent>

    init {
        setUpQrScannerLauncher()
    }

    private fun setUpQrScannerLauncher() {
        qrScannerLauncher = MainActivity().registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result: ActivityResult ->
            handleActivityResult(result)
        }
    }

    private fun handleActivityResult(result: ActivityResult) {
        if (result.resultCode == Activity.RESULT_OK) {
            scannedResult = result.data?.getStringExtra("QR_RESULT") ?: ""
            Log.d("QrScanner", "Código QR escaneado: $scannedResult")
        } else {
            Log.d("QrScanner", "Escaneo cancelado")
        }
    }

    override fun startQrScanner() {
        val intent = Intent(MainActivity(), QrScannerActivity::class.java)
        qrScannerLauncher.launch(intent)
    }

    override fun stopQrScanner() {
        // No es necesario en ZXing
    }

    override fun getScannedResult(): String {
        return scannedResult
    }
}