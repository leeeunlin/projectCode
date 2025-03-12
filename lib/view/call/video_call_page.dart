import 'package:rayo/utils/import_index.dart';

class VideoCallPage extends StatefulWidget {
  final RoomModel roomModel;

  const VideoCallPage({required this.roomModel, super.key});
  @override
  State<VideoCallPage> createState() => _VideoCallPage();
}

class _VideoCallPage extends State<VideoCallPage> with WidgetsBindingObserver {
  Map<int, UserModel> userList = <int, UserModel>{};
  Map<int, int> ntUIIdx = {0: 0, 1: 0, 2: 0};
  ValueNotifier<int> mainVideo = ValueNotifier<int>(LoginCtl.instance.user.seq);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // TODO : android native에서 flutter 로 함수호출 시 리슨되는 이벤트 처리
    MethodChannel('FlutterFuncCall').setMethodCallHandler(_handleMethodCall);
  }

  @override
  void dispose() {
    userList.clear();
    ntUIIdx.clear();
    WidgetsBinding.instance.removeObserver(this);
    // TODO : android webrtc disconnect
    MethodChannel('NativeFuncCall').invokeMethod<String>('disconnectWebRTC');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 전환될 때의 처리
      MethodChannel('NativeFuncCall').invokeMethod<String>('mainCameraDispose');
      Navigator.pop(context);
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      // TODO : android webrtc connection이 완료되었을 경우 해당 함수 호출하여 flutter 에 리스트 추가
      case 'NTtoFL_remoteViewer':
        final int userKey = call.arguments['userKey'];
        final String userName = call.arguments['userName'];
        userList[userKey] =
            UserModel.fromJson({DB_seq: userKey, DB_name: userName});
        widget.roomModel.memberCount++;
        // Map<int, int> ntUIIdx = {0: 0, 1: 0, 2: 0};
        // ntUIIdx에 0인 첫번째 value를 찾아 해당 value에 userKey 저장
        for (MapEntry<int, int> entry in ntUIIdx.entries) {
          if (entry.value == 0) {
            ntUIIdx[entry.key] = userKey;
            break;
          }
        }
        setState(() {});
        break;
      // TODO : android 유저가 나갔을 경우 flutter 쪽의 유저 리스트 삭제 처리하는 함수
      case 'exitUser':
        final int userKey = call.arguments;
        mainVideo.value = LoginCtl.instance.user.seq;
        userList.remove(userKey);
        // ntUIIdx에 나간 유저의 value를 찾아 해당 value에 userKey 저장
        widget.roomModel.memberCount--;
        for (MapEntry<int, int> entry in ntUIIdx.entries) {
          if (entry.value == userKey) {
            ntUIIdx[entry.key] = 0;
            break;
          }
        }
        setState(() {});
        break;
      default:
        throw MissingPluginException('Not implemented: ${call.method}');
    }
  }

  @override
  Widget build(context) {
    return ValueListenableBuilder<int>(
      valueListenable: mainVideo,
      builder: (context, mainVideoValue, child) => Stack(
        children: [
          CameraStreamWidget(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          if (mainVideo.value != LoginCtl.instance.user.seq)
            Builder(builder: (context) {
              return Positioned.fill(
                child: Platform.isAndroid
                    ?
                    // TODO :: 안드로이드 롤백
                    Container()
                    // AndroidView(
                    //     viewType:
                    //         'WebRTCView${userList.keys.toList().indexOf(mainVideo.value)}',
                    //     creationParams: mainVideo.value,
                    //     creationParamsCodec: StandardMessageCodec(),
                    //   )
                    : UiKitView(
                        viewType:
                            'WebRTCView${userList.keys.toList().indexOf(mainVideo.value)}',
                        creationParams: mainVideo.value,
                        creationParamsCodec: StandardMessageCodec(),
                      ),
              );
            }),
          Positioned(
              top: 66,
              left: 0,
              right: 0,
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 30,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (widget.roomModel.roomCat.food)
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: SearchCtl.instance.food
                                            ? mint[2]
                                            : black[120],
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          SvgIcon.ICON_food,
                                          width: 12,
                                          height: 12,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'food'.tr(),
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 12,
                                              height: 14 / 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (widget.roomModel.roomCat.amity)
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: SearchCtl.instance.amity
                                            ? mint[2]
                                            : black[120],
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          SvgIcon.ICON_amity,
                                          width: 12,
                                          height: 12,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'socializing'.tr(),
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 12,
                                              height: 14 / 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (widget.roomModel.roomCat.art)
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: SearchCtl.instance.art
                                            ? mint[2]
                                            : black[120],
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          SvgIcon.ICON_art,
                                          width: 12,
                                          height: 12,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'artsCulture'.tr(),
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 12,
                                              height: 14 / 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (widget.roomModel.roomCat.exercise)
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: SearchCtl.instance.exercise
                                            ? mint[2]
                                            : black[120],
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          SvgIcon.ICON_exercise,
                                          width: 12,
                                          height: 12,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'sports'.tr(),
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 12,
                                              height: 14 / 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: black[120],
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        widget.roomModel.roomCat.gender == 0
                                            ? PngIcon.ICON_all_gender
                                            : widget.roomModel.roomCat.gender ==
                                                    1
                                                ? PngIcon.ICON_female_gender
                                                : PngIcon.ICON_male_gender,
                                        width: 14,
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        widget.roomModel.roomCat.gender == 1
                                            ? 'womenOnly'.tr()
                                            : widget.roomModel.roomCat.gender ==
                                                    2
                                                ? 'menOnly'.tr()
                                                : 'allGenders'.tr(),
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 12,
                                            height: 14 / 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 28),
                              decoration: BoxDecoration(
                                color: black[120],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: yellow, width: 2),
                              ),
                              child: Text(
                                widget.roomModel.name,
                                style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    height: 21 / 18),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: black[120],
                                  borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                children: [
                                  SvgPicture.asset(SvgIcon.ICON_flash,
                                      width: 8,
                                      height: 14,
                                      colorFilter: ColorFilter.mode(
                                          yellow, BlendMode.srcIn)),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    '(${widget.roomModel.memberCount}/${widget.roomModel.memberLimit})',
                                    style: TextStyle(
                                        color: yellow,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        height: 14 / 12),
                                  )
                                ],
                              ))
                        ],
                      ),
                      SizedBox(height: 5),
                      Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: black[120],
                              borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            '${widget.roomModel.location} ${DateFormat.MMMEd(Localizations.localeOf(context).toString()).add_jm().format(DateTime.fromMillisecondsSinceEpoch(widget.roomModel.date))}',
                            style: TextStyle(
                                color: white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                height: 14 / 12),
                          )),
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                // TODO : android auido 설정 변경 함수 호출
                                MethodChannel('NativeFuncCall')
                                    .invokeMethod<String>('audio');
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.red,
                                child: Text(
                                  '오디오 설정 변경',
                                  style: TextStyle(color: white),
                                ),
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                              onTap: () {
                                // TODO : android video 설정 변경 함수 호출
                                MethodChannel('NativeFuncCall')
                                    .invokeMethod<String>('video');
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.blue,
                                child: Text(
                                  '비디오 설정변경',
                                  style: TextStyle(color: white),
                                ),
                              ))
                        ],
                      ),
                      if (mainVideo.value != LoginCtl.instance.user.seq)
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  // TODO : android 내가 상대방 비디오 안보기 (상대방 상태와는 무관)
                                  MethodChannel('NativeFuncCall')
                                      .invokeMethod<String>(
                                          'oppVideoSet', mainVideo.value);
                                },
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  color: white,
                                  child: Text(
                                    '상대영상닫기',
                                    style: TextStyle(color: black),
                                  ),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                                onTap: () {
                                  // TODO : android 내가 상대방 오디오 안보기 (상대방 상태와는 무관)
                                  MethodChannel('NativeFuncCall')
                                      .invokeMethod<String>(
                                          'oppAudioSet', mainVideo.value);
                                },
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  color: white,
                                  child: Text(
                                    '상대음소거',
                                    style: TextStyle(color: black),
                                  ),
                                )),
                          ],
                        ),
                    ],
                  ))),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      DottedBorder(
                          borderType: BorderType.RRect,
                          padding: EdgeInsets.zero,
                          radius: const Radius.circular(16),
                          color: yellow,
                          strokeWidth: 2,
                          dashPattern: const <double>[4, 3],
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white[150]),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(SvgIcon.ICON_flash,
                                      width: 9,
                                      height: 16,
                                      colorFilter: ColorFilter.mode(
                                          black, BlendMode.srcIn)),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    'meetProfile'.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: black,
                                        fontSize: 12,
                                        height: 14 / 12),
                                  )
                                ],
                              ))),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(color: white, width: 1),
                              borderRadius: BorderRadius.circular(16),
                              color: white[150]),
                          child: Text(
                            'chatProfile'.tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: white,
                                fontSize: 12,
                                height: 14 / 12),
                          )),
                      for (int key in userList.keys)
                        Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: yellow),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // TODO :: 번개 프로필 조건식 확인 후 if문 추가 필요
                                SvgPicture.asset(SvgIcon.ICON_flash,
                                    width: 9,
                                    height: 16,
                                    colorFilter: ColorFilter.mode(
                                        white, BlendMode.srcIn)),
                                // TODO :: 번개 프로필 조건식 확인 후 if문 추가 필요
                                SizedBox(
                                  width: 6,
                                ),
                                SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: userList[key]!.profileImg == ''
                                        ? SvgPicture.asset(
                                            SvgIcon.ICON_bottomProfile,
                                            theme:
                                                SvgTheme(currentColor: white),
                                          )
                                        :
                                        // TODO :: 로그인 및 프로필사진 업로드 될 경우 링크수정
                                        Image.network(
                                            userList[key]!.profileImg)),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  userList[key]!.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: white,
                                      fontSize: 12,
                                      height: 14 / 12),
                                ),
                              ],
                            )),
                      SizedBox(
                        height: 16,
                      ),
                      if (widget.roomModel.master.seq ==
                          LoginCtl.instance.user.seq)
                        InkWell(
                          onTap: () {
                            MethodChannel('NativeFuncCall')
                                .invokeMethod<String>('mainCameraDispose');
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: EdgeInsets.only(bottom: 6),
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: black[120]),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    SvgIcon.ICON_classCancel,
                                    width: 14,
                                    height: 14,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    'cancelMeet'.tr(),
                                    style: TextStyle(
                                        color: yellow,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        height: 14 / 12),
                                  )
                                ],
                              )),
                        ),
                      InkWell(
                        onTap: () {
                          MethodChannel('NativeFuncCall')
                              .invokeMethod<String>('mainCameraDispose');
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: black[120]),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  SvgIcon.ICON_exit,
                                  width: 14,
                                  height: 14,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'leave'.tr(),
                                  style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      height: 14 / 12),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 13),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (int i = 1; i < widget.roomModel.memberLimit; i++)
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: MediaQuery.of(context).size.width / 3 - 16,
                              height: MediaQuery.of(context).size.height / 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: black[100]),
                            )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // userList에 유저 모델이 있는경우 순회하며 key별 NT UI 생성
                          for (int key in userList.keys)
                            Builder(
                              builder: (context) {
                                // if (ntUIIdx.values.contains(key)) {
                                for (var entry in ntUIIdx.entries) {
                                  if (entry.value == key) {
                                    return RemoteVideoWidget(
                                      authModel: userList[key]!,
                                      roomModel: widget.roomModel,
                                      mainVideo: mainVideo,
                                      // NT UI factory를 미리 선언해두고 해당 factory를 호출해야함
                                      // 엔트리키 기준으로 인덱스 사용
                                      idx: entry.key,
                                    );
                                  }
                                }
                                return SizedBox();
                              },
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
