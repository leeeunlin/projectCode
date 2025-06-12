package com.soso.rayo


import android.content.Context
import android.util.Log
import android.view.ViewGroup
import io.flutter.plugin.common.MethodChannel
import io.socket.client.IO
import io.socket.client.Socket
import io.socket.engineio.client.transports.WebSocket
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import org.json.JSONObject
import org.webrtc.DataChannel
import org.webrtc.DefaultVideoDecoderFactory
import org.webrtc.DefaultVideoEncoderFactory
import org.webrtc.EglBase
import org.webrtc.IceCandidate
import org.webrtc.MediaConstraints
import org.webrtc.MediaStream
import org.webrtc.PeerConnection
import org.webrtc.PeerConnectionFactory
import org.webrtc.RtpReceiver
import org.webrtc.SdpObserver
import org.webrtc.SessionDescription
import org.webrtc.VideoTrack

class WebRTCClient(private val context: Context) {
    private var peerConnections: MutableMap<Int, PeerConnection> = mutableMapOf()
    private var userKeyTOname: MutableMap<Int, String> = mutableMapOf()
    private var mysetTrack: MutableMap<Int, MutableMap<String, Boolean>> = mutableMapOf()
    private var myAudio = true
    private var myVideo = true
//    private lateinit var factory: PeerConnectionFactory

    // TODO:: delegate 설정해야함
//    var delegate : PeerConnection??
    var encoderFactory: DefaultVideoEncoderFactory? = null
    var decoderFactory: DefaultVideoDecoderFactory? = null
    var remoteStream: MutableMap<Int, VideoTrack> = mutableMapOf()
    var remoteView: MutableMap<Int, WebRTCView> = mutableMapOf()
    var localStream: MediaStream? = null // NativeView에서 전달받은 localStream
    private lateinit var socket: Socket

    // 유저키값 FL에서 넘겨받아 적용
    var userKey: Int? = null
    private var roomKey: Int? = null
    private var userName: String? = null

    // 커넥션 완료 유무 FL로 전송
    var onConnectionCompleted: (() -> Unit)? = null
    private var methodChannel: MethodChannel? = null

    init {
        // WebRTC 초기화

    }

    fun setMethodChannel(methodChannel: MethodChannel) {
        this.methodChannel = methodChannel
    }

    @OptIn(DelicateCoroutinesApi::class)
    fun connectWebRTC(roomKey: Int, userKey: Int, userName: String) {
        this.roomKey = roomKey
        this.userKey = userKey
        this.userName = userName
        this.socket = IO.socket("http://192.168.0.9:3000", IO.Options().apply {
            transports = arrayOf(WebSocket.NAME)
            forceNew = true
            reconnection = true
        })
        this.socket.on(Socket.EVENT_CONNECT) {
            Log.d("NTLOG", "최초 접속 소켓 발송")
            val joinInfo = JSONObject().apply {
                put("roomKey", roomKey)
                put("userKey", userKey)
                put("userName", userName)
            }
            this.socket.emit("join", joinInfo)
            this.onConnectionCompleted?.let { it1 -> it1() }
        }
        this.socket.on("userJoin") { data ->
            val userData = data?.getOrNull(0) as? JSONObject ?: return@on
            val userKey = userData.get("userKey") as? Int ?: return@on
            val userName = userData.get("userName") as? String ?: return@on
            Log.d("NTLOG", "User Joined: $userKey, $userName")
            if (peerConnections[userKey] == null) {
                this.userKeyTOname[userKey] = userName
                this.mysetTrack[userKey] = mutableMapOf(
                    "oppAudioSet" to true,
                    "oppVideoSet" to true,
                    "myAudioSet" to true,
                    "myVideoSet" to true
                )
                this.createOffer(userKey)
            }
        }
        this.socket.on("offer") { data ->
            Log.d("NTLOG", "오퍼 요청받은 경우")
            val offerData = data?.getOrNull(0) as? JSONObject ?: return@on
            val sdp = offerData["sdp"] as? String ?: return@on
            val userKey = offerData.get("userKey") as? Int ?: return@on
            val userName = offerData.get("userName") as? String ?: return@on
            if (this.peerConnections[userKey] == null) {
                this.userKeyTOname[userKey] = userName
                this.mysetTrack[userKey] = mutableMapOf(
                    "oppAudioSet" to true,
                    "oppVideoSet" to true,
                    "myAudioSet" to true,
                    "myVideoSet" to true
                )
                val remoteDescription = SessionDescription(SessionDescription.Type.OFFER, sdp)
                this.createAnswer(userKey, remoteDescription)
                Log.d("NTLOG", "답변 완료 잘 된건가")
            }
        }

        this.socket.on("answer") { data ->
            Log.d("NTLOG", "오퍼에 대한 답변 요청의 경우")
            val answerData = data?.getOrNull(0) as? JSONObject ?: return@on
            val sdp = answerData["sdp"] as? String ?: return@on
            val userKey = answerData["userKey"] as? Int ?: return@on
            val s_userKey = answerData["s_userKey"] as? Int ?: return@on
            if (s_userKey == this.userKey) {
                val sessionDescription = SessionDescription(SessionDescription.Type.ANSWER, sdp)
                this.peerConnections[userKey]?.setRemoteDescription(
                    SimpleSdpObserver(),
                    sessionDescription
                )
            }

        }
        this.socket.on("ice") { data ->
            Log.d("NTLOG", "아이스 교환")
            val iceData = data?.getOrNull(0) as? JSONObject ?: return@on
            val candidate = iceData["candidate"] as? String ?: return@on
            val sdpMid = iceData["sdpMid"] as? String ?: return@on
            val sdpMLineIndex = iceData["sdpMLineIndex"] as? Int ?: return@on
            val userKey = iceData["userKey"] as? Int ?: return@on
            if (peerConnections[userKey] != null) {
                val iceConnectionState = peerConnections[userKey]?.iceConnectionState()
                if (iceConnectionState == PeerConnection.IceConnectionState.CONNECTED || iceConnectionState == PeerConnection.IceConnectionState.COMPLETED) {
                    return@on
                }
            }
            val iceCandidate = IceCandidate(sdpMid, sdpMLineIndex, candidate)
            this.peerConnections[userKey]?.addIceCandidate(iceCandidate)
        }
        this.socket.on("exitUser") { data ->
            val userKey = data?.getOrNull(0) as? Int ?: return@on

            if (this.peerConnections[userKey] != null) {
                Log.d("NTLOG", "$userKey 유저 나감")
                GlobalScope.launch(Dispatchers.Main) {
                    methodChannel?.invokeMethod("exitUser", userKey)
                }
                this.remoteView[userKey]?.let { webRTCView ->
                    (webRTCView.containerView.parent as? ViewGroup)?.removeView(webRTCView.containerView)
                }
//                this.remoteView[userKey]?.containerView?.removeView(this.remoteView[userKey])
                this.remoteStream.remove(userKey)
                this.peerConnections[userKey]!!.close()
                this.peerConnections.remove(userKey)
                this.userKeyTOname.remove(userKey)
                this.mysetTrack.remove(userKey)
            }
        };
        this.socket.connect()
    }

