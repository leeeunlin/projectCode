package com.mooncorporation.rayo

import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
    private lateinit var webRTCClient: WebRTCClient
    lateinit var arCameraView: ArCameraView
    private var creationParams: Map<String, Any>? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        // WebRTCClient 초기화
        webRTCClient = WebRTCClient(this)
        MethodChannel(flutterEngine.dartExecutor, "NativeFuncCall").setMethodCallHandler { methodCall, result ->
            // Flutter코드에서 명시된 호출명 구분
            when (methodCall.method) {
                "connectWebRTC" -> {
                    Log.d("MethodChannel", "connectWebRTC")
                    if (methodCall.arguments is Map<*, *>) {
                        val args = methodCall.arguments as Map<String, Any>
                        val roomKey = args["roomKey"] as? Int
                        val userKey = args["userKey"] as? Int
                        val userName = args["userName"] as? String

                        if (roomKey != null && userKey != null && userName != null) {
                            webRTCClient.onConnectionCompleted = {
                                result.success("OK")
                            }
                            webRTCClient.connectWebRTC(roomKey, userKey, userName)
                        }
                    }
                }
                "disconnectWebRTC" -> {
                    Log.d("MethodChannel", "disconnectWebRTC")
                    webRTCClient.disconnectWebRTC()
                }
                "audio" -> {
                    Log.d("MethodChannel", "audio")
//                    webRTCClient?.audioChange()
                }
                "video" -> {
                    Log.d("MethodChannel", "video")
//                    webRTCClient?.videoChange()
                }
                "oppAudioSet" -> {
                    Log.d("MethodChannel", "oppAudioSet")
//                    (methodCall.arguments as? Int)?.let {
//                        webRTCClient?.oppAudioSet(userKey = it)
//                    }
                }
                "oppVideoSet" -> {
                    Log.d("MethodChannel", "oppVideoSet")
//                    (methodCall.arguments as? Int)?.let {
//                        webRTCClient?.oppVideoSet(userKey = it)
//                    }
                }
                "mainCameraDispose" -> {
                    Log.d("MethodChannel", "mainCameraDispose")
                    arCameraView.dispose()
                }
                else -> result.notImplemented()
            }
        }

        // NT UI
        val arCameraFactory = ArCameraFactory(webRTCClient, creationParams, this  )
        flutterEngine.platformViewsController.registry.registerViewFactory("ArCameraView", arCameraFactory)
        val webRTCViewFactory = WebRTCViewFactory(webRTCClient)
        flutterEngine.platformViewsController.registry.registerViewFactory("WebRTCViewMe", webRTCViewFactory)
        val factory2 = WebRTCViewFactory(webRTCClient)
        flutterEngine.platformViewsController.registry.registerViewFactory("WebRTCView0", factory2)
        val factory3 = WebRTCViewFactory(webRTCClient)
        flutterEngine.platformViewsController.registry.registerViewFactory("WebRTCView1", factory3)
        val factory4 = WebRTCViewFactory(webRTCClient)
        flutterEngine.platformViewsController.registry.registerViewFactory("WebRTCView2", factory4)
    }
//        private fun arCheck(): Boolean {
//        return ArCoreApk.getInstance().requestInstall(this, true) == ArCoreApk.InstallStatus.INSTALLED
//    }
}


//package com.mooncorporation.rayo
//
//import android.util.Log
//import com.google.ar.core.ArCoreApk
//import io.flutter.embedding.android.FlutterFragmentActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//import io.flutter.plugins.GeneratedPluginRegistrant
//
//class MainActivity : FlutterFragmentActivity() {
//    var arCameraView: ArCameraView? = null
//    private var webRTCClient: WebRTCClient? = null
//    private var androidMethodChannel: MethodChannel? = null
//
//    override fun onResume() {
//        super.onResume()
//        if (arCheck()) {
//            androidMethodChannel?.invokeMethod("arAvailable", null)
//        }
//    }
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        webRTCClient = WebRTCClient(this)
//        webRTCClient?.setMethodChannel(MethodChannel(flutterEngine.dartExecutor, "FlutterFuncCall"))
//        if (arCheck()){
//            androidMethodChannel = MethodChannel(flutterEngine.dartExecutor, "AndroidFlutterFuncCall")
//            androidMethodChannel?.invokeMethod("arAvailable", null)
//        }
//
//        // FL to NT 메시지 전달 채널
//        MethodChannel(flutterEngine.dartExecutor, "NativeFuncCall").setMethodCallHandler { methodCall, result ->
//            // Flutter코드에서 명시된 호출명 구분
//            when (methodCall.method) {
//                "connectWebRTC" -> {
//                    Log.d("MethodChannel", "connectWebRTC")
//                    if (methodCall.arguments is Map<*, *>) {
//                        val args = methodCall.arguments as Map<String, Any>
//                        val roomKey = args["roomKey"] as? Int
//                        val userKey = args["userKey"] as? Int
//                        val userName = args["userName"] as? String
//
//                        if (roomKey != null && userKey != null && userName != null) {
//                            webRTCClient?.onConnectionCompleted = {
//                                result.success("OK")
//                            }
//                            webRTCClient?.connectWebRTC(roomKey, userKey, userName)
//                        }
//                    }
//                }
//                "disconnectWebRTC" -> {
//                    Log.d("MethodChannel", "disconnectWebRTC")
//                    webRTCClient?.disconnectWebRTC()
//                }
//                "audio" -> {
//                    Log.d("MethodChannel", "audio")
//                    webRTCClient?.audioChange()
//                }
//                "video" -> {
//                    Log.d("MethodChannel", "video")
//                    webRTCClient?.videoChange()
//                }
//                "oppAudioSet" -> {
//                    Log.d("MethodChannel", "oppAudioSet")
//                    (methodCall.arguments as? Int)?.let {
//                        webRTCClient?.oppAudioSet(userKey = it)
//                    }
//                }
//                "oppVideoSet" -> {
//                    Log.d("MethodChannel", "oppVideoSet")
//                    (methodCall.arguments as? Int)?.let {
//                        webRTCClient?.oppVideoSet(userKey = it)
//                    }
//                }
//                "mainCameraDispose" -> {
//                    Log.d("MethodChannel", "mainCameraDispose")
//                    arCameraView?.dispose()
//                }
//                else -> result.notImplemented()
//            }
//        }
//
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
//        flutterEngine.platformViewsController.registry.registerViewFactory(
//            "ArCameraView",
//            ArCameraFactory(this, flutterEngine.dartExecutor.binaryMessenger, webRTCClient!!)
//        )
//        flutterEngine.platformViewsController.registry.registerViewFactory(
//            "WebRTCViewMe",
//            WebRTCViewFactory(this, flutterEngine.dartExecutor.binaryMessenger, webRTCClient!!)
//        )
//        flutterEngine.platformViewsController.registry.registerViewFactory(
//            "WebRTCView0",
//            WebRTCViewFactory(this, flutterEngine.dartExecutor.binaryMessenger, webRTCClient!!)
//        )
//        flutterEngine.platformViewsController.registry.registerViewFactory(
//            "WebRTCView1",
//            WebRTCViewFactory(this, flutterEngine.dartExecutor.binaryMessenger, webRTCClient!!)
//        )
//        flutterEngine.platformViewsController.registry.registerViewFactory(
//            "WebRTCView2",
//            WebRTCViewFactory(this, flutterEngine.dartExecutor.binaryMessenger, webRTCClient!!)
//        )
//    }
//
//    private fun arCheck(): Boolean {
//        return ArCoreApk.getInstance().requestInstall(this, true) == ArCoreApk.InstallStatus.INSTALLED
//    }
//}