import 'package:rayo/utils/import_index.dart';

class ProfileBlockedHiddenPage extends StatefulWidget {
  final String type;
  const ProfileBlockedHiddenPage({required this.type, super.key});
  @override
  State<ProfileBlockedHiddenPage> createState() => _ProfileBlockedHiddenPage();
}

class _ProfileBlockedHiddenPage extends State<ProfileBlockedHiddenPage> {
  List<UserModel> userList = <UserModel>[];
  String nextQuery = '';
  bool initLoading = true;
  bool moreLoading = false;
  @override
  void initState() {
    super.initState();
    getUserList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserList({bool more = false}) async {
    if (more) {
      moreLoading = true;
      setState(() {});
      GetList.instance
          .userList(uri: URI_userFriend, query: {'q': nextQuery}).then((val) {
        if (val[statusCode] == 200) {
          userList.addAll(val[data]);
          nextQuery = val[pagination];
        }
        moreLoading = false;
        setState(() {});
      });
    } else {
      initLoading = true;
      setState(() {});
      GetList.instance.userList(
          uri: URI_userFriend, query: {'type': widget.type}).then((val) {
        if (val[statusCode] == 200) {
          userList = val[data];
          nextQuery = val[pagination];
        }
        initLoading = false;
        setState(() {});
      });
    }
  }

  @override
  Widget build(context) => Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title:
            Text(widget.type == 'blocked' ? 'blockedFriends'.tr() : '숨김 친구 관리'),
        backgroundColor: white,
        leading: BackBtn(
            color: black,
            func: () async {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          if (widget.type == 'blocked')
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              color: white[80],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text('blockedFriendsInfo'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: black[80],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 18 / 12)),
            ),
          Expanded(
            child: initLoading
                ? ListView.separated(
                    padding: EdgeInsets.only(
                        right: 16,
                        left: 16,
                        bottom: 16 + AppState.systemBarHeight),
                    itemCount: 20,
                    itemBuilder: (context, index) => SkeletonUserList(),
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                  )
                : NotificationListener(
                    onNotification: (t) {
                      if (t is ScrollUpdateNotification) {
                        if (t.metrics.axis == Axis.vertical) {
                          if (nextQuery != '' &&
                              !moreLoading &&
                              t.metrics.extentAfter < 200) {
                            getUserList(more: true);
                          }
                        }
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await getUserList();
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                            right: 16,
                            left: 16,
                            bottom: 16 + AppState.systemBarHeight),
                        itemCount: userList.isEmpty
                            ? 1
                            : moreLoading
                                ? userList.length + 3
                                : userList.length,
                        itemBuilder: (context, idx) {
                          if (userList.isEmpty) {
                            return Container(
                                alignment: Alignment.bottomCenter,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(SvgIcon.ICON_flash,
                                        width: 37,
                                        height: 44,
                                        colorFilter: ColorFilter.mode(
                                            black[60]!, BlendMode.srcIn)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      // TODO :: 번역 필요
                                      '찾으시는 내용이 없습니다.',
                                      style: TextStyle(
                                          color: black[60],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          height: 24 / 16),
                                    )
                                  ],
                                ));
                          }
                          if (idx < userList.length) {
                            return Row(
                              children: [
                                Expanded(
                                  child: UserListWidget(
                                    user: userList[idx],
                                  ),
                                ),
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  SizedBox(width: 10),
                                  InkWell(
                                      onTap: () async {
                                        if (widget.type == 'blocked') {
                                          p('차단친구 해제 API 호출');
                                        } else {
                                          p('숨김 해제 API 호출');
                                        }
                                        userList.removeAt(idx);
                                        setState(() {});
                                        // TODO :: 번역 필요
                                        await durationPopup(
                                            context,
                                            defaultAlertDalog(
                                                context,
                                                widget.type == 'blocked'
                                                    ? '차단을 해제하였습니다'
                                                    : '숨김을 해제하였습니다',
                                                color: mint));
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 6),
                                          height: 30,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1, color: mint),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Text(
                                            widget.type == 'blocked'
                                                ? 'unblock'.tr()
                                                : '숨김해제',
                                            style: TextStyle(
                                                color: mint,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                height: 18 / 14),
                                          )))
                                ]),
                              ],
                            );
                          } else {
                            return moreLoading
                                ? SkeletonUserList()
                                : SizedBox();
                          }
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: 16,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ));
}
