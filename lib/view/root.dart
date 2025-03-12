import 'package:rayo/utils/import_index.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _Root();
}

class _Root extends State<Root> {
  bool appLoading = false;
  bool _permission = false;
  bool arAvailable = Platform.isIOS;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      // TODO :: 안드로이드 롤백
      // MethodChannel('AndroidFlutterFuncCall').setMethodCallHandler(
      //   (MethodCall call) async {
      //     switch (call.method) {
      //       case 'arAvailable':
      //         arAvailable = true;
      //         setState(() {});
      //         break;
      //     }
      //   },
      // );
    }
    LoginCtl.instance.init().then((_) {
      appLoading = true;
      _permission = LoginCtl.instance.camPer && LoginCtl.instance.micPer;
      if (!_permission) {
        if (scaffoldKey.currentContext!.mounted) {
          permissionReq(scaffoldKey.currentContext!);
        }
      }
      setState(() {});
    });
    InAppPurchaseCtl.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    Stack perScreen() {
      return Stack(alignment: Alignment.center, children: [
        Positioned.fill(
          child: Container(
            color: yellow,
          ),
        ),
        Positioned(
          top: 100,
          child: Container(
            alignment: Alignment.center,
            height: 130,
            child: SvgPicture.asset(SvgIcon.ICON_titleRayo),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
              alignment: Alignment.bottomRight,
              height: 509,
              child: Image.asset(
                PngIcon.ICON_rayoImg,
                fit: BoxFit.fitHeight,
              )),
        ),
        if (!appLoading)
          Positioned(
              width: 35,
              height: 35,
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ))
      ]);
    }

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        alignment: Alignment.center,
        children: [
          perScreen(),
          // if (arAvailable)
          AnimatedOpacity(
              opacity: _permission ? 1 : 0,
              duration: Duration(seconds: 1),
              child: ValueListenableBuilder<bool>(
                valueListenable: LoginCtl.instance.loginSuccess,
                builder: (_, login, child) => login
                    ? App(
                        key: appStateKey,
                      )
                    : const LoginPage(),
              ))
        ],
      ),
    );

    // !appLoading
    //     ? perScreen(context)
    //     : AnimatedOpacity(
    //         opacity: _isVisible ? 1 : 0,
    //         duration: Duration(seconds: 2),
    //         child: ValueListenableBuilder<bool>(
    //           valueListenable: LoginCtl.instance.perOK,
    //           builder: (_, per, child) => per
    //               ? ValueListenableBuilder<bool>(
    //                   valueListenable: LoginCtl.instance.loginSuccess,
    //                   builder: (_, login, child) =>
    //                       login ? App() : const LoginPage(),
    //                 )
    //               : perScreen(context),
    //         ),
    //       );
  }
}

void permissionReq(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('권한동의해주세여'),
            actions: [
              InkWell(
                  onTap: () {
                    openAppSettings();
                  },
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    color: Colors.blue,
                  ))
            ],
          ));
}
