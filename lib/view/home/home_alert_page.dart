import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rayo/model/alert_model.dart';
import 'package:rayo/utils/import_index.dart';
import 'package:rayo/view/home/widget/alert_list_widget.dart';

class HomeAlertPage extends StatefulWidget {
  const HomeAlertPage({super.key});

  @override
  State<HomeAlertPage> createState() => _HomeAlertPageState();
}

class _HomeAlertPageState extends State<HomeAlertPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Timer timer;
  List<String> notiString = <String>[
    '🚨계정 잃지마세요🚨 이메일을 인증하고 걱정없이 이용하세요',
    '🥳환영해요🥳 커뮤니티 가이드를 확인하고 함께 놀아봐요',
    '📝 소개글을 쓰면 잘 맞는 사람을 만날 확률이 올라가요',
  ];
  List<AlertModel> alertList = <AlertModel>[];

  String nextQuery = '';
  bool initLoading = true;
  bool moreLoading = false;

  double notiheight = 0.0;

  @override
  void initState() {
    super.initState();
    GetList.instance.alertList(uri: '알림 리스트 가져오기').then((val) {
      if (val[statusCode] == 200) {
        alertList = val[data];
        nextQuery = val[pagination];
      }
      initLoading = false;
      setState(() {});
    });
    _pageController = PageController(
      initialPage: 0,
    );
    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.page!.toInt() < notiString.length - 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        _pageController.jumpToPage(0);
      }
    });
    _animationController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(context) => Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: Text('알림'),
          backgroundColor: white,
          leading: BackBtn(func: () async {
            Navigator.pop(context);
          }),
        ),
        body: NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                shape: Border(),
                automaticallyImplyLeading: false,
                floating: false,
                snap: false,
                pinned: false,
                toolbarHeight: 35,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    height: 35,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: black[60],
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              '공지',
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  height: 15 / 10),
                            )),
                        SizedBox(width: 8),
                        Expanded(
                            child: PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.vertical,
                          itemCount: notiString.length,
                          itemBuilder: (context, index) => Text(
                            notiString[index],
                            style: TextStyle(
                              color: black[80],
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              height: 18 / 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )),
                        InkWell(
                            onTap: () {
                              if (notiheight == 0.0) {
                                if (notiString.length < 5) {
                                  notiheight =
                                      35 * (notiString.length.toDouble());
                                } else {
                                  notiheight = 35 * 4;
                                }
                                _animationController.forward();
                              } else {
                                notiheight = 0.0;
                                _animationController.reverse();
                              }
                              setState(() {});
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                        angle:
                                            _animationController.value * 3.14,
                                        child: child);
                                  },
                                  child: SizedBox(
                                    width: 9,
                                    height: 5,
                                    child: SvgPicture.asset(
                                      SvgIcon.ICON_notiOpen,
                                    ),
                                  ),
                                )))
                      ],
                    ),
                  ),
                ),
              ),
              if (notiheight != 0.0)
                SliverAppBar(
                    shape: Border(),
                    automaticallyImplyLeading: false,
                    floating: false,
                    snap: false,
                    pinned: false,
                    toolbarHeight: notiheight,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListView.separated(
                              itemCount: notiString.length,
                              itemBuilder: (context, index) => Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: black[60],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Text(
                                        '공지',
                                        style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            height: 15 / 10),
                                      )),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      notiString[index],
                                      style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        height: 18 / 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                height: 16,
                              ),
                            ))))
            ];
          },
          body: initLoading
              ? ListView.separated(
                  padding: EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 76 + AppState.systemBarHeight),
                  itemCount: 20,
                  itemBuilder: (context, index) => SkeletonAlertList(),
                  separatorBuilder: (context, index) => SizedBox(height: 10),
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
                          GetList.instance.moreAlertList(
                              uri: '알림정보 더 가져오기',
                              query: {'q': nextQuery}).then((val) {
                            if (val[statusCode] == 200) {
                              alertList.addAll(val[data]);
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
                            .alertList(uri: '방정보 가져오기')
                            .then((val) {
                          if (val[statusCode] == 200) {
                            alertList = val[data];
                            nextQuery = val[pagination];
                          }
                          initLoading = false;
                          setState(() {});
                        });
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                            top: 16,
                            left: 16,
                            right: 16,
                            bottom: 76 + AppState.systemBarHeight),
                        itemCount: moreLoading
                            ? alertList.length + 20
                            : alertList.length,
                        itemBuilder: (context, idx) {
                          if (idx < alertList.length) {
                            return Column(
                              children: [
                                Slidable(
                                  key: UniqueKey(),
                                  endActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      extentRatio: 0.2,
                                      dismissible: DismissiblePane(
                                          dismissalDuration:
                                              Duration(milliseconds: 100),
                                          resizeDuration:
                                              Duration(milliseconds: 100),
                                          onDismissed: () async {
                                            alertList.removeAt(idx);
                                            p('알림삭제 API 발송');
                                            setState(() {});
                                          }),
                                      children: [
                                        CustomSlidableAction(
                                            onPressed: (context) async {
                                              alertList.removeAt(idx);
                                              p('알림삭제 API 발송');
                                              setState(() {});
                                            },
                                            backgroundColor: Colors.red,
                                            child: SvgPicture.asset(
                                                SvgIcon.ICON_delete))
                                      ]),
                                  child: InkWell(
                                    onTap: () {
                                      if (!alertList[idx].isRead) {
                                        alertList[idx].isRead = true;
                                        p('알림 읽음 API 발송');
                                      }

                                      setState(() {});
                                    },
                                    child: AlertListWidget(
                                        alertModel: alertList[idx]),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return moreLoading
                                ? SkeletonAlertList()
                                : SizedBox();
                          }
                        },
                        separatorBuilder: (context, idx) =>
                            SizedBox(height: 10),
                      ))),
        ),
      );
}
