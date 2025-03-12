import ARKit
import SceneKit
import WebRTC
import UIKit

@available(iOS 13.0, *)
class ArCameraFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var webRTCClient: WebRTCClient
    private var appDelegate: AppDelegate
    init(messenger: FlutterBinaryMessenger, webRTCClient: WebRTCClient, appDelegate: AppDelegate) {
        self.messenger = messenger
        self.webRTCClient = webRTCClient
        self.appDelegate = appDelegate
        super.init()
    }
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        var width: Double = 0
        var height: Double = 0
        // FL_creationParams value
        if let argsMap = args as? [String: Any] {
            if let w = argsMap["width"] as? Double {
                width = w
            }
            if let h = argsMap["height"] as? Double {
                height = h
            }
        }
        return ArCameraView(
            frame: CGRect(x: 0, y: 0, width: width, height: height),
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            webRTCClient: webRTCClient,
            appDelegate: appDelegate
        )
    }
}

@available(iOS 13.0, *)
class ArCameraView: NSObject, FlutterPlatformView, ARSessionDelegate {
    private var arSession: ARSession!
    private var sceneView: ARSCNView!
    private var renderer: SCNRenderer!
    private var localVideoTrack: RTCVideoTrack!
    private var localAudioTrack: RTCAudioTrack!
    private var localStream: RTCMediaStream!
    private var videoSource: RTCVideoSource!
    private var videoCapturer: RTCVideoCapturer!
    private var videoView: RTCMTLVideoView!
    private var webRTCClient: WebRTCClient
    private var displayLink: CADisplayLink?
    private var appDelegate: AppDelegate
    
    private var userRemoteViews: [Int: RTCMTLVideoView] = [:]
    
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger: FlutterBinaryMessenger, webRTCClient: WebRTCClient, appDelegate: AppDelegate) {
        self.webRTCClient = webRTCClient
        self.appDelegate = appDelegate
        
        super.init()
        self.appDelegate.arCameraView = self
        setupAudioSession()
        setupARSession()
        setupWebRTC()
        setupVideoView(frame: frame)
        setupRenderer()
        startRenderingLoop()
        setupAppStateObservers()
    }
    func view() -> UIView {
        return sceneView
    }
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP, .defaultToSpeaker])
            try audioSession.setMode(.default)
            try audioSession.setPreferredSampleRate(48000)
            try audioSession.setPreferredIOBufferDuration(0.005)
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    private func setupARSession() {
        videoSource = RTCPeerConnectionFactory().videoSource()
        videoCapturer = RTCCameraVideoCapturer(delegate: videoSource)
        arSession = ARSession()
        arSession.delegate = self
        sceneView = ARSCNView()
        sceneView.session = arSession
        sceneView.delegate = self
//        arSession.run(ARFaceTrackingConfiguration())
    }
    
    private func setupWebRTC() {
        let factory = RTCPeerConnectionFactory()
        let videoSource = factory.videoSource()
        let audioSource = factory.audioSource(with: nil)
        localStream = factory.mediaStream(withStreamId: "media")
        localVideoTrack = factory.videoTrack(with: videoSource, trackId: "video0")
        localAudioTrack = factory.audioTrack(with: audioSource, trackId: "audio0")
        localStream.addVideoTrack(localVideoTrack)
        localStream.addAudioTrack(localAudioTrack)
        webRTCClient.localStream = localStream
    }
    
    private func setupVideoView(frame: CGRect) {
        videoView = RTCMTLVideoView(frame: frame)
        videoView.videoContentMode = .scaleAspectFill
        localVideoTrack.add(videoView)
    }
    
    private func setupRenderer() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        renderer = SCNRenderer(device: device, options: nil)
        renderer.scene = sceneView.scene
    }
    private func setupAppStateObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func appDidEnterBackground() {
        stopRenderingLoop()
    }
    
    @objc private func appWillEnterForeground() {
        startRenderingLoop()
    }
    func startRenderingLoop() {
        arSession.run(ARFaceTrackingConfiguration())
        displayLink = CADisplayLink(target: self, selector: #selector(renderFrame))
        displayLink?.preferredFramesPerSecond = 30 // 프레임 속도를 30fps로 설정
        displayLink?.add(to: .main, forMode: .default)
    }
    func stopRenderingLoop() {
        displayLink?.isPaused = true
        displayLink?.remove(from: .main, forMode: .default)
        displayLink?.invalidate()
        displayLink = nil
        arSession.pause()
//        webRTCClient.disconnectWebRTC()
    }
    func dispose() {
        stopRenderingLoop()
        NotificationCenter.default.removeObserver(self)
        sceneView.removeFromSuperview()
        videoView.removeFromSuperview()
    }
    
    @objc private func renderFrame() {
        autoreleasepool {
            let time = CACurrentMediaTime()
            let pixelBuffer = createPixelBuffer()
            
            if let pixelBuffer = pixelBuffer {
                let rtcPixelBuffer = RTCCVPixelBuffer(pixelBuffer: pixelBuffer)
                let rtcVideoFrame = RTCVideoFrame(buffer: rtcPixelBuffer, rotation: ._0, timeStampNs: Int64(time * 1000000000))
                videoSource.capturer(videoCapturer, didCapture: rtcVideoFrame)
                localVideoTrack.source.capturer(videoCapturer, didCapture: rtcVideoFrame)
            }
        }
    }
    
    private func createPixelBuffer() -> CVPixelBuffer? {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue() else {
            return nil
        }
        
        let width = Int(videoView.bounds.width)
        let height = Int(videoView.bounds.height)
        
        var pixelBuffer: CVPixelBuffer?
        let pixelBufferAttributes: [String: Any] = [
            kCVPixelBufferMetalCompatibilityKey as String: true,
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height,
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, pixelBufferAttributes as CFDictionary, &pixelBuffer)
        
        guard let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm_srgb, width: width, height: height, mipmapped: false)
        textureDescriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        
        var textureCache: CVMetalTextureCache?
        let cacheStatus = CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &textureCache)
        
        guard cacheStatus == kCVReturnSuccess, let cache = textureCache else {
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }
        
        var cvTextureOut: CVMetalTexture?
        let status = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, cache, buffer, nil, .bgra8Unorm_srgb, width, height, 0, &cvTextureOut)
        
        guard status == kCVReturnSuccess, let cvTexture = cvTextureOut else {
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }
        
        let texture = CVMetalTextureGetTexture(cvTexture)
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        renderer.render(atTime: CACurrentMediaTime(), viewport: sceneView.bounds, commandBuffer: commandBuffer!, passDescriptor: renderPassDescriptor)
        
        commandBuffer?.commit()
        commandBuffer?.waitUntilCompleted()
        
        CVPixelBufferUnlockBaseAddress(buffer, [])
        
        return buffer
    }
}

