import 'package:rayo/utils/import_index.dart';

class ProfileReviewPage extends StatefulWidget {
  const ProfileReviewPage({super.key});

  @override
  State<ProfileReviewPage> createState() => _ProfileReviewPageState();
}

class _ProfileReviewPageState extends State<ProfileReviewPage> {
  List<RoomModel> roomList = <RoomModel>[];
  String nextQuery = '';
  bool initLoading = true;
  bool moreLoading = false;
  @override
  void initState() {
    super.initState();
    GetList.instance.roomList(uri: '담벼락작성안된 방정보 가져오기').then((val) {
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
  Widget build(context) => ScrollsToTop(
        onScrollsToTop: (event) => PrimaryScrollController.of(context)
            .animateTo(0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn),
        child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
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
                    'meetingreview'.tr(),
                    style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 21.6 / 18,
                    ),
                  )
                ],
              ),
              shape: Border(bottom: BorderSide(color: black[40]!, width: 0.25)),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.7,
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                    itemBuilder: (context, idx) => SkeletonGridList())
                : GridView.builder(
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
                                Navigator.pushNamed(
                                        context, NAV_ReviewWritePage,
                                        arguments: {'roomModel': roomList[idx]})
                                    .then((value) {
                                  if (value != null) {
                                    roomList.remove(value);
                                  }
                                  setState(() {});
                                });
                              },
                              review: true,
                              roomModel: roomList[idx],
                            ),
                          ],
                        );
                      } else {
                        return moreLoading ? SkeletonGridList() : SizedBox();
                      }
                    })),
      );
}
