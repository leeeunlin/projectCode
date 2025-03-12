import 'package:rayo/controller/chat_ctl.dart';
import 'package:rayo/utils/import_index.dart';

class LoginCtl {
  static final LoginCtl _instance = LoginCtl._internal();
  factory LoginCtl() {
    return _instance;
  }
  LoginCtl._internal();
  static LoginCtl get instance => _instance;

  bool camPer = false;
  bool micPer = false;
  String errorVal = '';
  Timer? timer;
  ValueNotifier<int> expireTime = ValueNotifier<int>(0);
  ValueNotifier<bool> loadingVal = ValueNotifier<bool>(false);
  String firebaseUid = '';
  late SharedPreferences prefs;
  late PackageInfo appInfo;

  ValueNotifier<bool> loginSuccess = ValueNotifier<bool>(false);
  UserModel user = UserModel.fromJson({});

  Future<void> init() async {
    appInfo = await PackageInfo.fromPlatform();
    prefs = await SharedPreferences.getInstance();
    camPer = await Permission.camera.request().isGranted;
    micPer = await Permission.microphone.request().isGranted;

    String refTk = prefs.getString('refTK') ?? '';
    if (refTk != '') {
      String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      final Map<String, dynamic> resbody = await API.put(
          uri: URI_userme, data: jsonEncode({DB_fcmToken: fcmToken}));
      if (resbody[statusCode] == 200) {
        user = UserModel.fromJson(resbody[data]);
        await ChatCtl.instance.init();
        loginSuccess.value = true;
      }
      // }
      // await forceAppUpdate();
    } else {
      loginSuccess.value = true;
    }
  }

