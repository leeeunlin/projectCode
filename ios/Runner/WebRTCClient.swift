import WebRTC
import SocketIO

@available(iOS 13.0, *)
class WebRTCClient: NSObject {
    private var peerConnections: [Int: RTCPeerConnection] = [:]
    private var userKeyTOname:[Int:String] = [:]
    private var mysetTrack: [Int:[String:Bool]] = [:]
    private var myAudio = true
    private var myVideo = true
//    var factory: RTCPeerConnectionFactory?
    var delegate: RTCPeerConnectionDelegate?
    var encoderFactory: RTCDefaultVideoEncoderFactory?
    var decoderFactory: RTCDefaultVideoDecoderFactory?
    var remoteStream: [Int: RTCVideoTrack] = [:]
    var remoteView: [Int: WebRTCView] = [:]
    var localStream: RTCMediaStream? // NativeView에서 전달받은 localStream
    var socket: SocketIOClient!
    private var manager: SocketManager!
    
    // 유저키값 FL에서 넘겨받아 적용
    var userKey: Int?
    private var roomKey: Int?
    private var userName: String?
    // 커넥션 완료 유무 FL로 전송
    var onConnectionCompleted: (() -> Void)?
    private var methodChannel: FlutterMethodChannel?
    
    override init() {
        super.init()
    }
    func setMethodChannel(_ methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }
    func createPeerConnection() -> RTCPeerConnection? {
        // 인코더, 디코더 생성
        encoderFactory = RTCDefaultVideoEncoderFactory()
        decoderFactory = RTCDefaultVideoDecoderFactory()
        // 지원코덱
        for codecInfo in RTCDefaultVideoEncoderFactory.supportedCodecs() {
            if codecInfo.name.elementsEqual("H264") {
                encoderFactory!.preferredCodec = codecInfo
                break
            }
        }
        // 인코더, 디코더를 사용해 PeerConnectionFactory 생성
        let factory = RTCPeerConnectionFactory(encoderFactory: encoderFactory, decoderFactory: decoderFactory)
        let iceServers = [RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])]
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: [:])
        let config = RTCConfiguration()
        config.iceServers = iceServers
        config.iceTransportPolicy = .all
        config.rtcpMuxPolicy = .negotiate
        config.continualGatheringPolicy = .gatherContinually
        config.bundlePolicy = .maxBundle
        let peerConnection = factory.peerConnection(with: config, constraints: constraints, delegate: self)
        
        // 비디오 및 오디오 트랙을 peerConnection에 추가
        if let localStream = localStream {
            for track in localStream.videoTracks {
                peerConnection!.add(track, streamIds: [localStream.streamId])
            }
            for track in localStream.audioTracks {
                peerConnection!.add(track, streamIds: [localStream.streamId])
            }
        }
        return peerConnection
    }
    
    func connectWebRTC(roomKey: Int, userKey: Int, userName: String) {
        self.userKey = userKey
        self.roomKey = roomKey
        self.userName = userName
        // Socket.IO 초기화 및 연결
        manager = SocketManager(socketURL: URL(string: "http://192.168.0.9:3000")!, config: [.log(true), .compress, .forceNew(true), .forceWebsockets(true)])
        socket = manager.defaultSocket
        
        // 소켓 이벤트 소켓이 연결되면 서버에 join을 호출함
        socket.on(clientEvent: .connect) { data, ack in
            let joinInfo: [String: Any] = [
                "roomKey": self.roomKey!,
                "userKey": self.userKey!,
                "userName": self.userName!,
            ]
            self.socket.emit("join", joinInfo)
            self.onConnectionCompleted?()
        }
        
        socket.on("userJoin") { data, ack in
            guard let userData = data[0] as? [String: Any],
                  let userKey = userData["userKey"] as? Int,
                  let userName = userData["userName"] as? String else {
                return
            }
            
            if self.peerConnections[userKey] == nil{
                print("\(userKey) 방 들어옴")
                self.userKeyTOname[userKey] = userName
                self.mysetTrack[userKey] = ["oppAudioSet": true, "oppVideoSet": true, "myAudioSet": true , "myVideoSet": true]
                self.createOffer(userKey: userKey)}
        }
        socket.on("offer"){data, ack in
            guard let offerData = data[0] as? [String: Any],
                  let sdp = offerData["sdp"] as? String,
                  let userKey = offerData["userKey"] as? Int,
                  let userName = offerData["userName"] as? String else {
                return
            }
            
            if self.peerConnections[userKey] == nil{
                print("\(userKey) offer 들어옴")
                self.userKeyTOname[userKey] = userName
                self.mysetTrack[userKey] = ["oppAudioSet": true, "oppVideoSet": true, "myAudioSet": true , "myVideoSet": true]
                let remoteDescription = RTCSessionDescription(
                    type: RTCSdpType.offer, sdp: sdp)

                self.createAnswer(userKey: userKey, remoteDescription: remoteDescription)
            }
            
        }
        
        socket.on("answer") { data, ack in
            guard let answerData = data[0] as? [String: Any],
                  let sdp = answerData["sdp"] as? String,
                  let userKey = answerData["userKey"] as? Int,
                  let s_userKey = answerData["s_userKey"] as? Int else {
                return
            }
            if s_userKey == self.userKey! {
                print("\(userKey) answer들어옴")
                let sessionDescription = RTCSessionDescription(
                    type: RTCSdpType.answer, sdp: sdp)
                self.peerConnections[userKey]?.setRemoteDescription(sessionDescription) { error in
                    if error != nil {
                        return
                    }
                }
            }
            
        }
        
        socket.on("ice") { data, ack in
            guard let iceData = data[0] as? [String: Any],
                  let candidate = iceData["candidate"] as? String,
                  let sdpMid = iceData["sdpMid"] as? String,
                  let sdpMLineIndex = iceData["sdpMLineIndex"] as? Int32,
                  let userKey = iceData["userKey"] as? Int else {
                return
            }
            //            print("ice들어옴?")
            // ICE 연결 상태 확인
            if self.peerConnections[userKey]!.iceConnectionState == .connected || self.peerConnections[userKey]!.iceConnectionState == .completed {
                print("ICE 연결이 이미 완료되었습니다. ICE 후보를 추가하지 않습니다.")
                return
            }
            let iceCandidate = RTCIceCandidate(sdp: candidate, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid)
            self.peerConnections[userKey]!.add(iceCandidate){ error in
                if error != nil {
                    print("아이스 추가 실패 \(userKey)")
                }else{
                    print("아이스 추가 완료 \(userKey)")
                }
            }
        }
        socket.on("audio"){ data, ack in
            guard let audioData = data[0] as? [String: Any],
                  let userKey = audioData["userKey"] as? Int,
                  let audio = audioData["audio"] as? Bool else {
                return
            }
            self.mysetTrack[userKey]!["oppAudioSet"] = audio
            self.audioSet(userKey:userKey)
            
        }
        socket.on("video"){ data, ack in
            guard let videoData = data[0] as? [String: Any],
                  let userKey = videoData["userKey"] as? Int,
                  let video = videoData["video"] as? Bool else {
                return
            }
            
            self.mysetTrack[userKey]!["oppVideoSet"] = video
            self.videoSet(userKey:userKey)
        }
        socket.on("exitUser"){ data, ack in
            guard let userKey = data[0] as? Int else {
                return
            }
            if self.peerConnections[userKey] != nil{
                print("\(userKey) 유저 나감")
                DispatchQueue.main.async {
                    self.methodChannel?.invokeMethod("exitUser", arguments: userKey)}
                if(self.remoteView[userKey] != nil){
                    self.remoteView[userKey]!.containerView.removeFromSuperview()
                }
                self.remoteView.removeValue(forKey: userKey)
                self.remoteStream.removeValue(forKey: userKey)
                self.peerConnections[userKey]!.close()
                self.peerConnections.removeValue(forKey: userKey)
                self.userKeyTOname.removeValue(forKey: userKey)
                self.mysetTrack.removeValue(forKey: userKey)
                
            }
        }
        self.socket.connect()
    }
    
    func createOffer(userKey: Int) {
        peerConnections[userKey] = createPeerConnection()
        let mandatory: [String: String] = [
            kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueTrue,
            kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueTrue
        ]
        let constraints = RTCMediaConstraints(mandatoryConstraints: mandatory, optionalConstraints: nil)
        peerConnections[userKey]!.offer(for: constraints) { (sdp, error) in
            guard let sdp = sdp else {
                return
            }
            self.peerConnections[userKey]!.setLocalDescription(sdp, completionHandler: { (error) in
                if error != nil {
                    return
                }
                // SDP 오퍼를 서버로 전송
                let offerData: [String: Any] = [
                    "sdp": sdp.sdp,
                    "userKey": self.userKey!,
                    "userName": self.userName!
                ]
                self.socket.emit("offer", offerData)
            })
        }
    }
    func createAnswer(userKey: Int, remoteDescription: RTCSessionDescription){
        peerConnections[userKey] = createPeerConnection()
        let mandatory: [String: String] = [
            kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueTrue,
            kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueTrue
        ]
        let constraints = RTCMediaConstraints(mandatoryConstraints: mandatory, optionalConstraints: nil)
        self.peerConnections[userKey]!.setRemoteDescription(remoteDescription) { error in
            if let error {
                print("Failed to set remote description: \(error)")
            }
        }
        self.peerConnections[userKey]!.answer(for: constraints) { (sdp, error) in
            guard let sdp = sdp else {
                return
            }
            self.peerConnections[userKey]!.setLocalDescription(sdp, completionHandler: { (error) in
                if error != nil {
                    return
                }
                // SDP answer를 서버로 전송
                let answerData: [String: Any] = [
                    "sdp": sdp.sdp,
                    "userKey": self.userKey!,
                    "s_userKey": userKey
                ]
                self.socket.emit("answer", answerData)
            })
        }
    }
    func audioChange(){
        self.myAudio = !self.myAudio
        let changeData: [String: Any] = [
            "userKey": self.userKey!,
            "audio": self.myAudio
        ]
        self.socket.emit("audio", changeData)
    }
    func videoChange(){
        self.myVideo = !self.myVideo
        let changeData: [String: Any] = [
            "userKey": self.userKey!,
            "video": self.myVideo
        ]
        self.socket.emit("video", changeData)
    }
    func oppAudioSet(userKey: Int){
        if let myAudioSet = self.mysetTrack[userKey]!["myAudioSet"] {
            self.mysetTrack[userKey]!["myAudioSet"] = !myAudioSet
        }
        audioSet(userKey: userKey)
    }
    func oppVideoSet(userKey: Int){
        if let myVideoSet = self.mysetTrack[userKey]!["myVideoSet"] {
            self.mysetTrack[userKey]!["myVideoSet"] = !myVideoSet
        }
        videoSet(userKey: userKey)
    }
    
    func audioSet(userKey: Int){
        if let myAudioSet = self.mysetTrack[userKey]!["myAudioSet"], myAudioSet {
            if let peerConnection = self.peerConnections[userKey] {
                for receiver in peerConnection.receivers {
                    if let track = receiver.track, track.kind == kRTCMediaStreamTrackKindAudio {
                        track.isEnabled = self.mysetTrack[userKey]!["oppAudioSet"]!
                    }
                }
            }
        } else {
            if let peerConnection = self.peerConnections[userKey] {
                for receiver in peerConnection.receivers {
                    if let track = receiver.track, track.kind == kRTCMediaStreamTrackKindAudio {
                        track.isEnabled = false
                    }
                }
            }
        }
    }
    func videoSet(userKey: Int){
        if let myVideoSet = self.mysetTrack[userKey]!["myVideoSet"], myVideoSet {
            if let peerConnection = self.peerConnections[userKey] {
                for receiver in peerConnection.receivers {
                    if let track = receiver.track, track.kind == kRTCMediaStreamTrackKindVideo {
                        track.isEnabled = self.mysetTrack[userKey]!["oppVideoSet"]!
                    }
                }
            }
        } else {
            if let peerConnection = self.peerConnections[userKey] {
                for receiver in peerConnection.receivers {
                    if let track = receiver.track, track.kind == kRTCMediaStreamTrackKindVideo {
                        track.isEnabled = false
                    }
                }
            }
        }
    }
    func exitUser(userKey: Int) {
        
    }
    
    func disconnectWebRTC() {
        for (_, peerConnection) in peerConnections {
            peerConnection.close()
        }
        peerConnections.removeAll()
        if(socket != nil && socket.status == .connected){
            socket.disconnect()
        }
    }
    func getUserKey(for peerConnection: RTCPeerConnection) -> Int? {
        for (key, value) in peerConnections {
            if value == peerConnection {
                return key
            }
        }
        return nil
    }
}

