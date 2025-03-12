import WebRTC
import UIKit

@available(iOS 13.0, *)
class WebRTCViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var webRTCClient: WebRTCClient
    init(messenger: FlutterBinaryMessenger, webRTCClient: WebRTCClient) {
        self.messenger = messenger
        self.webRTCClient = webRTCClient
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
        return WebRTCView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            webRTCClient: webRTCClient
        )
    }
}
@available(iOS 13.0, *)
class WebRTCView: NSObject, FlutterPlatformView {
    private var frame: CGRect
    private var viewId: Int64
    private var messenger: FlutterBinaryMessenger
    private var webRTCClient: WebRTCClient
    var containerView: UIView
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger: FlutterBinaryMessenger, webRTCClient: WebRTCClient) {
        let userKey = args as? Int
        self.frame = frame
        self.viewId = viewId
        self.messenger = binaryMessenger
        self.webRTCClient = webRTCClient
        self.containerView = UIView()
        super.init()
        if userKey == self.webRTCClient.userKey!{
            setupLocalVideoView()
        }else{
            setupRemoteVideoView(userKey: userKey!)}
    }
    func view() -> UIView {
        return containerView
    }
    func setupRemoteVideoView(userKey: Int) {
//        DispatchQueue.main.async {
            let videoView = RTCMTLVideoView(frame: .zero)
            videoView.translatesAutoresizingMaskIntoConstraints = false
            self.webRTCClient.remoteStream[userKey]!.add(videoView)
            self.containerView.addSubview(videoView)
            NSLayoutConstraint.activate([
                videoView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
                videoView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
                videoView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
                videoView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
            ])
            self.webRTCClient.remoteView[userKey] = self
//        }
    }
    func setupLocalVideoView(){
//        DispatchQueue.main.async {
            let videoView = RTCMTLVideoView(frame: .zero)
            videoView.translatesAutoresizingMaskIntoConstraints = false
            if let localVideoTrack = self.webRTCClient.localStream?.videoTracks.first {
                localVideoTrack.add(videoView)
            } else {
                print("Error: localVideoTrack is nil")
            }
                
            self.containerView.addSubview(videoView)
            NSLayoutConstraint.activate([
                videoView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
                videoView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
                videoView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
                videoView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
            ])
//        }
    }
}