  void timerStart({required int time}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      expireTime.value = time;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (expireTime.value > 0) {
        expireTime.value--;
      } else {
        timer!.cancel();
      }
    });
  }

  Future<void> numberAuth({
    required BuildContext context,
    required String countryCode,
    required String phoneNum,
    required bool retry,
    required bool modify,
  }) async {
    loadingVal.value = true;
    await FirebaseAuth.instance.setLanguageCode(context.locale.languageCode);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '$countryCode$phoneNum',
      timeout: const Duration(seconds: 0),
      verificationCompleted: (PhoneAuthCredential credential) {},
      codeAutoRetrievalTimeout: (String verificationId) {
        // 안드로이드에서만 동작 사용안함
      },
      verificationFailed: (FirebaseAuthException e) async {
        await durationPopup(context, rejectPopup(context));
        loadingVal.value = false;
        errorVal = e.code;
      },
      codeSent: (String verificationId, int? resendToken) async {
        loadingVal.value = false;
        errorVal = '';
        await durationPopup(
            context, defaultAlertDalog(context, 'sendcode'.tr()));
        if (!retry) {
          if (context.mounted) {
            Navigator.pushNamed(context, NAV_LoginNumberVerifyPage, arguments: {
              'countryCode': countryCode,
              'phoneNum': phoneNum,
              'verificationId': verificationId,
              'modify': modify
            });
          }
        }
      },
    );
  }

  Future<void> numberSignIn({
    required BuildContext context,
    required String verificationId,
    required String smsCode,
    required bool modify,
  }) async {
    loadingVal.value = true;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      firebaseUid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseAuth.instance.signOut();
      // 내정보에서 휴대폰번호 변경 시
      if (modify) {
        final Map<String, dynamic> resbody = await API.put(
            uri: URI_userme,
            data: jsonEncode({'uid': firebaseUid}),
            returnControl: true);
        // = await API.
        if (resbody[statusCode] == 200) {
          LoginCtl.instance.user = UserModel.fromJson(resbody[data]);
          if (context.mounted) {
            await durationPopup(
                context, defaultAlertDalog(context, 'verifycompleted'.tr()));
          }
          if (context.mounted) {
            Navigator.popUntil(
                context, ModalRoute.withName(NAV_ProfileSettingPage));
          }
        }
      } else {
        // 로그인 시 휴대폰번호 인증
        final Map<String, dynamic> resbody = await API.post(
            uri: URI_userlogin,
            data: jsonEncode({'uid': firebaseUid}),
            returnControl: true);
        if (resbody[statusCode] == 401 || resbody[statusCode] == 200) {
          if (context.mounted) {
            await durationPopup(
                context, defaultAlertDalog(context, 'verifycompleted'.tr()));
          }
          if (resbody[statusCode] == 401) {
            // 최초 로그인의 경우
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, NAV_LoginBirthPage,
                  (route) => route.settings.name == NAV_Root);
            }
          }
          if (resbody[statusCode] == 200) {
            // 등록된 번호가 있는 경우
            if (context.mounted) {
              checkLoginData(context);
            }
          }
        }
      }
      loadingVal.value = false;
    } on FirebaseAuthException catch (e) {
      loadingVal.value = false;
      errorVal = e.code;
    }
  }

  Future<void> mailAuth(
      {required BuildContext context,
      required String mail,
      required bool retry,
      required bool modify}) async {
    // modify가 false일 경우 로그인 true일 경우 이메일등록
    loadingVal.value = true;
    final Map<String, dynamic> resbody = await API.get(
        uri: URI_authEmailsend,
        query:
            modify ? {'type': 'register', 'email': mail} : {'type': 'login'});
    if (resbody[statusCode] == 200) {
      if (context.mounted) {
        await durationPopup(
            context, defaultAlertDalog(context, 'sendcode'.tr()));
      }
      if (!retry) {
        if (context.mounted) {
          Navigator.pushNamed(context, NAV_LoginMailVerifyPage,
              arguments: {'mail': mail, 'modify': modify});
        }
      }
    }
    loadingVal.value = false;
  }

  Future<void> mailSignIn(
      {required BuildContext context,
      required String mail,
      required String verifycode,
      required bool modify}) async {
    loadingVal.value = true;
    final Map<String, dynamic> resbody = await API.get(
        uri: URI_authEmailvalidate,
        query: {'type': modify ? 'register' : 'login', 'key': verifycode});
    if (resbody[statusCode] == 200 && resbody[data]['result']) {
      if (context.mounted) {
        await durationPopup(
            context, defaultAlertDalog(context, 'verifycompleted'.tr()));
      }
      await init();
      if (modify) {
        if (context.mounted) {
          Navigator.popUntil(
              context, ModalRoute.withName(NAV_ProfileSettingPage));
        }
      } else {
        if (context.mounted) {
          Navigator.popUntil(context, ModalRoute.withName(NAV_Root));
        }
      }
    } else {
      errorVal = 'invalid-verification-code';
    }
    loadingVal.value = false;
  }

  void checkLoginData(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isDismissible: false,
        builder: (_) => Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  height: 92,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 6,
                        width: 64,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: black[40],
                        ),
                      ),
                      Container(
                        height: 70,
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          'numberRegistered'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 19 / 16,
                            color: black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: black[40]!, width: 0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text('willBeDeleted'.tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                height: 18 / 12,
                                color: black)),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: 15,
                              child: SvgPicture.asset(
                                SvgIcon.ICON_bang,
                                width: 12,
                                height: 12,
                                theme: SvgTheme(currentColor: mint[2]!),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                'sameNumberDeleted'.tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    height: 18 / 12,
                                    color: mint[2]),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context); // 하단 바텀 시트 닫기
                            await LoginCtl.instance.mailAuth(
                                context: context,
                                mail: '',
                                retry: true,
                                modify: false);
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  NAV_LoginMailVerifyPage,
                                  (route) => route.settings.name == NAV_Root);
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: yellow),
                              width: double.infinity,
                              padding: const EdgeInsets.all(12.5),
                              child: Text(
                                'verifyEmail'.tr(),
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 16.71 / 14,
                                    fontWeight: FontWeight.w600,
                                    color: black),
                              )),
                        ),
                        SizedBox(height: 14),
                        InkWell(
                          onTap: () async {
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  NAV_LoginBirthPage,
                                  (route) => route.settings.name == NAV_Root);
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: white[80]),
                              width: double.infinity,
                              padding: const EdgeInsets.all(12.5),
                              child: Text(
                                'registerNewAccount'.tr(),
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 16.71 / 14,
                                    fontWeight: FontWeight.w600,
                                    color: black),
                              )),
                        )
                      ],
                    ))
              ],
            )));
  }

  Future<void> createAuth(BuildContext context,
      {required List<int> profileImg}) async {
    Map<String, dynamic> createUser = user.toJson();
    createUser['uid'] = firebaseUid;
    createUser['fcmToken'] = await FirebaseMessaging.instance.getToken();
    List<MultipartFile> imageDataList =
        await convertMultipartFiles([profileImg]);
    final Map<String, dynamic> resbody = await API.post(
        uri: URI_user,
        data: jsonEncode(createUser),
        imageDataList: imageDataList[0].length == 0 ? [] : imageDataList);
    if (resbody[statusCode] == 200) {
      user = UserModel.fromJson(resbody[data]);
      firebaseUid = '';
      if (context.mounted) {
        Navigator.pushNamed(context, NAV_LoginFinishPage);
      }
    }
    if (resbody[statusCode] == 422) {
      errorVal = resbody['message'];
    }
  }

  Future<void> logOut({bool accountClose = false}) async {
    if (appStateKey.currentState != null) {
      appStateKey.currentState!.allPageClose();
    }
    user = UserModel.fromJson({});
    prefs.remove('refTK');
    await ChatCtl.instance.dispose();
    loginSuccess.value = false;
    if (!accountClose) {
      await API.get(uri: URI_userlogout);
    }
  }

  Future<void> accountClose({required int idx, required String detail}) async {
    logOut(accountClose: true);
    await API.delete(
        uri: URI_user, data: jsonEncode({'code': idx, 'detail': detail}));
  }

  Future<void> loginSuccessPage(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    await ChatCtl.instance.init();
    if (context.mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
    loginSuccess.value = true;
  }
}
