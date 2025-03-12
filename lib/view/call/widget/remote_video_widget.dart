import 'package:rayo/utils/import_index.dart';

class RemoteVideoWidget extends StatelessWidget {
  final UserModel authModel;
  final RoomModel roomModel;
  final ValueNotifier<int> mainVideo;
  final int idx;
  const RemoteVideoWidget(
      {required this.authModel,
      required this.roomModel,
      required this.mainVideo,
      required this.idx,
      super.key});
  @override
  Widget build(context) => GestureDetector(
        onTap: () {
          if (mainVideo.value != authModel.seq) {
            mainVideo.value = authModel.seq;
          } else {
            mainVideo.value = LoginCtl.instance.user.seq;
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: MediaQuery.of(context).size.width / 3 - 10,
          height: MediaQuery.of(context).size.height / 5,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: black[120],
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                  if (Platform.isAndroid)
                    Stack(
                      children: [
                        AndroidView(
                          viewType: 'WebRTCView$idx',
                          creationParams: authModel.seq,
                          creationParamsCodec: StandardMessageCodec(),
                        ),
                        if (mainVideo.value == authModel.seq) Container(),
                        AndroidView(
                          viewType: 'WebRTCViewMe',
                          creationParams: LoginCtl.instance.user.seq,
                          creationParamsCodec: StandardMessageCodec(),
                        ),
                      ],
                    ),
                  if (Platform.isIOS)
                    Stack(
                      children: [
                        UiKitView(
                          viewType: 'WebRTCView$idx',
                          creationParams: authModel.seq,
                          creationParamsCodec: StandardMessageCodec(),
                        ),
                        if (mainVideo.value == authModel.seq)
                          UiKitView(
                            viewType: 'WebRTCViewMe',
                            creationParams: LoginCtl.instance.user.seq,
                            creationParamsCodec: StandardMessageCodec(),
                          )
                      ],
                    ),
                  Positioned(
                      left: 8,
                      right: 8,
                      bottom: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: 24,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: black[120]),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (mainVideo.value != authModel.seq)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (roomModel.master.seq == authModel.seq)
                                        SvgPicture.asset(
                                          SvgIcon.ICON_roomMaster,
                                          width: 12,
                                          height: 7,
                                        ),
                                      if (roomModel.master.seq == authModel.seq)
                                        SizedBox(
                                          width: 6,
                                        ),
                                      Text(
                                        authModel.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            height: 12 / 10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                if (mainVideo.value == authModel.seq)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (roomModel.master.seq ==
                                          LoginCtl.instance.user.seq)
                                        SvgPicture.asset(
                                          SvgIcon.ICON_roomMaster,
                                          width: 12,
                                          height: 7,
                                        ),
                                      if (roomModel.master.seq ==
                                          LoginCtl.instance.user.seq)
                                        SizedBox(
                                          width: 6,
                                        ),
                                      Text(
                                        LoginCtl.instance.user.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            height: 12 / 10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  // FL ontap 동작 용 빈 컨테이너
                  Container(
                    color: Colors.transparent,
                  ),
                ],
              )),
        ),
      );
}
