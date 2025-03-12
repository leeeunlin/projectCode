import 'package:rayo/utils/import_index.dart';

class ProfileCallHistoryPage extends StatefulWidget {
  const ProfileCallHistoryPage({super.key});
  @override
  State<ProfileCallHistoryPage> createState() => _ProfileCallHistoryPage();
}

class _ProfileCallHistoryPage extends State<ProfileCallHistoryPage> {
  List<RoomModel> roomList = <RoomModel>[];
  String nextQuery = '';
  bool initLoading = true;
  bool moreLoading = false;

  @override
  void initState() {
    super.initState();
    GetList.instance.roomList(uri: '대화 히스토리 가져오기').then((val) {
      if (val[statusCode] == 200) {
        roomList = val[data];
        nextQuery = val[pagination];
      }
      initLoading = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(context) {
    return ScrollsToTop(
        onScrollsToTop: (event) => PrimaryScrollController.of(context)
            .animateTo(0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn),
        child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              backgroundColor: yellow,
              title: Text(
                'chatHistory'.tr(),
                style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  height: 21.6 / 18,
                ),
              ),
              leading: BackBtn(func: () => Navigator.pop(context)),
            ),
            body: Column(
              children: [
                Container(
                    width: double.infinity,
                    height: 68,
                    padding: EdgeInsets.all(16),
                    color: white[80],
                    child: Text(
                      '대화에 참여한 내역입니다.\n이 내역은 7일 뒤 자동 삭제됩니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: black[80],
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 18 / 12),
                    )),
                Expanded(
                  child: initLoading
                      ? GridView.builder(
                          padding: EdgeInsets.only(
                              top: 16,
                              left: 16,
                              right: 16,
                              bottom: 16 + AppState.systemBarHeight),
                          itemCount: 8,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                          itemBuilder: (context, idx) => SkeletonGridList())
                      : NotificationListener(
                          onNotification: (t) {
                            if (t is ScrollUpdateNotification) {
                              if (t.metrics.axis == Axis.vertical) {
                                if (nextQuery != '' &&
                                    !moreLoading &&
                                    t.metrics.extentAfter < 500) {
                                  moreLoading = true;
                                  setState(() {});
                                  GetList.instance.moreRoomList(
                                      uri: '방정보 더 가져오기',
                                      query: {'q': nextQuery}).then((val) {
                                    if (val[statusCode] == 200) {
                                      roomList.addAll(val[data]);
                                      nextQuery = val[pagination];
                                    }
                                    moreLoading = false;
                                    setState(() {});
                                  });
                                }
                              }
                            }
                            return true;
                          },
                          child: RefreshIndicator(
                            onRefresh: () async {
                              initLoading = true;
                              setState(() {});
                              await GetList.instance
                                  .roomList(uri: '대화히스토리 가져오기')
                                  .then((val) {
                                if (val[statusCode] == 200) {
                                  roomList = val[data];
                                  nextQuery = val[pagination];
                                }
                                initLoading = false;
                                setState(() {});
                              });
                            },
                            child: GridView.builder(
                              padding: EdgeInsets.only(
                                  top: 16,
                                  left: 16,
                                  right: 16,
                                  bottom: 16 + AppState.systemBarHeight),
                              itemCount: moreLoading
                                  ? roomList.length + 8
                                  : roomList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8),
                              itemBuilder: (context, idx) {
                                if (idx < roomList.length) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GridViewRoomWidget(
                                        func: () {
                                          // 사용하지않음 history탭에서는 하단 컨테이너버튼으로 적용
                                        },
                                        history: true,
                                        roomModel: roomList[idx],
                                      ),
                                      if (!roomList[idx].completed &&
                                          roomList[idx].memberCount !=
                                              roomList[idx].memberLimit)
                                        InkWell(
                                          onTap: () {
                                            p('history 대화방 입장하기');
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              margin:
                                                  EdgeInsets.only(bottom: 20),
                                              width: (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      16 -
                                                      4) *
                                                  0.45,
                                              height: (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      16 -
                                                      4) *
                                                  0.45,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 1, color: white),
                                                  color: white[150]),
                                              child: Text(
                                                '입장하기',
                                                style: TextStyle(
                                                    color: black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    height: 21 / 14),
                                              )),
                                        )
                                    ],
                                  );
                                } else {
                                  return moreLoading
                                      ? SkeletonGridList()
                                      : SizedBox();
                                }
                              },
                            ),
                          ),
                        ),
                )
              ],
            )));
  }
}
