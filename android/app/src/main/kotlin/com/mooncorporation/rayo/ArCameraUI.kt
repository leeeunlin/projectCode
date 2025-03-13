package com.mooncorporation.rayo

import android.app.Activity
import android.content.Context
import android.graphics.Bitmap
import android.media.AudioManager
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.Choreographer
import android.view.PixelCopy
import android.view.View
import com.google.ar.core.ArCoreApk
import com.google.ar.core.CameraConfig
import com.google.ar.core.CameraConfigFilter
import com.google.ar.core.Config
import com.google.ar.core.Session
import com.google.ar.sceneform.ArSceneView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import org.webrtc.AudioTrack
import org.webrtc.EglBase
import org.webrtc.JavaI420Buffer
import org.webrtc.MediaConstraints
import org.webrtc.MediaStream
import org.webrtc.PeerConnectionFactory
import org.webrtc.RendererCommon
import org.webrtc.SurfaceViewRenderer
import org.webrtc.VideoFrame
import org.webrtc.VideoSource
import org.webrtc.VideoTrack
import java.nio.ByteBuffer
import java.nio.ByteOrder

class ArCameraFactory(
    private val webRTCClient: WebRTCClient,
    private val creationParams: Map<String, Any>?,
    private val mainActivity: MainActivity,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d("NTLOG", "ArCameraView 생성준비")
        return ArCameraView(context, webRTCClient, creationParams, mainActivity)
    }
}

