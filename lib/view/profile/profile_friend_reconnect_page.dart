import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rayo/controller/chat_ctl.dart';
import 'package:rayo/db/model/hive_room_model.dart';
import 'package:rayo/utils/import_index.dart';

class ProfileFriendReconnectPage extends StatefulWidget {
  final int catIdx;
  const ProfileFriendReconnectPage({required this.catIdx, super.key});

  @override
  State<ProfileFriendReconnectPage> createState() =>
      _ProfileFriendReconnectPage();
}

class _ProfileFriendReconnectPage extends State<ProfileFriendReconnectPage> {
  int catIdx = 0;
  TextEditingController searchInput = TextEditingController();
  List<UserModel> userList = <UserModel>[];
  Timer? debounce;
  String nextQuery = '';
  bool initLoading = true;
  bool moreLoading = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    catIdx = widget.catIdx;
    getUserList();
  }

  @override
  void dispose() {
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }
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
      GetList.instance.userList(uri: URI_userFriend, query: {
        'input': searchInput.text,
        'type': catIdx == 0 ? 'friend' : 'reconnecting'
      }).then((val) {
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
  Widget build(context) {
    Future<bool> blockUserDialog() async {
      bool result = false;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            title: SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'wanttoblock'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 24 / 16,
                          color: black),
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'blockfriendinfo'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 18 / 12,
                          color: black[80]),
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Divider(
                    height: 0.25,
                    color: black[40],
                  ),
                  SizedBox(
                    height: 67,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'cancel'.tr(),
                                  style: TextStyle(
                                      color: black[60],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      height: 19 / 16),
                                ),
                              )),
                        ),
                        VerticalDivider(
                          width: 0.25,
                          color: black[40],
                        ),
                        Expanded(
                          child: InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                                result = true;
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'block'.tr(),
                                  style: TextStyle(
                                      color: black[60],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      height: 19 / 16),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
      return result;
    }

    void userSettingBottomSheet(BuildContext context,
        {required UserModel user}) {
      showModalBottomSheet(
          context: context,
          builder: (bottomContext) => GestureDetector(
                onTap: () {
                  if (context.mounted) {
                    Navigator.pop(bottomContext);
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 23),
                        decoration: BoxDecoration(
                          color: black[20],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(26),
                              topRight: Radius.circular(26)),
                        ),
                        child: Text(
                          user.name,
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 24 / 16),
                        )),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(bottomContext);
                        if (context.mounted) {
                          // TODO :: 번역 필요
                          await durationPopup(
                              context,
                              defaultAlertDalog(context, '숨김처리되었습니다.',
                                  color: white));
                        }
                        userList.remove(user);
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.all(16),
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TODO :: 번역 필요
                            Text(
                              '${user.name}님 숨기기',
                              style: TextStyle(
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  height: 21 / 14),
                            ),
                            // TODO :: 번역 필요
                            Text(
                              '목록에서 제거 됩니다.',
                              style: TextStyle(
                                  color: black[80],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  height: 18 / 12),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(bottomContext);
                        if (context.mounted) {
                          blockUserDialog().then((val) async {
                            if (val) {
                              if (context.mounted) {
                                // TODO :: 번역 필요
                                await durationPopup(
                                    context,
                                    defaultAlertDalog(context, '차단처리되었습니다.',
                                        color: white));
                                userList.remove(user);
                                setState(() {});
                              }
                            }
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(16),
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TODO :: 번역 필요
                            Text(
                              '${user.name}님 차단하기',
                              style: TextStyle(
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  height: 21 / 14),
                            ),
                            // TODO :: 번역 필요
                            Text(
                              '모든 접근이 차단됩니다.',
                              style: TextStyle(
                                  color: black[80],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  height: 18 / 12),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(bottomContext);
                        if (context.mounted) {
                          Navigator.pushNamed(context, NAV_ReportPage,
                              arguments: {'userModel': user}).then((val) async {
                            if (val == true) {
                              if (context.mounted) {
                                // TODO :: 번역 필요
                                await durationPopup(
                                    context,
                                    defaultAlertDalog(context, '신고하였습니다.',
                                        color: white));
                              }
                              userList.remove(user);
                              setState(() {});
                            }
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(16),
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TODO :: 번역 필요
                            Text(
                              '${user.name}님 신고하기',
                              style: TextStyle(
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  height: 21 / 14),
                            ),
                            // TODO :: 번역 필요
                            Text(
                              '부적절한 행동을 익명으로 신고합니다.',
                              style: TextStyle(
                                  color: black[80],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  height: 18 / 12),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ));
    }

    void cloudAlert(BuildContext context1, UserModel user) {
      showDialog(
          context: context1,
          builder: (context) => AlertDialog(
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          // TODO :: 번역 필요
                          child: Text('채팅을 시작하려면 구름 150개가 사용됩니다!',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium),
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
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      height: 63,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                  ),
                                ),
                                VerticalDivider(
                                  width: 0.25,
                                  color: black[40],
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      isLoading = true;
                                      setState(() {});
                                      await Future.delayed(
                                          Duration(seconds: 2));
                                      if (LoginCtl.instance.user.point.value >
                                          150) {
                                        LoginCtl.instance.user.point.value -=
                                            150;
                                        LoginCtl.instance.user.friendList
                                            .add(user.seq);

                                        HiveRoomModel room = await ChatCtl
                                            .instance
                                            .setDirectChat(
                                                user: user, friend: false);
                                        if (context1.mounted) {
                                          Navigator.pushNamed(
                                              context1, NAV_ChatRoomPage,
                                              arguments: {
                                                'HiveRoomModel': room
                                              }).then((_) {
                                            isLoading = false;
                                            setState(() {});
                                          });
                                        }
                                      } else {
                                        if (context1.mounted) {
                                          InAppPurchaseCtl.instance
                                              .needCloud(context1);
                                        }
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(15),
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
                                          Text(
                                            '150',
                                            style: TextStyle(
                                              fontFamily: 'MCMerchant',
                                              fontSize: 12,
                                              height: 19.2 / 12,
                                              fontWeight: FontWeight.w400,
                                              color: black[60],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'usage'.tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                height: 19.09 / 16,
                                                color: mint[2]),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ],
                    )),
              ));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              leading: BackBtn(func: () async {
                Navigator.pop(context);
              }),
              title: Text('friends'.tr()),
              // actions: [
              //   Container(
              //     margin: const EdgeInsets.symmetric(horizontal: 16),
              //     width: 36,
              //     height: 36,
              //     child: CloudWidget(
              //       color: black[60]!,
              //     ),
              //   ),
              // ],
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        catIdx = 0;
                        searchInput.clear();
                        await getUserList();
                        setState(() {});
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 2,
                          height: 42,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: catIdx == 0 ? yellow : white,
                                      width: 4))),
                          child: Text('friendList'.tr(),
                              style: TextStyle(
                                  color: black,
                                  fontSize: 14,
                                  height: 21 / 14,
                                  fontWeight: FontWeight.w600))),
                    ),
                    InkWell(
                      onTap: () async {
                        catIdx = 1;
                        searchInput.clear();
                        await getUserList();
                        setState(() {});
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 2,
                          height: 42,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: catIdx == 1 ? yellow : white,
                                      width: 4))),
                          // TODO :: 번역 필요
                          child: Text('reconnecting'.tr(),
                              style: TextStyle(
                                  color: black,
                                  fontSize: 14,
                                  height: 21 / 14,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ],
                ),
                Container(
                    width: double.infinity,
                    height: 41,
                    margin: EdgeInsets.only(
                        top: 12, right: 16, left: 16, bottom: 9),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: white[80]),
                    child: Row(
                      children: [
                        SvgPicture.asset(SvgIcon.ICON_search,
                            width: 14, height: 14),
                        const SizedBox(width: 8),
                        Expanded(
                            child: TextFormField(
                          onChanged: (val) {
                            if (val.length > 1) {
                              initLoading = true;
                              setState(() {});
                              if (debounce?.isActive ?? false) {
                                debounce?.cancel();
                              }
                              PrimaryScrollController.of(context).jumpTo(0);
                              debounce =
                                  Timer(const Duration(seconds: 1), () async {
                                await getUserList();
                              });
                            }
                            if (val.isEmpty) {
                              getUserList();
                            }
                          },
                          controller: searchInput,
                          decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 14,
                                height: 21 / 14,
                                fontWeight: FontWeight.w600,
                                color: black[80]),
                            hintText: 'searchName'.tr(),
                          ),
                          style: const TextStyle(
                              fontSize: 14,
                              height: 18 / 14,
                              fontWeight: FontWeight.w500,
                              color: black),
                        ))
                      ],
                    )),
                Expanded(
                  child: initLoading
                      ? ListView.separated(
                          padding: EdgeInsets.only(
                              right: 16,
                              left: 16,
                              bottom: 16 + AppState.systemBarHeight),
                          itemCount: 20,
                          itemBuilder: (context, index) => SkeletonUserList(),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10),
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
                                          MediaQuery.of(context).size.height *
                                              0.25,
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
                                  return Slidable(
                                    key: UniqueKey(),
                                    endActionPane: ActionPane(
                                        dragDismissible: false,
                                        motion: ScrollMotion(),
                                        extentRatio: 0.2,
                                        children: [
                                          CustomSlidableAction(
                                              padding: EdgeInsets.zero,
                                              onPressed: (_) async {
                                                userSettingBottomSheet(context,
                                                    user: userList[idx]);
                                              },
                                              backgroundColor: red,
                                              child: SvgPicture.asset(
                                                  SvgIcon.ICON_delete))
                                        ]),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: UserListWidget(
                                            user: userList[idx],
                                          ),
                                        ),
                                        if (catIdx == 0)
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(width: 10),
                                              InkWell(
                                                  onTap: () async {
                                                    HiveRoomModel room =
                                                        await ChatCtl.instance
                                                            .setDirectChat(
                                                                user: userList[
                                                                    idx],
                                                                friend: true);
                                                    if (context.mounted) {
                                                      Navigator.pushNamed(
                                                          context,
                                                          NAV_ChatRoomPage,
                                                          arguments: {
                                                            'HiveRoomModel':
                                                                room
                                                          }).then((_) async {
                                                        isLoading = false;
                                                        setState(() {});
                                                        Box<HiveObject> box = Hive
                                                                .isBoxOpen(room
                                                                    .dataKey)
                                                            ? Hive.box<
                                                                    HiveObject>(
                                                                room.dataKey)
                                                            : await Hive.openBox<
                                                                    HiveObject>(
                                                                room.dataKey);
                                                        if (box.length == 0) {
                                                          box.deleteFromDisk();
                                                          await room.delete();
                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 14,
                                                              vertical: 6),
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: mint),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: SvgPicture.asset(
                                                        SvgIcon
                                                            .ICON_chatMintIcon,
                                                        width: 14,
                                                        height: 14,
                                                      ))),
                                            ],
                                          ),
                                        if (catIdx == 1)
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(width: 10),
                                              InkWell(
                                                  onTap: () {
                                                    p('친구요청 버튼, 구름 결제창 이동');
                                                    cloudAlert(
                                                        context, userList[idx]);
                                                  },
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 14,
                                                              vertical: 6),
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          color: LoginCtl
                                                                  .instance
                                                                  .user
                                                                  .friendList
                                                                  .contains(
                                                                      userList[
                                                                              idx]
                                                                          .seq)
                                                              ? skyBlue
                                                              : mint,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          if (LoginCtl.instance
                                                              .user.friendList
                                                              .contains(
                                                                  userList[idx]
                                                                      .seq))
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Image.asset(
                                                                  PngIcon
                                                                      .ICON_message,
                                                                  width: 14,
                                                                  height: 14,
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                )
                                                              ],
                                                            ),
                                                          Text(
                                                            LoginCtl
                                                                    .instance
                                                                    .user
                                                                    .friendList
                                                                    .contains(
                                                                        userList[idx]
                                                                            .seq)
                                                                ? 'sendMessage'
                                                                    .tr()
                                                                // TODO :: 번역 필요
                                                                : '친구요청',
                                                            style: TextStyle(
                                                                color: LoginCtl
                                                                        .instance
                                                                        .user
                                                                        .friendList
                                                                        .contains(userList[idx]
                                                                            .seq)
                                                                    ? black
                                                                    : white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12,
                                                                height:
                                                                    18 / 12),
                                                          ),
                                                        ],
                                                      ))),
                                            ],
                                          ),
                                        SizedBox(width: 16),
                                      ],
                                    ),
                                  );
                                } else {
                                  return moreLoading
                                      ? Row(
                                          children: [
                                            SizedBox(width: 16),
                                            Expanded(child: SkeletonUserList()),
                                            SizedBox(width: 16),
                                          ],
                                        )
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
            )),
        if (isLoading)
          Container(
              width: double.infinity,
              height: double.infinity,
              color: black[100],
              child: Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                  ),
                ),
              ))
      ],
    );
  }
}
