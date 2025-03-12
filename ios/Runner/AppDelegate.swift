import UIKit
import Flutter

@available(iOS 13.0, *)
@main
@objc class AppDelegate: FlutterAppDelegate {
    private var webRTCClient: WebRTCClient!
    var arCameraView: ArCameraView!
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        // WebRTCClient 초기화
        UIApplication.shared.isIdleTimerDisabled = true // 앱 켜져있을때 화면잠김 방지
        webRTCClient = WebRTCClient()
        // NativeVie??wPlugin 등록
        
        if let controller = window?.rootViewController as? FlutterViewController {
            // NT to FL 메시지 전달 채널
            webRTCClient.setMethodChannel(FlutterMethodChannel(name: "FlutterFuncCall", binaryMessenger: controller.binaryMessenger))
            
            // FL to NT 메시지 전달 채널
            let channel = FlutterMethodChannel(name: "NativeFuncCall", binaryMessenger: controller.binaryMessenger)
            channel.setMethodCallHandler { [weak self] (methodCall: FlutterMethodCall, result: @escaping FlutterResult) in
                guard let self = self else { return }
                // Flutter코드에서 명시된 호출명 구분
                switch methodCall.method {
                case "connectWebRTC":
                    if let args = methodCall.arguments as? [String: Any],
                       let roomKey = args["roomKey"] as? Int,
                       let userKey = args["userKey"] as? Int,
                       let userName = args["userName"] as? String
                    {
                        self.webRTCClient.onConnectionCompleted = {
                            result("OK")
                        }
                        self.webRTCClient.connectWebRTC(
                            roomKey: roomKey,
                            userKey: userKey,
                            userName: userName
                        )
                    }
                    break;
                case "disconnectWebRTC":
                    self.webRTCClient.disconnectWebRTC()
                    break;
                case "audio":
                    self.webRTCClient.audioChange()
                    break;
                case "video":
                    self.webRTCClient.videoChange()
                    break;
                case "oppAudioSet":
                    if let data = methodCall.arguments as? Int {
                        self.webRTCClient.oppAudioSet(userKey: data)
                    }
                    break;
                case "oppVideoSet":
                    if let data = methodCall.arguments as? Int {
                        self.webRTCClient.oppVideoSet(userKey: data)
                    }
                    break;
                case "mainCameraDispose":
                    self.arCameraView.dispose()
                    break;
                default :
                    result(FlutterMethodNotImplemented)
                }
                
            }
            
            // NT UI
            let arCameraFactory = ArCameraFactory(messenger: controller.binaryMessenger, webRTCClient: webRTCClient, appDelegate: self)
            registrar(forPlugin: "ArCameraView")?.register(arCameraFactory, withId: "ArCameraView")
            let webRTCViewFactory = WebRTCViewFactory(messenger: controller.binaryMessenger, webRTCClient: webRTCClient)
            registrar(forPlugin: "WebRTCViewMe")?.register(webRTCViewFactory, withId: "WebRTCViewMe")
            let factory2 = WebRTCViewFactory(messenger: controller.binaryMessenger, webRTCClient: webRTCClient)
            registrar(forPlugin: "WebRTCView0")?.register(factory2, withId: "WebRTCView0")
            let factory3 = WebRTCViewFactory(messenger: controller.binaryMessenger, webRTCClient: webRTCClient)
            registrar(forPlugin: "WebRTCView1")?.register(factory3, withId: "WebRTCView1")
            let factory4 = WebRTCViewFactory(messenger: controller.binaryMessenger, webRTCClient: webRTCClient)
            registrar(forPlugin: "WebRTCView2")?.register(factory4, withId: "WebRTCView2")
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
