import 'package:rayo/utils/import_index.dart';

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  static double systemBarHeight = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Platform.isAndroid) {
      if (MediaQuery.of(context).systemGestureInsets.collapsedSize.width == 0 &&
          systemBarHeight == 0.0) {
        systemBarHeight = MediaQuery.of(context).padding.bottom;
      } else {
        if (systemBarHeight == 0.0) {
          systemBarHeight = 10;
        }
      }
    } else {
      systemBarHeight = 10;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  static int _currentIndex = 0;
  static List<int> _tapHistory = [0];
  bool hidden = false;
  BuildContext currentContext() {
    return navigatorKeyList[_currentIndex].currentState!.context;
  }

  void allPageClose() {
    _currentIndex = 0;
    _tapHistory = [0];
    for (int i = 0; i < navigatorKeyList.length; i++) {
      if (navigatorKeyList[i].currentState != null) {
        navigatorKeyList[i].currentState!.popUntil((route) => route.isFirst);
      }
    }
  }

  void idx2toLast() {
    hidden = false;
    _tapChange(_tapHistory[_tapHistory.length - 2]);
  }

  void goTohome() {
    hidden = false;
    _tapChange(0);
  }

  void _tapChange(int index) {
    if (index == 0 && !navigatorKeyList[index].currentState!.canPop()) {
      mainCamera = true;
    } else {
      if (mainCamera) {
        // TODO : android 카메라 UI 종료하는 method
        // MethodChannel('NativeFuncCall')
        //     .invokeMethod<String>('mainCameraDispose');
        mainCamera = false;
      }
    }
    if (index == 2) {
      hidden = true;
      recruitPageStateKey.currentState!.init();
    }

    if (_currentIndex == index) {
      navigatorKeyList[_currentIndex]
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      // _pageController.jumpToPage(index);
      _currentIndex = index;
      if (_tapHistory.contains(index)) {
        _tapHistory.remove(index);
      }
      _tapHistory.add(index);
    }
    setState(() {});
  }

  void layoutRefresh(String? routeName) {
    if (_currentIndex != 0) {
      if (mainCamera) {
        MethodChannel('NativeFuncCall')
            .invokeMethod<String>('mainCameraDispose');
        mainCamera = false;
        setState(() {});
      }
    }
    if (_currentIndex == 0 && !navigatorKeyList[0].currentState!.canPop()) {
      if (!mainCamera) {
        mainCamera = true;
        setState(() {});
      }
    } else {
      if (mainCamera) {
        MethodChannel('NativeFuncCall')
            .invokeMethod<String>('mainCameraDispose');
        mainCamera = false;
        setState(() {});
      }
    }
    if (_currentIndex == 2) {
      hidden = true;
      setState(() {});
    } else {
      if (routeName != '') {
        if (hiddenRoutes.contains(routeName)) {
          if (!hidden) {
            hidden = true;
            setState(() {});
          }
        } else {
          if (hidden) {
            hidden = false;
            setState(() {});
          }
        }
      }
    }
  }

  static List<GlobalKey<NavigatorState>> navigatorKeyList = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  final List<String> _bottomIcon = [
    SvgIcon.ICON_bottomHome,
    SvgIcon.ICON_bottomSearch,
    SvgIcon.ICON_bottomRecruit,
    SvgIcon.ICON_bottomReview,
    SvgIcon.ICON_bottomProfile,
  ];

  bool mainCamera = true;

  @override
  Widget build(BuildContext context) {
    InkWell navBtn(int idx) {
      return InkWell(
        onTap: () async {
          _tapChange(idx);
        },
        child: SizedBox(
            width: 34,
            height: 34,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  _bottomIcon[idx],
                  theme: SvgTheme(
                      currentColor: idx == 4 && _tapHistory.last == idx
                          ? const Color(0xFF3C3C46)
                          : _currentIndex == idx
                              ? yellow
                              : white),
                ),
                if (idx == 4 && LoginCtl.instance.user.profileImg != '')
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  '$cdnUri${LoginCtl.instance.user.profileImg}'),
                              fit: BoxFit.cover)),
                    ),
                  )
              ],
            )),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        p(_tapHistory);
        if (Platform.isAndroid) {
          if (navigatorKeyList[_currentIndex].currentState!.canPop()) {
            navigatorKeyList[_currentIndex].currentState!.pop();
          } else {
            _tapHistory.removeLast();
            if (_tapHistory.isEmpty && _currentIndex != 0) {
              _tapChange(0);
            } else if (_tapHistory.isEmpty && _currentIndex == 0) {
              SystemNavigator.pop();
            } else {
              if (_currentIndex == 2) {
                hidden = false;
              }
              _tapChange(_tapHistory.last);
            }
          }
          p(_tapHistory);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(children: [
            Positioned.fill(
                child: Container(
              color: black[80],
            )),
            if (mainCamera)
              CameraStreamWidget(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            IndexedStack(
              index: _currentIndex,
              children: [
                Navigator(
                  key: navigatorKeyList[0],
                  observers: [
                    MyNavigatorObserver((route) {
                      layoutRefresh(route);
                    })
                  ],
                  initialRoute: NAV_HomePage,
                  onGenerateRoute: (settings) => routeFunc(settings),
                ),
                Navigator(
                  key: navigatorKeyList[1],
                  observers: [
                    MyNavigatorObserver((route) {
                      layoutRefresh(route);
                    })
                  ],
                  initialRoute: NAV_SearchPage,
                  onGenerateRoute: (settings) => routeFunc(settings),
                ),
                Navigator(
                  key: navigatorKeyList[2],
                  observers: [
                    MyNavigatorObserver((route) {
                      layoutRefresh(route);
                    })
                  ],
                  initialRoute: NAV_RecruitPage,
                  onGenerateRoute: (settings) => routeFunc(settings),
                ),
                Navigator(
                  key: navigatorKeyList[3],
                  observers: [
                    MyNavigatorObserver((route) {
                      layoutRefresh(route);
                    })
                  ],
                  initialRoute: NAV_ReviewListPage,
                  onGenerateRoute: (settings) => routeFunc(settings),
                ),
                Navigator(
                  key: navigatorKeyList[4],
                  observers: [
                    MyNavigatorObserver((route) {
                      layoutRefresh(route);
                    })
                  ],
                  initialRoute: NAV_ProfilePage,
                  onGenerateRoute: (settings) => routeFunc(settings),
                ),
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: 16,
              right: 16,
              bottom: hidden ? -100 : 10 + systemBarHeight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(51), // 20%(255*0.2)
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(6, 6),
                    ),
                  ],
                ),
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [for (int i = 0; i <= 4; i++) navBtn(i)],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  final Function(String) routeName;

  MyNavigatorObserver(this.routeName);

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    routeName(route.settings.name ?? '');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    routeName(previousRoute!.settings.name ?? '');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    routeName(previousRoute!.settings.name ?? '');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    routeName(newRoute!.settings.name ?? '');
  }
}
