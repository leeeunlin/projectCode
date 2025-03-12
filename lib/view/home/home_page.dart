import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rayo/db/hive_db.dart';
import 'package:rayo/db/model/hive_room_model.dart';
import 'package:rayo/utils/import_index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int genderFilter = 0;
  double verticalPosition = 0.0;
  double imageHeight = 0.0;
  double defaultPosition = 0.0;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      imageHeight = MediaQuery.of(context).size.width * 0.7 / 24 * 35;
      setState(() {
        defaultPosition =
            (MediaQuery.of(context).size.height / 2) - (imageHeight / 2);
        verticalPosition =
            (MediaQuery.of(context).size.height / 2) - (imageHeight / 2);
      });
    });
  }

  void resetswipe() => setState(() {
        verticalPosition = defaultPosition;
        loading = false;
      });

  void genderFilterTap() {
    if (genderFilter == 2) {
      genderFilter = 0;
    } else {
      genderFilter++;
    }

    setState(() {});
  }

  List<String> filterGender = [
    PngIcon.ICON_all_gender,
    PngIcon.ICON_female_gender,
    PngIcon.ICON_male_gender,
  ];
  List<String> filterAge = [PngIcon.ICON_ageAll, PngIcon.ICON_ageSimilar];

  @override
  Widget build(context) {
    Future<bool> cloudAlert(int calcCloud) async {
      bool value = false;
      await showDialog(
          context: context,
          builder: (context1) => AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: Container(
                  decoration: BoxDecoration(
                    color: mint,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        PngIcon.ICON_joinCloud,
                        width: 200,
                        height: 108,
                      ),
                      Text(
                        'genderselectedClouds'.tr(
                            namedArgs: {'cloudCount': calcCloud.toString()}),
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 24 / 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Container(
                          height: 63,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.pop(context1);
                                    if (LoginCtl.instance.user.point.value >=
                                        calcCloud) {
                                      value = true;
                                    } else {
                                      if (context.mounted) {
                                        InAppPurchaseCtl.instance
                                            .needCloud(context);
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(15),
                                    height: 23,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          PngIcon.ICON_cloud,
                                          width: 23,
                                          height: 23,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        SizedBox(
                                          height: 23,
                                          child: Text(
                                            calcCloud.toString(),
                                            style: TextStyle(
                                              fontFamily: 'MCMerchant',
                                              fontSize: 12,
                                              height: 19.2 / 12,
                                              fontWeight: FontWeight.w400,
                                              color: black[60],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        SizedBox(
                                          height: 23,
                                          child: Text(
                                            'usage'.tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                height: 19 / 16,
                                                color: mint[2]),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                width: 0.25,
                                color: black[40],
                              ),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.pop(context1);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'cancel'.tr(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          height: 19.09 / 16,
                                          fontWeight: FontWeight.w600,
                                          color: black[60],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ))
                    ],
                  ))));
      return value;
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SafeArea(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Container(
                                  width: 53,
                                  height: 62,
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: black[120]),
                                  child: Image.asset(PngIcon.ICON_near)),
                              InkWell(
                                onTap: () {
                                  genderFilterTap();
                                },
                                child: Container(
                                    width: 53,
                                    height: 62,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: black[120]),
                                    child: Image.asset(
                                        filterGender[genderFilter])),
                              ),
                              Container(
                                  width: 53,
                                  height: 62,
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: black[120]),
                                  child: Image.asset(filterAge[1])),
                              // TODO :: 언어설정 함수부분 차후 컨트롤러로 이동
                              InkWell(
                                onTap: () async {
                                  Locale currentLocale =
                                      Localizations.localeOf(context);
                                  switch (currentLocale.languageCode) {
                                    case 'ko':
                                      context.setLocale(Locale('ar'));
                                      break;
                                    case 'ar':
                                      context.setLocale(Locale('de'));
                                      break;
                                    case 'de':
                                      context.setLocale(Locale('en'));
                                      break;
                                    case 'en':
                                      context.setLocale(Locale('es'));
                                      break;
                                    case 'es':
                                      context.setLocale(Locale('fr'));
                                      break;
                                    case 'fr':
                                      context.setLocale(Locale('ja'));
                                      break;
                                    default:
                                      context.setLocale(Locale('ko'));
                                      break;
                                  }
                                  await forceAppUpdate();
                                },
                                child: Container(
                                    width: 114,
                                    height: 62,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: black[120]),
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.yellow,
                                      child: Text(
                                        'LocaleSet : ${Localizations.localeOf(context).languageCode.toUpperCase()}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TestPage()));
                                  // UserModel user = UserModel.fromJson({});
                                  // user.seq = 123;
                                  // user.name = '123유저';

                                  // LoginCtl.instance.user = user;
                                  // snackBar(content: '${user.seq} 유저로 적용하였습니다.');
                                  // forceAppUpdate();
                                },
                                child: Container(
                                    width: 53,
                                    height: 62,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: black[120]),
                                    child: Text('테스트페이지 이동')),
                              ),

                              InkWell(
                                onTap: () {
                                  UserModel user = UserModel.fromJson({});
                                  user.seq = 456;
                                  user.name = '456유저';

                                  LoginCtl.instance.user = user;
                                  snackBar(content: '${user.seq} 유저로 적용하였습니다.');
                                  forceAppUpdate();
                                },
                                child: Container(
                                    width: 53,
                                    height: 62,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: black[120]),
                                    child: Text('456\nUser Set')),
                              ),
                              InkWell(
                                onTap: () {
                                  UserModel user = UserModel.fromJson({});
                                  user.seq = 789;
                                  user.name = '789유저';

                                  LoginCtl.instance.user = user;
                                  snackBar(content: '${user.seq} 유저로 적용하였습니다.');
                                  forceAppUpdate();
                                },
                                child: Container(
                                    width: 53,
                                    height: 62,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: black[120]),
                                    child: Text('789\nUser Set')),
                              ),
                              InkWell(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection('chat')
                                      .get()
                                      .then((value) async {
                                    for (var v in value.docs) {
                                      await v.reference.delete();
                                    }
                                  });
                                  await FirebaseFirestore.instance
                                      .collectionGroup(
                                          'chatSocket') // chatSocket
                                      .get()
                                      .then((value) async {
                                    for (var v in value.docs) {
                                      await v.reference.delete();
                                    }
                                  });
                                },
                                child: Container(
                                    width: 53,
                                    height: 62,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: black[120]),
                                    child: Text('chat DB delete')),
                              ),
                              Container(
                                width: 200,
                                height: 350,
                                child: AndroidView(
                                  viewType: 'WebRTCViewMe',
                                  creationParams: LoginCtl.instance.user.seq,
                                  creationParamsCodec: StandardMessageCodec(),
                                ),
                              )
                            ]),
                      ),
                      Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: black[120]),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ValueListenableBuilder(
                                  valueListenable: HiveDB.instance.roomBox,
                                  builder: (_, roomBox, child) {
                                    List<HiveRoomModel> room =
                                        HiveDB.instance.sortRoom();
                                    bool showBadge = false;
                                    for (HiveRoomModel e in room) {
                                      if (e.unreadCount != 0) {
                                        showBadge = true;
                                      }
                                    }
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, NAV_ChatListPage);
                                      },
                                      child: Badge(
                                        smallSize: 8,
                                        backgroundColor: mint,
                                        isLabelVisible: showBadge,
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: 30,
                                            height: 30,
                                            child: Image.asset(
                                              PngIcon.ICON_message,
                                              width: 28,
                                              height: 28,
                                            )),
                                      ),
                                    );
                                  }),
                              SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, NAV_HomeAlertPage);
                                },
                                child: Badge(
                                  smallSize: 8,
                                  backgroundColor: mint,
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(PngIcon.ICON_alarm)),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                  width: 36, height: 36, child: CloudWidget())
                            ],
                          ))
                    ],
                  ))),
          if (loading)
            Positioned.fill(child: Image.asset(PngIcon.ICON_lightningEffect)),
          AnimatedPositioned(
            duration: Duration(milliseconds: 80),
            bottom: verticalPosition,
            child: GestureDetector(
              onVerticalDragUpdate: (details) => setState(() {
                verticalPosition -= details.delta.dy;
                if (verticalPosition >= defaultPosition) {
                  verticalPosition = defaultPosition;
                }
              }),
              onVerticalDragEnd: (details) async {
                if (verticalPosition < MediaQuery.of(context).size.height / 8) {
                  int calcCloud = 0;
                  if (genderFilter != 0) {
                    calcCloud += 11;
                    bool value = await cloudAlert(calcCloud);
                    if (!value) {
                      resetswipe();
                      return;
                    }
                  }
                  appStateKey.currentState!.setState(() {
                    appStateKey.currentState!.hidden = true;
                  });
                  verticalPosition = -imageHeight;
                  loading = true;
                  LoginCtl.instance.user.point.value -= calcCloud;

                  RoomModel roomModel = RoomModel.fromJson({
                    'seq': 11111,
                    'name': '테스트1111번 모델',
                    'location': '서울',
                    'date': DateTime.now().millisecondsSinceEpoch,
                    'master': {
                      'seq': 1111,
                      'name': '1111번방장',
                      'gender': Random().nextInt(2) + 1,
                      'birth': 1990,
                      'profileImg':
                          'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
                    },
                    'memberCount': 4,
                    'memberLimit': 4,
                    'completed': Random().nextBool(),
                    'roomCat': {
                      'food': Random().nextBool(),
                      'amity': Random().nextBool(),
                      'art': Random().nextBool(),
                      'exercise': Random().nextBool(),
                      'gender': genderFilter,
                      'near': 0,
                    }
                  });
                  String? joinValue =
                      await const MethodChannel('NativeFuncCall')
                          .invokeMethod<String>('connectWebRTC', {
                    'roomKey': roomModel.seq,
                    'userKey': LoginCtl.instance.user.seq,
                    'userName': LoginCtl.instance.user.name
                  });

                  await Future.delayed(Duration(milliseconds: 500));
                  if (joinValue == 'OK' && context.mounted) {
                    // 안드로이드 이동이 빨라 먼저 카메라 디스포즈 처리 후 이동 필요함
                    MethodChannel('NativeFuncCall')
                        .invokeMethod<String>('mainCameraDispose');
                    Navigator.pushNamed(context, NAV_VideoCallPage, arguments: {
                      'roomModel': roomModel,
                    }).then((_) {
                      resetswipe();
                    });
                  }
                } else {
                  resetswipe();
                }
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7 / 24 * 35,
                child: Image.asset(
                  PngIcon.ICON_swipedown,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TestPage extends StatelessWidget {
  TestPage({Key? key}) : super(key: key);
  @override
  Widget build(context) => Container();
}
