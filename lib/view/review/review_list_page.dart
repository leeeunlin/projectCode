import 'package:rayo/utils/import_index.dart';

class ReviewListPage extends StatefulWidget {
  const ReviewListPage({super.key});

  @override
  State<ReviewListPage> createState() => ReviewListPageState();
}

class ReviewListPageState extends State<ReviewListPage> {
  TextEditingController searchInput = TextEditingController();
  List<ReviewModel> reviewList = <ReviewModel>[];
  Timer? debounce;
  String nextQuery = '';
  bool initLoading = true;
  bool moreLoading = false;

  bool food = true;
  bool amity = false;
  bool art = false;
  bool exercise = false;
  bool myReview = false;
  int filter = 0;

  @override
  void initState() {
    super.initState();
    initGetList();
  }

  @override
  void dispose() {
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }
    super.dispose();
  }

  Future<void> initGetList() async {
    initLoading = true;
    setState(() {});
    GetList.instance.reviewList(uri: '담벼락 리스트 가져오기').then((val) {
      if (val[statusCode] == 200) {
        reviewList = val[data];
        nextQuery = val[pagination];
      }
      initLoading = false;
      setState(() {});
    });
  }

  void filterButton(int idx) {
    filter = idx;
    food = false;
    amity = false;
    art = false;
    exercise = false;
    myReview = false;
    switch (filter) {
      case 0:
        food = true;
        break;
      case 1:
        amity = true;
        break;
      case 2:
        art = true;
        break;
      case 3:
        exercise = true;
        break;
      case 4:
        myReview = true;
        break;
    }
    setState(() {});
  }

  @override
  Widget build(context) => ScrollsToTop(
        onScrollsToTop: (event) => PrimaryScrollController.of(context)
            .animateTo(0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              shape: const Border(
                bottom: BorderSide(color: white, width: 0.25),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 7.5,
                    height: 15,
                    child: SvgPicture.asset(SvgIcon.ICON_flash),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'wallTitle'.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        height: 21.6 / 18),
                  )
                ],
              ),
            ),
            body: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    shape: const Border(),
                    automaticallyImplyLeading: false,
                    floating: false,
                    snap: false,
                    pinned: true,
                    toolbarHeight: 54,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          width: double.infinity,
                          height: 54,
                          child: Container(
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
                                        PrimaryScrollController.of(context)
                                            .jumpTo(0);
                                        debounce =
                                            Timer(const Duration(seconds: 1),
                                                () async {
                                          await GetList.instance.reviewList(
                                              uri: '리뷰 검색 API',
                                              query: {'q': val}).then((val) {
                                            if (val[statusCode] == 200) {
                                              reviewList = val[data];
                                              nextQuery = val[pagination];
                                            }
                                            initLoading = false;
                                            setState(() {});
                                          });
                                        });
                                      }
                                      if (val.isEmpty) {
                                        setState(() {});
                                      }
                                    },
                                    controller: searchInput,
                                    decoration: InputDecoration.collapsed(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          height: 18 / 14,
                                          fontWeight: FontWeight.w500,
                                          color: black[80]),
                                      hintText: 'searchterm...'.tr(),
                                    ),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        height: 18 / 14,
                                        fontWeight: FontWeight.w500,
                                        color: black),
                                  ))
                                ],
                              ))),
                    ),
                  ),
                  SliverAppBar(
                    shape: const Border(),
                    automaticallyImplyLeading: false,
                    floating: false,
                    snap: false,
                    pinned: false,
                    toolbarHeight: 40,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                            // alignment: Alignment.topCenter,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: double.infinity,
                            height: 40,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (int i = 0; i < 5; i++)
                                      Builder(builder: (context) {
                                        return InkWell(
                                          onTap: () async {
                                            PrimaryScrollController.of(context)
                                                .jumpTo(0);
                                            initLoading = true;
                                            filterButton(i);
                                            await GetList.instance
                                                .reviewList(uri: '담벼락 리스트 가져오기')
                                                .then((val) {
                                              if (val[statusCode] == 200) {
                                                reviewList = val[data];
                                                nextQuery = val[pagination];
                                              }
                                              initLoading = false;
                                              setState(() {});
                                            });
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              height: 32,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color: filter == i
                                                        ? mint[2]!
                                                        : black[60]!,
                                                    width: 0.25),
                                                color: filter == i
                                                    ? mint[2]!
                                                    : white,
                                              ),
                                              child: Text(
                                                i == 0
                                                    ? 'food'.tr()
                                                    : i == 1
                                                        ? 'socializing'.tr()
                                                        : i == 2
                                                            ? 'artsCulture'.tr()
                                                            : i == 3
                                                                ? 'sports'.tr()
                                                                : 'myReviews'
                                                                    .tr(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    height: 12 / 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: filter == i
                                                        ? white
                                                        : black[60]!),
                                              )),
                                        );
                                      })
                                  ],
                                )))),
                  )
                ];
              },
              body: initLoading
                  ? ListView.separated(
                      padding: EdgeInsets.only(
                          bottom: 76 + AppState.systemBarHeight),
                      itemCount: 20,
                      itemBuilder: (context, index) => SkeletonReviewList(),
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
                              GetList.instance.moreReviewList(
                                  uri: '리뷰리스트 더 가져오기',
                                  query: {'q': nextQuery}).then((val) {
                                if (val[statusCode] == 200) {
                                  reviewList.addAll(val[data]);
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
                          await GetList.instance.reviewList(
                              uri: '리뷰 검색 API', query: {'q': 'a'}).then((val) {
                            if (val[statusCode] == 200) {
                              reviewList = val[data];
                              nextQuery = val[pagination];
                            }
                            initLoading = false;
                            setState(() {});
                          });
                        },
                        child: ListView.separated(
                            padding: EdgeInsets.only(
                                bottom: 76 + AppState.systemBarHeight),
                            itemCount: moreLoading
                                ? reviewList.length + 2
                                : reviewList.length,
                            itemBuilder: (context, idx) {
                              if (idx < reviewList.length) {
                                return ReviewWidget(item: reviewList[idx]);
                              } else {
                                return moreLoading
                                    ? SkeletonReviewList()
                                    : SizedBox();
                              }
                            },
                            separatorBuilder: (context, idx) {
                              return Divider(
                                color: black[20],
                                height: 0.25,
                              );
                            }),
                      ),
                    ),
            )),
      );
}