@available(iOS 13.0, *)
extension ArCameraView: ARSCNViewDelegate {
    func renderer(_: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        guard sceneView.device != nil else {
            fatalError("Metal is not supported on this device.")
        }
        let node = SCNNode()
    let leftEyeNode = SCNNode(geometry: SCNSphere(radius: 0.02))
        leftEyeNode.name = "leftEye"
        leftEyeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        node.addChildNode(leftEyeNode)
        
        let rightEyeNode = SCNNode(geometry: SCNSphere(radius: 0.02))
        rightEyeNode.name = "rightEye"
        rightEyeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        node.addChildNode(rightEyeNode)
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        node.childNode(withName: "leftEye", recursively: true)?.transform = SCNMatrix4(faceAnchor.leftEyeTransform)
        node.childNode(withName: "rightEye", recursively: true)?.transform = SCNMatrix4(faceAnchor.rightEyeTransform)
        
        if let eyeBlinkLeft = faceAnchor.blendShapes[.eyeBlinkLeft] as? Float {
            let leftEyeNode = node.childNode(withName: "leftEye", recursively: true)
            leftEyeNode?.geometry = SCNSphere(radius: 0.02 * (1 - CGFloat(eyeBlinkLeft)))
        }
        if let eyeBlinkRight = faceAnchor.blendShapes[.eyeBlinkRight] as? Float {
            let rightEyeNode = node.childNode(withName: "rightEye", recursively: true)
            rightEyeNode?.geometry = SCNSphere(radius: 0.02 * (1 - CGFloat(eyeBlinkRight)))
        }
    }
}

extension ARFaceAnchor.BlendShapeLocation {
    static let eyeBlinkLeft = ARFaceAnchor.BlendShapeLocation(rawValue: "eyeBlink_L")
    static let eyeBlinkRight = ARFaceAnchor.BlendShapeLocation(rawValue: "eyeBlink_R")
}
