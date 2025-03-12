import 'package:rayo/utils/import_index.dart';

class SearchListPage extends StatefulWidget {
  const SearchListPage({super.key});

  @override
  State<SearchListPage> createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  List<RoomModel> roomList = <RoomModel>[];
  String nextQuery = '';
  String filterTxt = '';
  bool initLoading = true;
  bool moreLoading = false;

  @override
  void initState() {
    super.initState();
    filterTxt = SearchCtl.instance.setFilterString();
    GetList.instance.roomList(uri: '방정보가져오기 init').then((val) {
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
  Widget build(BuildContext context) {
    return ScrollsToTop(
      onScrollsToTop: (event) => PrimaryScrollController.of(context).animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn),
      child: Scaffold(
        backgroundColor: black[60],
        appBar: AppBar(
          shape: Border(
              bottom: BorderSide(
            color: black[60]!,
          )),
          backgroundColor: black[60],
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: white),
                child: BackBtn(func: () async {
                  Navigator.pop(context);
                }),
              ),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 28,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              filterTxt,
                              style: TextStyle(
                                color: white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                height: 18 / 12,
                              ),
                            ),
                          ],
                        ))),
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: black[120]),
                  child: Container(
                      width: 36,
                      height: 36,
                      margin: EdgeInsets.all(8),
                      child: CloudWidget())),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: initLoading
                    ? ListView.separated(
                        padding: EdgeInsets.only(
                            top: 16,
                            right: 16,
                            left: 16,
                            bottom: 76 + AppState.systemBarHeight),
                        itemCount: 20,
                        itemBuilder: (context, index) => SkeletonSearchList(),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                      )
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
                                .roomList(uri: '방정보 가져오기')
                                .then((val) {
                              if (val[statusCode] == 200) {
                                roomList = val[data];
                                nextQuery = val[pagination];
                              }
                              initLoading = false;
                              setState(() {});
                            });
                          },
                          child: ListView.separated(
                            padding: EdgeInsets.only(
                                top: 16,
                                right: 16,
                                left: 16,
                                bottom: 16 + AppState.systemBarHeight),
                            itemCount: moreLoading
                                ? roomList.length + 20
                                : roomList.length,
                            itemBuilder: (context, idx) {
                              if (idx < roomList.length) {
                                return Column(
                                  children: [
                                    SearchListWidget(
                                      roomModel: roomList[idx],
                                    ),
                                  ],
                                );
                              } else {
                                return moreLoading
                                    ? SkeletonSearchList()
                                    : SizedBox();
                              }
                            },
                            separatorBuilder: (context, idx) => SizedBox(
                              height: 10,
                            ),
                          ),
                        )))
          ],
        ),
      ),
    );
  }
}
