package com.oscargiraldo000.qrscannative

import android.content.Context
import android.graphics.Rect
import android.util.AttributeSet
import com.journeyapps.barcodescanner.BarcodeView
import com.journeyapps.barcodescanner.Size

class CustomFramingRectBarcodeView(context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0) : BarcodeView(context, attrs, defStyleAttr) {
    private var bottomOffset = BOTTOM_OFFSET_NOT_SET_VALUE

    override fun calculateFramingRect(container: Rect, surface: Rect): Rect {
        val containerArea = Rect(container)
        val intersects =
            containerArea.intersect(surface) //adjusts the containerArea (code from super.calculateFramingRect)
        val scanAreaRect = super.calculateFramingRect(container, surface)
        if (bottomOffset != BOTTOM_OFFSET_NOT_SET_VALUE) { //if the setFramingRect function was called, then we shift the scan area by Y
            val scanAreaRectWithOffset = Rect(scanAreaRect)
            scanAreaRectWithOffset.bottom -= bottomOffset
            scanAreaRectWithOffset.top -= bottomOffset
            val belongsToContainer = scanAreaRectWithOffset.intersect(containerArea)
            if (belongsToContainer) {
                return scanAreaRectWithOffset
            }
        }
        return scanAreaRect
    }

    fun setFramingRect(rectWidth: Int, rectHeight: Int, bottomOffset: Int) {
        this.bottomOffset = bottomOffset
        framingRectSize = Size(rectWidth, rectHeight)
    }

    companion object {
        private const val BOTTOM_OFFSET_NOT_SET_VALUE = -1
    }
}