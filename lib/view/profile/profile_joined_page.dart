import 'package:rayo/utils/import_index.dart';

class ProfileJoinedPage extends StatefulWidget {
  const ProfileJoinedPage({super.key});
  @override
  State<ProfileJoinedPage> createState() => _ProfileJoinedPage();
}

class _ProfileJoinedPage extends State<ProfileJoinedPage> {
  List<RoomModel> roomList = <RoomModel>[];
  String nextQuery = '';
  bool initLoading = true;
  bool moreLoading = false;
  @override
  void initState() {
    super.initState();
    GetList.instance.roomList(uri: '내가 참여한 번개 리스트들 가져오기').then((val) {
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
      onScrollsToTop: (event) => PrimaryScrollController.of(context).animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn),
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: mint,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                SvgIcon.ICON_flash,
                width: 7.5,
                height: 15,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'participationList'.tr(),
                style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  height: 21.6 / 18,
                ),
              )
            ],
          ),
          leading: BackBtn(func: () => Navigator.pop(context)),
        ),
        body: initLoading
            ? GridView.builder(
                padding: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 16 + AppState.systemBarHeight),
                itemCount: 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.7,
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
                        .roomList(uri: '내가 주최한 번개 리스트들 가져오기')
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
                    itemCount:
                        moreLoading ? roomList.length + 8 : roomList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.7,
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
                                roomList.remove(roomList[idx]);
                                setState(() {});
                              },
                              roomModel: roomList[idx],
                            ),
                          ],
                        );
                      } else {
                        return moreLoading ? SkeletonGridList() : SizedBox();
                      }
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
