import 'package:rayo/utils/import_index.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  GlobalKey profileKey = GlobalKey();
  double position = 0.0;
  @override
  void initState() {
    super.initState();
    setListPosition();
  }

  void setListPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (profileKey.currentContext != null) {
        final RenderBox renderBox =
            profileKey.currentContext!.findRenderObject() as RenderBox;
        position = renderBox.size.height;
        setState(() {});
      }
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        backgroundColor: yellow,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: yellow,
          shape: const Border(
            bottom: BorderSide(color: yellow, width: 0.25),
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
                height: double.infinity,
                width: 654,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [yellow, white],
                    stops: [0.5, 0.5],
                  ),
                )),
            Positioned(
              top: 75,
              child: Container(
                height: 666,
                width: 654,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, color: white),
              ),
            ),
            Positioned.fill(
              child: ListView(
                padding: EdgeInsets.only(bottom: 76 + AppState.systemBarHeight),
                children: [
                  SizedBox(
                    height: position,
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, NAV_ProfileFriendReconnectPage,
                              arguments: {
                                'catIdx': 0,
                              });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          alignment: Alignment.center,
                          height: 42,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12.5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: yellow),
                          child: Text(
                            'friendList'.tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 16.71 / 14,
                                color: white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, NAV_ProfileFriendReconnectPage,
                              arguments: {
                                'catIdx': 1,
                              });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          alignment: Alignment.center,
                          height: 42,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12.5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: black),
                          child: Text(
                            'reconnecting'.tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 16.71 / 14,
                                color: yellow),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    indent: 16,
                    endIndent: 16,
                    height: 0.25,
                    color: black[40],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, NAV_ProfileCallHistoryPage);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 37,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: black[40]),
                                  child: AutoSizeText(
                                    'chatHistory'.tr(),
                                    maxFontSize: 14,
                                    minFontSize: 1,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        height: 16.71 / 14,
                                        color: white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, NAV_ProfileHostedPage);
                                },
                                child: DottedBorder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(100),
                                    color: yellow,
                                    strokeWidth: 2,
                                    dashPattern: const <double>[4, 3],
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 9,
                                            height: 16,
                                            child: SvgPicture.asset(
                                                SvgIcon.ICON_flash),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7 -
                                                  9 - // 번개아이콘
                                                  6 - // 여백
                                                  16 - // 좌패딩 16
                                                  16, // 우패딩 16
                                            ),
                                            child: AutoSizeText(
                                              'hostMeetingList'.tr(),
                                              maxLines: 1,
                                              maxFontSize: 14,
                                              minFontSize: 1,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  height: 16.71 / 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, NAV_ProfileJoinedPage);
                                },
                                child: DottedBorder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(100),
                                    color: mint,
                                    strokeWidth: 2,
                                    dashPattern: const <double>[4, 3],
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 9,
                                            height: 16,
                                            child: SvgPicture.asset(
                                                SvgIcon.ICON_flash),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7 -
                                                  9 - // 번개아이콘
                                                  6 - // 여백
                                                  16 - // 좌패딩 16
                                                  16, // 우패딩 16
                                            ),
                                            child: AutoSizeText(
                                              'participationList'.tr(),
                                              maxLines: 1,
                                              maxFontSize: 14,
                                              minFontSize: 1,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  height: 16.71 / 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, NAV_ProfileReviewPage);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 37,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: black[40]!),
                                      borderRadius: BorderRadius.circular(100),
                                      color: white),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 9,
                                        height: 16,
                                        child: SvgPicture.asset(
                                            SvgIcon.ICON_flash),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7 -
                                              9 - // 번개아이콘
                                              6 - // 여백
                                              18 - // 좌패딩 16
                                              18, // 우패딩 16
                                        ),
                                        child: AutoSizeText(
                                          'meetingreview'.tr(),
                                          maxFontSize: 14,
                                          minFontSize: 1,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              height: 16.71 / 14,
                                              color: black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, NAV_ProfileSettingPage);
                                },
                                child: SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: SvgPicture.asset(SvgIcon.ICON_setting),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            ),
            Container(
                key: profileKey,
                margin: const EdgeInsets.only(
                    top: 10, right: 16, bottom: 24, left: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: black[40]!,
                        blurRadius: 20,
                        offset: const Offset(0, 0),
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 46,
                        width: double.infinity,
                        child: SizedBox(
                            width: 36,
                            height: 36,
                            child: CloudWidget(
                              color: black[40]!,
                            ))),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, NAV_ProfileModifyPage)
                            .then((_) {
                          setState(() {});

                          setListPosition();
                        });
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: LoginCtl.instance.user.profileImg != ''
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            '$cdnUri${LoginCtl.instance.user.profileImg}'),
                                        fit: BoxFit.cover)
                                    : null),
                            child: LoginCtl.instance.user.profileImg == ''
                                ? SvgPicture.asset(
                                    SvgIcon.ICON_bottomProfile,
                                    theme: SvgTheme(currentColor: black[20]!),
                                  )
                                : null,
                          ),
                          SvgPicture.asset(
                            SvgIcon.ICON_edit,
                            width: 28,
                            height: 28,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      LoginCtl.instance.user.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          height: 18 / 18,
                          color: black),
                    ),
                    const SizedBox(height: 16),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 9),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: yellow, width: 2)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                height: 24,
                                width: 24,
                                child: SvgPicture.asset(SvgIcon.ICON_star)),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                                '${'rating'.tr()} ${LoginCtl.instance.user.rating}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    height: 16.71 / 14,
                                    color: black)),
                          ],
                        )),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: yellow,
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.3),
                        alignment: Alignment.center,
                        height: 24,
                        child: AutoSizeText(
                            minFontSize: 1,
                            '${'participationRate'.tr()} 75.6%',
                            maxLines: 2,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 16.71 / 14,
                                color: white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LoginCtl.instance.user.introduce,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 21 / 14,
                          color: black),
                    ),
                    const SizedBox(height: 32),
                  ],
                )),
          ],
        ));
  }
}