    private fun createOffer(userKey: Int) {
        Log.d("NTLOG", "오퍼 요청? 오퍼발송")
        this.peerConnections[userKey] = createPeerConnection(userKey)!!
        val mandatory = MediaConstraints().apply {
            mandatory.add(MediaConstraints.KeyValuePair("OfferToReceiveAudio", "true"))
            mandatory.add(MediaConstraints.KeyValuePair("OfferToReceiveVideo", "true"))
        }
        this.peerConnections[userKey]!!.createOffer(object : SimpleSdpObserver() {
            override fun onCreateSuccess(sessionDescription: SessionDescription) {
                this@WebRTCClient.peerConnections[userKey]!!.setLocalDescription(
                    SimpleSdpObserver(),
                    sessionDescription
                )
                val offerData = JSONObject().apply {
                    put("sdp", sessionDescription.description)
                    put("userKey", userKey)
                    put("userName", userName)
                }
                socket.emit("offer", offerData)
            }
        }, mandatory)

    }

    // answer
    private fun createAnswer(userKey: Int, remoteDescription: SessionDescription) {
        this.peerConnections[userKey] = createPeerConnection(userKey)!!
        val mandatory = MediaConstraints().apply {
            mandatory.add(MediaConstraints.KeyValuePair("OfferToReceiveAudio", "true"))
            mandatory.add(MediaConstraints.KeyValuePair("OfferToReceiveVideo", "true"))
        }
        this.peerConnections[userKey]!!.setRemoteDescription(SimpleSdpObserver(), remoteDescription)
        this.peerConnections[userKey]!!.createAnswer(object : SimpleSdpObserver() {
            override fun onCreateSuccess(sessionDescription: SessionDescription) {
                this@WebRTCClient.peerConnections[userKey]!!.setLocalDescription(
                    SimpleSdpObserver(),
                    sessionDescription
                )
                val answerData = JSONObject().apply {
                    put("sdp", sessionDescription.description)
                    put("userKey", this@WebRTCClient.userKey)
                    put("s_userKey", userKey)
                }
                socket.emit("answer", answerData)
            }

        }, mandatory)
    }


