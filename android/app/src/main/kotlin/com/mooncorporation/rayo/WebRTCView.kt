package com.mooncorporation.rayo

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import org.webrtc.EglBase
import org.webrtc.SurfaceViewRenderer
import org.webrtc.VideoFrame
import org.webrtc.VideoSink

class WebRTCViewFactory(
    private val webRTCClient: WebRTCClient
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return WebRTCView(context, viewId, args, webRTCClient)
    }
}

class WebRTCView(
    context: Context,
    viewId: Int,
    args: Any?,
    private val webRTCClient: WebRTCClient
) : PlatformView {
    val containerView: FrameLayout = FrameLayout(context)
    private val eglBase: EglBase = EglBase.create()

    init {
        val userKey = args as? Int
//        if (userKey == webRTCClient.userKey) {
        if (userKey == 205) {
            setupLocalVideoView()
        } else {
            setupRemoteVideoView(userKey!!)
        }
    }

    private fun setupLocalVideoView() {
        val videoView = SurfaceViewRenderer(containerView.context)
        videoView.init(eglBase.eglBaseContext, null)
        videoView.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        Log.d("WebRTCView", "Initializing local video view")
        val localVideoTrack = webRTCClient.localStream?.videoTracks?.firstOrNull()
        if (localVideoTrack != null) {
            val videoSink = object : VideoSink {
                override fun onFrame(frame: VideoFrame) {
                    Log.d("WebRTCView", "Received video frame: ${frame.rotatedWidth}x${frame.rotatedHeight}")
                    videoView.onFrame(frame)
                }
            }
            localVideoTrack.addSink(videoSink)
        } else {
            Log.e("WebRTCView", "Local video track not found")
        }
        containerView.addView(videoView)

    }

    private fun setupRemoteVideoView(userKey: Int) {
        val videoView = SurfaceViewRenderer(containerView.context)
        videoView.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        webRTCClient.remoteStream[userKey]?.addSink(videoView)
        containerView.addView(videoView)
        webRTCClient.remoteView[userKey] = this
    }

    override fun getView(): View {
        return containerView
    }

    override fun dispose() {
        // 리소스 해제 코드
    }
}