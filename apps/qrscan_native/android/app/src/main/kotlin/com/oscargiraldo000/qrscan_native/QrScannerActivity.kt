package com.oscargiraldo000.qrscannative

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.journeyapps.barcodescanner.CaptureActivity
import com.journeyapps.barcodescanner.IntentIntegrator
import com.journeyapps.barcodescanner.IntentResult

class QrScannerActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        startQrScanner()
    }

    private fun startQrScanner() {
        IntentIntegrator(this).apply {
            setDesiredBarcodeFormats(IntentIntegrator.QR_CODE)
            setPrompt("Escanea un código QR")
            setCameraId(0) // Usa la cámara trasera
            setBeepEnabled(true)
            setOrientationLocked(false)
            setCaptureActivity(CaptureActivity::class.java)
            initiateScan()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val result: IntentResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, data)
        if (result.contents != null) {
            QrScannerApiImpl.scannedResult = result.contents
        }
        setResult(Activity.RESULT_OK, Intent().putExtra("QR_RESULT", result.contents))
        finish()
    }
}