    fun createPeerConnection(userKey: Int): PeerConnection? {
        Log.d("NTLOG", "인코더 디코더 생성건")
        // 인코더, 디코더 생성
        encoderFactory = DefaultVideoEncoderFactory(
            EglBase.create().eglBaseContext, /* enableIntelVp8Encoder */
            true, /* enableH264HighProfile */
            true
        )
        decoderFactory = DefaultVideoDecoderFactory(EglBase.create().eglBaseContext)
        Log.d("NTLOG", "인코더 디코더 생성1")

        // 인코더, 디코더를 사용해 PeerConnectionFactory 생성
        val factory = PeerConnectionFactory.builder()
            .setVideoEncoderFactory(encoderFactory)
            .setVideoDecoderFactory(decoderFactory)
            .createPeerConnectionFactory()
        val iceServers = ArrayList<PeerConnection.IceServer>()
        val iceServerBuilder = PeerConnection.IceServer.builder("stun:stun.l.google.com:19302")
        iceServerBuilder.setTlsCertPolicy(PeerConnection.TlsCertPolicy.TLS_CERT_POLICY_INSECURE_NO_CHECK) //this does the magic.
        val iceServer = iceServerBuilder.createIceServer()
        iceServers.add(iceServer)
//        val iceServers = listOf(
//            PeerConnection.IceServer.builder("stun:stun.l.google.com:19302").createIceServer()
//        )
        Log.d("NTLOG", "인코더 디코더 생성2")
//        val constraints = MediaConstraints().apply {
//            optional.add(MediaConstraints.KeyValuePair("DtlsSrtpKeyAgreement", "true"))
//        }

        val config = PeerConnection.RTCConfiguration(iceServers)
        config.iceTransportsType = PeerConnection.IceTransportsType.ALL
        config.rtcpMuxPolicy = PeerConnection.RtcpMuxPolicy.NEGOTIATE
        config.continualGatheringPolicy = PeerConnection.ContinualGatheringPolicy.GATHER_CONTINUALLY
        config.bundlePolicy = PeerConnection.BundlePolicy.MAXBUNDLE
        val peerConnection = factory.createPeerConnection(config, createPeerConnectionObserver(userKey))
        // 비디오 및 오디오 트랙을 peerConnection에 추가
        localStream?.let { stream ->
            stream.videoTracks.forEach { track ->
                peerConnection?.addTrack(track, listOf(stream.id))
            }
            stream.audioTracks.forEach { track ->
                peerConnection?.addTrack(track, listOf(stream.id))
            }
        }
        return peerConnection
    }

    fun disconnectWebRTC() {
        for ((_, peerConnection) in peerConnections) {
            peerConnection.close()
        }
        peerConnections.clear()
        if (this::socket.isInitialized && socket.connected()) {
            socket.disconnect()
        }
    }

    fun getUserKey(peerConnection: PeerConnection.Observer): Int? {
        for ((key, value) in peerConnections) {
            if (value == peerConnection) {
                return key
            }
        }
        return null
    }


    @OptIn(DelicateCoroutinesApi::class)
    private fun createPeerConnectionObserver(userKey: Int): PeerConnection.Observer {
        return object : PeerConnection.Observer {
            override fun onSignalingChange(signalingState: PeerConnection.SignalingState) {
                Log.d("NTLOG", "Signaling state changed: $signalingState")
            }

            override fun onIceConnectionChange(iceConnectionState: PeerConnection.IceConnectionState) {
                Log.d("NTLOG", "ICE connection state changed: $iceConnectionState")
            }

            override fun onIceConnectionReceivingChange(receiving: Boolean) {
                Log.d("NTLOG", "ICE connection receiving change: $receiving")
            }

            override fun onIceGatheringChange(iceGatheringState: PeerConnection.IceGatheringState) {
                Log.d("NTLOG", "ICE gathering state changed: $iceGatheringState")
            }

            override fun onIceCandidate(candidate: IceCandidate) {
                Log.d("NTLOG", "New ICE candidate: $candidate")
                val candidateData = JSONObject().apply {
                    put("candidate", candidate.sdp)
                    put("sdpMid", candidate.sdpMid)
                    put("sdpMLineIndex", candidate.sdpMLineIndex)
                    put("userKey", this@WebRTCClient.userKey)
                }
                socket.emit("ice", candidateData)
            }

            override fun onIceCandidatesRemoved(candidates: Array<IceCandidate>) {
                Log.d("NTLOG", "ICE candidates removed: ${candidates.joinToString()}")
            }

            override fun onAddStream(stream: MediaStream) {
                Log.d("NTLOG", "Stream added: $stream")
                remoteStream[userKey] = stream.videoTracks.first()
                val userData = mapOf(
                    "userKey" to userKey,
                    "userName" to userKeyTOname[userKey]!!
                )
                GlobalScope.launch(Dispatchers.Main) {
                    methodChannel?.invokeMethod("NTtoFL_remoteViewer", userData)
                }
            }

            override fun onRemoveStream(stream: MediaStream) {
                Log.d("NTLOG", "Stream removed: $stream")
            }

            override fun onDataChannel(dataChannel: DataChannel) {
                Log.d("NTLOG", "Data channel: $dataChannel")
            }

            override fun onRenegotiationNeeded() {
                Log.d("NTLOG", "Renegotiation needed")
            }

            override fun onAddTrack(receiver: RtpReceiver, streams: Array<MediaStream>) {
                Log.d("NTLOG", "Track added: $receiver")
            }
        }
    }

}

open class SimpleSdpObserver : SdpObserver {
    override fun onCreateSuccess(sessionDescription: SessionDescription) {
        Log.d("SimpleSdpObserver", "onCreateSuccess: $sessionDescription")
    }

    override fun onSetSuccess() {
        Log.d("SimpleSdpObserver", "onSetSuccess")
    }

    override fun onCreateFailure(error: String) {
        Log.e("SimpleSdpObserver", "onCreateFailure: $error")
    }

    override fun onSetFailure(error: String) {
        Log.e("SimpleSdpObserver", "onSetFailure: $error")
    }
}