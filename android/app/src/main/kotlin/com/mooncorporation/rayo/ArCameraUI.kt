package com.mooncorporation.rayo

import android.app.Activity
import android.content.Context
import android.media.AudioManager
import android.opengl.GLES20
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import com.google.ar.core.ArCoreApk
import com.google.ar.core.AugmentedFace
import com.google.ar.core.CameraConfig
import com.google.ar.core.CameraConfigFilter
import com.google.ar.core.Config
import com.google.ar.core.Session
import com.google.ar.sceneform.ArSceneView
import com.google.ar.sceneform.ux.AugmentedFaceNode
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import org.webrtc.AudioTrack
import org.webrtc.Camera2Enumerator
import org.webrtc.CameraVideoCapturer
import org.webrtc.EglBase
import org.webrtc.MediaConstraints
import org.webrtc.MediaStream
import org.webrtc.PeerConnectionFactory
import org.webrtc.RendererCommon
import org.webrtc.SurfaceTextureHelper
import org.webrtc.SurfaceViewRenderer
import org.webrtc.VideoTrack
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer

class ArCameraFactory(private val webRTCClient: WebRTCClient,
                      private val creationParams: Map<String, Any>?,
                      private val mainActivity: MainActivity,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d("ArCameraFactory", "ArCameraView 생성준비")
        return ArCameraView(context, webRTCClient, creationParams, mainActivity)
    }
}

