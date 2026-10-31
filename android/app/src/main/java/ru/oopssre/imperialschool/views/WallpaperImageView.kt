package ru.oopssre.imperialschool.views

import android.content.Context
import android.graphics.Matrix
import android.graphics.drawable.Drawable
import android.view.GestureDetector
import android.view.MotionEvent
import android.view.ScaleGestureDetector
import android.widget.ImageView
import kotlin.math.abs
import kotlin.math.max
import kotlin.math.min

/** Holds one sampled bitmap. Dragging while zoomed never changes the selected frame. */
internal class WallpaperImageView(context: Context): ImageView(context) {
    var onStep: (Int)->Unit={}
    var onTap: ()->Unit={}
    private var zoom=1f
    private var offsetX=0f
    private var offsetY=0f
    private var startX=0f
    private var startY=0f
    private var moved=false
    private var pinched=false
    private var lastX=0f
    private var lastY=0f
    private val scale=ScaleGestureDetector(context,object: ScaleGestureDetector.SimpleOnScaleGestureListener(){
        override fun onScale(detector: ScaleGestureDetector): Boolean {
            zoomAt((zoom*detector.scaleFactor).coerceIn(1f,6f),detector.focusX,detector.focusY);return true
        }
    })
    private val gestures=GestureDetector(context,object: GestureDetector.SimpleOnGestureListener(){
        override fun onDown(e: MotionEvent)=true
        override fun onSingleTapConfirmed(e: MotionEvent): Boolean {performClick();return true}
        override fun onDoubleTap(e: MotionEvent): Boolean {zoomAt(if(zoom>1f)1f else 2.5f,e.x,e.y);return true}
    })
    init {scaleType=ScaleType.MATRIX;isClickable=true;isFocusable=true;contentDescription="Обои. Два касания — увеличить. Свайп — следующий кадр. Нажатие — полный экран."}
    override fun performClick(): Boolean {super.performClick();onTap();return true}
    override fun setImageDrawable(drawable: Drawable?) {super.setImageDrawable(drawable);resetZoom()}
    fun resetZoom(){zoom=1f;offsetX=0f;offsetY=0f;transform()}
    internal fun zoomLevel()=zoom
    private fun zoomAt(next: Float,x: Float,y: Float){
        val ratio=next/zoom
        offsetX=(offsetX-(x-width/2f))*ratio+(x-width/2f)
        offsetY=(offsetY-(y-height/2f))*ratio+(y-height/2f)
        zoom=next;transform()
    }
    private fun transform(){
        val d=drawable ?: return
        if(width<=0 || height<=0 || d.intrinsicWidth<=0 || d.intrinsicHeight<=0)return
        val fit=min(width.toFloat()/d.intrinsicWidth,height.toFloat()/d.intrinsicHeight)
        val w=d.intrinsicWidth*fit*zoom;val h=d.intrinsicHeight*fit*zoom
        val maxX=max(0f,(w-width)/2f);val maxY=max(0f,(h-height)/2f)
        offsetX=offsetX.coerceIn(-maxX,maxX);offsetY=offsetY.coerceIn(-maxY,maxY)
        imageMatrix=Matrix().apply{setScale(fit*zoom,fit*zoom);postTranslate((width-w)/2f+offsetX,(height-h)/2f+offsetY)}
    }
    override fun onSizeChanged(w: Int,h: Int,oldw: Int,oldh: Int){super.onSizeChanged(w,h,oldw,oldh);transform()}
    override fun onTouchEvent(event: MotionEvent): Boolean {
        if(event.actionMasked==MotionEvent.ACTION_DOWN){startX=event.x;startY=event.y;lastX=event.x;lastY=event.y;pinched=false;moved=false}
        if(event.pointerCount>1)pinched=true
        scale.onTouchEvent(event);gestures.onTouchEvent(event)
        if(event.actionMasked==MotionEvent.ACTION_MOVE && !scale.isInProgress && event.pointerCount==1){
            if(zoom>1f){offsetX+=event.x-lastX;offsetY+=event.y-lastY;transform()}
            moved=moved || abs(event.x-startX)>12*resources.displayMetrics.density || abs(event.y-startY)>12*resources.displayMetrics.density
        }
        if(event.actionMasked==MotionEvent.ACTION_UP && moved && !pinched && zoom<=1f){
            val dx=event.x-startX;val dy=event.y-startY
            if(abs(dx)>60*resources.displayMetrics.density && abs(dx)>abs(dy)*1.5f)onStep(if(dx<0)1 else -1)
        }
        lastX=event.x;lastY=event.y;return true
    }
}