class ArCameraView(
    private val context: Context,
    private val webRTCClient: WebRTCClient,
    private val creationParams: Map<String, Any>?,
    private val mainActivity: MainActivity
) : PlatformView {
    private lateinit var arSession: Session // arSession
    private lateinit var sceneView: ArSceneView // arScreen (메인화면)
    private lateinit var localVideoTrack: VideoTrack // 연결될 경우 상대방에게 전송되는 트랙
    private lateinit var localAudioTrack: AudioTrack // 연결될 경우 상대방에게 전송되는 트랙
    private lateinit var localStream: MediaStream // 내 화면에 보여줄 stream (화면전환 시 사용됨)
    private lateinit var videoView: SurfaceViewRenderer //?? 이게뭐지
    private lateinit var videoSource: VideoSource
    private lateinit var choreographer: Choreographer
    private lateinit var frameCallback: Choreographer.FrameCallback
    private var isArCoreInstalled = false

    init {
        this.mainActivity.arCameraView = this
        Log.d("ArCameraView", "ARCore init")
        if (checkArCoreAvailability()) {
            setupAudioSession()
            setupARSession()
            setupWebRTC()
            setupVideoView()
            setupRenderer()
            startRenderingLoop()
            setupAppStateObservers()
        } else {
            Log.d("NTLOG", "ARCore 지원하지않는기기")
        }
    }

    // ANDROID ARCore 설치유무 판단코드
    private fun checkArCoreAvailability(): Boolean {
        Log.d("ArCameraView", "ARCore 설치여부확인중")
        val availability = ArCoreApk.getInstance().checkAvailability(context)
        return when (availability) {
            ArCoreApk.Availability.SUPPORTED_INSTALLED -> {
                Log.d("ArCameraView", "ARCore 설치확인")
                isArCoreInstalled = true
                true
            }

            ArCoreApk.Availability.SUPPORTED_APK_TOO_OLD,
            ArCoreApk.Availability.SUPPORTED_NOT_INSTALLED -> {
                if (context is Activity) {
                    try {
                        val installStatus = ArCoreApk.getInstance().requestInstall(context, true)
                        if (installStatus == ArCoreApk.InstallStatus.INSTALL_REQUESTED) {
                            Log.d("ArCameraView", "ARCore 설치 요청")
                            return false
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                        Log.d("NTLOG", "ARCore 설치에러", e)
                    }
                } else {
                    Log.d("NTLOG", "Context가 Activity가 아님")
                }
                false
            }

            ArCoreApk.Availability.UNSUPPORTED_DEVICE_NOT_CAPABLE -> {
                Log.d("NTLOG", "ARCore 지원 불가능 기기")
                false
            }

            else -> false
        }
    }

    // PlatformView 인터페이스 구현 - View 반환
    override fun getView(): View {
        return this.sceneView
    }

    // 오디오 세션 설정
    private fun setupAudioSession() {
        val audioSession = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        try {
            audioSession.mode = AudioManager.MODE_IN_COMMUNICATION
            audioSession.isSpeakerphoneOn = true
            audioSession.setBluetoothScoOn(true)
            audioSession.startBluetoothSco()
        } catch (e: Exception) {
            Log.d("NTLOG", "Error setting up audio session: ${e.message}")
        }
    }

    // AR 세션 설정
    private fun setupARSession() {
        this.arSession = Session(context)
        val config = Config(arSession)
        config.updateMode = Config.UpdateMode.LATEST_CAMERA_IMAGE
        config.augmentedFaceMode = Config.AugmentedFaceMode.MESH3D

        val filter = CameraConfigFilter(this.arSession)
        filter.setFacingDirection(CameraConfig.FacingDirection.FRONT)
        val cameraConfigList = this.arSession.getSupportedCameraConfigs(filter)
        if (cameraConfigList.isNotEmpty()) {
            this.arSession.cameraConfig = cameraConfigList[0]
        } else {
            throw UnsupportedOperationException("전면 카메라를 사용할 수 없습니다.")
        }
        this.arSession.configure(config)
        this.arSession.resume()

        this.sceneView = ArSceneView(context)
        this.sceneView.setupSession(arSession)
//        this.sceneView.resume()
//        createFaceBox()
    }

    // WebRTC 설정
    private fun setupWebRTC() {
        Log.d("ArCameraView", "Setting up WebRTC")
        PeerConnectionFactory.initialize(
            PeerConnectionFactory.InitializationOptions.builder(context)
                .createInitializationOptions()
        )
        val factory = PeerConnectionFactory.builder().createPeerConnectionFactory()
        this.videoSource = factory.createVideoSource(true)
        val audioSource = factory.createAudioSource(MediaConstraints())
        this.localStream = factory.createLocalMediaStream("media")
        this.localVideoTrack = factory.createVideoTrack("video0", this.videoSource)
        this.localAudioTrack = factory.createAudioTrack("audio0", audioSource)
        this.localStream.addTrack(this.localVideoTrack)
        this.localStream.addTrack(this.localAudioTrack)
        this.webRTCClient.localStream = this.localStream
    }

    // 비디오 뷰 설정
    private fun setupVideoView() {
        this.videoView = SurfaceViewRenderer(context)
        this.videoView.init(EglBase.create().eglBaseContext, null)
        this.videoView.setScalingType(RendererCommon.ScalingType.SCALE_ASPECT_FILL)
        this.videoView.setEnableHardwareScaler(true) // 하드웨어 스케일러 활성화
        this.localVideoTrack.addSink(videoView)
    }

    // 렌더러 설정
    private fun setupRenderer() {
        // ios함수에는 여기서 메탈GPU 사용 세팅을 함, 안드로이드는 특수세팅 따로없음

    }

    // 렌더링 루프 시작
    private fun startRenderingLoop() {
        Log.d("NTLOG", "Starting rendering loop")
//        this.arSession.resume()
        this.sceneView.resume()


        this.choreographer = Choreographer.getInstance() // 화면 갱신될때마다 프레임 콜백

        this.frameCallback = Choreographer.FrameCallback { frameTimeNanos ->
            renderFrame(frameTimeNanos)
            // 프레임속도를 30fps로 설정
            this.choreographer.postFrameCallbackDelayed(frameCallback, 30)
        }
        this.choreographer.postFrameCallback(frameCallback)

        Log.d("NTLOG", "Rendering loop started")
    }

    // 렌더링 루프 중지
    private fun stopRenderingLoop() {
        Log.d("NTLOG", "Stopping rendering loop")
        this.choreographer.removeFrameCallback(frameCallback)
        this.arSession.pause()
        this.sceneView.pause()
        this.videoView.release() // SurfaceViewRenderer 해제
        Log.d("NTLOG", "Rendering loop stopped")
    }

    private fun renderFrame(time: Long) {
        if(sceneView.width>0 && sceneView.height>0){
        val width = sceneView.width /2
        val height = sceneView.height /2
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)

        PixelCopy.request(sceneView, bitmap, { copyResult ->
            if (copyResult == PixelCopy.SUCCESS) {
                // 캡처 성공
                
                val rtcPixelBuffer: JavaI420Buffer = createPixelBuffer(bitmap)
                val rtcVideoFrame = VideoFrame(rtcPixelBuffer, 0, time)
                this.videoSource.capturerObserver.onFrameCaptured(rtcVideoFrame)
                this.localVideoTrack.addSink(videoView)
                rtcVideoFrame.release()
                Log.d("NTLOG", "계속 리스너가 되고있나?${time/1000000000}")
            } else {
                // 캡처 실패
                Log.e("PixelCopy", "Capture failed: $copyResult")
            }
        }, Handler(Looper.getMainLooper()))}
    }

    private fun createPixelBuffer(bitmap: Bitmap): JavaI420Buffer {
        val width = bitmap.width
        val height = bitmap.height
        val pixelBuffer = ByteBuffer.allocateDirect(width * height * 4)
        pixelBuffer.order(ByteOrder.nativeOrder())

        // Bitmap에서 픽셀 데이터를 읽어와 ByteBuffer에 저장
        bitmap.copyPixelsToBuffer(pixelBuffer)
        pixelBuffer.rewind()

        val pixelData = ByteArray(width * height * 4)
        pixelBuffer.get(pixelData)
        Log.d("PixelBuffer", "Pixel data: ${pixelData.joinToString(", ")}")

        // YUV 변환
        val ySize = width * height
        val uvSize = width * height / 4
        val yBuffer = ByteBuffer.allocateDirect(ySize)
        val uBuffer = ByteBuffer.allocateDirect(uvSize)
        val vBuffer = ByteBuffer.allocateDirect(uvSize)

        for (i in 0 until height) {
            for (j in 0 until width) {
                val pixel = pixelData[(i * width + j) * 4]
                yBuffer.put(pixel)
                if (i % 2 == 0 && j % 2 == 0) {
                    uBuffer.put(pixel)
                    vBuffer.put(pixel)
                }
            }
        }

        yBuffer.flip()
        uBuffer.flip()
        vBuffer.flip()

        return JavaI420Buffer.wrap(width, height, yBuffer, width, uBuffer, width / 2, vBuffer, width / 2, null)
    }

    // 앱 상태 관찰자 설정
    private fun setupAppStateObservers() {
        // 앱 상태 관찰자 설정 코드 추가
    }

    // PlatformView 인터페이스 구현 - 리소스 해제
    override fun dispose() {
        Log.d("NTLOG", "ARCamera dispose")
        stopRenderingLoop()
        sceneView.destroy()
    }

}