@available(iOS 13.0, *)
extension WebRTCClient: RTCPeerConnectionDelegate {
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange state: RTCSignalingState) {
    }
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        
        if let userKey = getUserKey(for: peerConnection) {
            print("\(self.userKey!) 가 \(userKey) 의 스트림을 가져왔습니다.")
            self.remoteStream[userKey] = stream.videoTracks.first
            print("extenstion==== NTtoFL_remoteViewer call")
            let userData: [String:Any] = [
                "userKey": userKey,
                "userName": self.userKeyTOname[userKey]!
            ]
            let defaultAudio: [String: Any] = [
                "userKey": self.userKey!,
                "audio": self.myAudio
            ]
            let defaultVideo: [String: Any] = [
                "userKey": self.userKey!,
                "video": self.myVideo
            ]
            self.socket.emit("audio", defaultAudio)
            self.socket.emit("video", defaultVideo)
            DispatchQueue.main.async {
                self.methodChannel?.invokeMethod("NTtoFL_remoteViewer", arguments: userData)}
        }
    }
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
    }
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange state: RTCIceConnectionState) {
    }
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange state: RTCIceGatheringState) {
    }
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        let candidateData: [String:Any] = [
            "candidate": candidate.sdp,
            "sdpMid": candidate.sdpMid ?? "",
            "sdpMLineIndex": candidate.sdpMLineIndex,
            "userKey": self.userKey!,
        ]
        self.socket.emit("ice", candidateData);
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd receiver: RTCRtpReceiver, streams: [RTCMediaStream]) {
        
    }
}