class ArCameraView(private val context: Context,
                   private val webRTCClient: WebRTCClient,
                   private val creationParams: Map<String, Any>?,
                   private val mainActivity: MainActivity) : PlatformView {
    private lateinit var arSession: Session // arSession
    private lateinit var sceneView: ArSceneView // arScreen (메인화면)
    private lateinit var localVideoTrack: VideoTrack // 연결될 경우 상대방에게 전송되는 트랙
    private lateinit var localAudioTrack: AudioTrack // 연결될 경우 상대방에게 전송되는 트랙
    private lateinit var localStream: MediaStream // 내 화면에 보여줄 stream (화면전환 시 사용됨)
    private lateinit var videoView: SurfaceViewRenderer //
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
            Log.e("ArCameraView", "ARCore 지원하지않는기기")
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
                        Log.e("ArCameraView", "ARCore 설치에러", e)
                    }
                } else {
                    Log.e("ArCameraView", "Context가 Activity가 아님")
                }
                false
            }
            ArCoreApk.Availability.UNSUPPORTED_DEVICE_NOT_CAPABLE -> {
                Log.e("ArCameraView", "ARCore 지원 불가능 기기")
                false
            }
            else -> false
        }
    }

    // PlatformView 인터페이스 구현 - View 반환
    override fun getView(): View {
        Log.d("ArCameraView", "frameLayout 반환")
        return this.sceneView
    }

    // 오디오 세션 설정
    private fun setupAudioSession(){
        val audioSession = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        try {
            audioSession.mode = AudioManager.MODE_IN_COMMUNICATION
            audioSession.isSpeakerphoneOn = true
            audioSession.setBluetoothScoOn(true)
            audioSession.startBluetoothSco()
        } catch (e: Exception) {
            Log.e("AudioSession", "Error setting up audio session: ${e.message}")
        }
    }

    // AR 세션 설정
    private fun setupARSession(){
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
//        sceneView.resume()
//        createFaceBox()
    }

    // WebRTC 설정
    private fun setupWebRTC(){
        PeerConnectionFactory.initialize(PeerConnectionFactory.InitializationOptions.builder(context).createInitializationOptions())
        val factory = PeerConnectionFactory.builder().createPeerConnectionFactory()
        val videoSource = factory.createVideoSource(false)
        val audioSource = factory.createAudioSource(MediaConstraints())
        this.localStream = factory.createLocalMediaStream("media")
        this.localVideoTrack = factory.createVideoTrack("video0", videoSource)
        this.localAudioTrack = factory.createAudioTrack("audio0", audioSource)
        this.localStream.addTrack(localVideoTrack)
        this.localStream.addTrack(localAudioTrack)
        this.webRTCClient.localStream = this.localStream
        val enumerator = Camera2Enumerator(context)
        localStream.
        val videoCapture = createCameraEnumerator(enumerator)
        if (videoCapture != null) {
            // TODO :: 위젯 최대사이즈 재정의 필요함
            val width = (creationParams?.get("width") as? Double)?.toInt() ?: FrameLayout.LayoutParams.MATCH_PARENT
            val height = (creationParams?.get("height") as? Double)?.toInt() ?: FrameLayout.LayoutParams.MATCH_PARENT
            videoCapture.initialize(SurfaceTextureHelper.create("CaptureThread", EglBase.create().eglBaseContext), context, videoSource.capturerObserver)
            videoCapture.startCapture(width, height, 30)
        } else {
            Log.e("ArCameraView", "카메라 캡처러를 찾을 수 없습니다.")
        }
    }

    // 비디오 뷰 설정
    private fun setupVideoView() {
        this.videoView = SurfaceViewRenderer(context)
        this.videoView.init(EglBase.create().eglBaseContext, null)
        this.videoView.setScalingType(RendererCommon.ScalingType.SCALE_ASPECT_FILL)
        this.localVideoTrack.addSink(videoView)
    }

    // 카메라 캡처러 생성
    private fun createCameraEnumerator(enumerator: Camera2Enumerator): CameraVideoCapturer? {
        val deviceNames = enumerator.deviceNames
        for (deviceName in deviceNames) {
            if (enumerator.isFrontFacing(deviceName)) {
                val videoCapture = enumerator.createCapturer(deviceName, null)
                if (videoCapture != null) {
                    return videoCapture
                }
            }
        }
        for (deviceName in deviceNames) {
            if (!enumerator.isFrontFacing(deviceName)) {
                val videoCapturer = enumerator.createCapturer(deviceName, null)
                if (videoCapturer != null) {
                    return videoCapturer
                }
            }
        }
        return null
    }

    // 렌더러 설정
    private fun setupRenderer() {
        // 렌더러 설정 코드 추가
    }

    // 렌더링 루프 시작
    private fun startRenderingLoop() {
        this.arSession.resume()
        this.sceneView.resume()
    }

    // 렌더링 루프 중지
    private fun stopRenderingLoop() {
        this.arSession.pause()
        this.sceneView.pause()
    }

    // 앱 상태 관찰자 설정
    private fun setupAppStateObservers() {
        // 앱 상태 관찰자 설정 코드 추가
    }

    // PlatformView 인터페이스 구현 - 리소스 해제
    override fun dispose() {
        Log.d("ArCameraView", "ARCamera dispose")
        stopRenderingLoop()
        sceneView.destroy()
    }

    // 얼굴 트래킹 박스 생성
    private fun createFaceBox() {
        val faceList = this.arSession.getAllTrackables(AugmentedFace::class.java)
        faceList.forEach { face ->
            val faceNode = AugmentedFaceNode(face)
            faceNode.setParent(sceneView.scene)
            drawYellowCircle(face)
        }
    }

    // OpenGL을 사용하여 얼굴 가운데 노란 원을 그리는 함수
    private fun drawYellowCircle(face: AugmentedFace) {
        val centerVertex = face.centerPose.translation
        val radius = 0.05f
        val numSegments = 100

        val circleVertices = FloatArray(numSegments * 3)
        for (i in 0 until numSegments) {
            val angle = 2.0 * Math.PI * i / numSegments
            circleVertices[i * 3] = (centerVertex[0] + radius * Math.cos(angle)).toFloat()
            circleVertices[i * 3 + 1] = (centerVertex[1] + radius * Math.sin(angle)).toFloat()
            circleVertices[i * 3 + 2] = centerVertex[2]
        }

        val vertexBuffer: FloatBuffer = ByteBuffer.allocateDirect(circleVertices.size * 4)
            .order(ByteOrder.nativeOrder())
            .asFloatBuffer()
            .put(circleVertices)
        vertexBuffer.position(0)

        GLES20.glEnableVertexAttribArray(0)
        GLES20.glVertexAttribPointer(0, 3, GLES20.GL_FLOAT, false, 0, vertexBuffer)
        GLES20.glUniform4f(GLES20.glGetUniformLocation(0, "u_Color"), 1.0f, 1.0f, 0.0f, 1.0f)
        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, numSegments)
        GLES20.glDisableVertexAttribArray(0)
    }
}