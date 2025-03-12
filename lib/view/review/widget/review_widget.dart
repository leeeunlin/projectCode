import 'package:rayo/utils/import_index.dart';
import 'dart:ui' as ui;

class ReviewWidget extends StatefulWidget {
  final ReviewModel item;
  const ReviewWidget({required this.item, super.key});

  @override
  State<ReviewWidget> createState() => _ReviewWidget();
}

class _ReviewWidget extends State<ReviewWidget> {
  bool expandTxt = false;

  PageController pageCtl = PageController();

  @override
  Widget build(BuildContext context) {
    void blockVerify() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              title: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 68,
                        padding: EdgeInsets.symmetric(vertical: 22),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16)),
                            color: mint),
                        child: Text(
                          'blockedthisuser'.tr(),
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 24 / 16),
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          height: 134,
                          padding: EdgeInsets.symmetric(
                              horizontal: 42, vertical: 22),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: double.infinity,
                                  child: AutoSizeText(
                                    '차단 친구와는 서로 번개모임, 대화방, 담벼락(후기)을 볼 수 없습니다.',
                                    maxLines: 2,
                                    minFontSize: 1,
                                    style: TextStyle(
                                        color: black[80],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        height: 18 / 12),
                                    textAlign: TextAlign.center,
                                  )),
                              SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    ' ',
                                    style: TextStyle(
                                        color: black[80],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        height: 18 / 12),
                                    textAlign: TextAlign.center,
                                  )),
                              SizedBox(
                                  width: double.infinity,
                                  child: AutoSizeText(
                                    '추후 [설정 > 차단 친구 목록]에서 해지할 수 있습니다.',
                                    maxLines: 2,
                                    minFontSize: 1,
                                    style: TextStyle(
                                        color: black[80],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        height: 18 / 12),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ))
                    ],
                  ))));
    }

    Future<bool> blockedPopup() async {
      bool? item = await showDialog(
          context: context,
          builder: (context1) => AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              title: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 22),
                        child: Text(
                          'wanttoblockthisuser'.tr(),
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 24 / 16),
                        )),
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
                                  Navigator.pop(context1, true);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: AutoSizeText(
                                    maxLines: 2,
                                    minFontSize: 1,
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
                          VerticalDivider(
                            width: 0.25,
                            color: black[40],
                          ),
                          Expanded(
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context1, false);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: AutoSizeText(
                                    maxLines: 2,
                                    minFontSize: 1,
                                    textAlign: TextAlign.center,
                                    'cancel'.tr(),
                                    style: TextStyle(
                                        color: black[40],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        height: 19 / 16),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )));
      return item ?? false;
    }

    Future<void> reviewOptions({required UserModel userModel}) async {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context1) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'block'.tr(),
                  style: TextStyle(
                      color: Color(0xFF007AFF),
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      height: 24 / 20),
                ),
                onPressed: () async {
                  Navigator.pop(context1);
                  bool block = await blockedPopup();
                  if (block) {
                    blockVerify();
                    await Future.delayed(Duration(seconds: 1));

                    p('${userModel.name} 차단하기API 호출');
                    await reviewListPageStateKey.currentState!.initGetList();
                  }
                },
              ),
              CupertinoActionSheetAction(
                child: Text('report'.tr(),
                    style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        height: 24 / 20)),
                onPressed: () async {
                  Navigator.pop(context1);
                  Navigator.pushNamed(context, NAV_ReportPage,
                      arguments: {'userModel': userModel}).then((val) async {
                    if (val == true) {
                      await reviewListPageStateKey.currentState!.initGetList();
                    }
                  });
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'cancel'.tr(),
                style: TextStyle(
                    color: Color(0xFF007AFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    height: 24 / 20),
              ),
              onPressed: () {
                Navigator.pop(context1);
              },
            ),
          );
        },
      );
    }

    return Column(
      children: [
        SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: widget.item.writer.profileImg != ''
                                  ? DecorationImage(
                                      image: NetworkImage(cdnUri +
                                          widget.item.writer.profileImg),
                                      fit: BoxFit.cover)
                                  : null),
                          child: widget.item.writer.profileImg == ''
                              ? SvgPicture.asset(
                                  SvgIcon.ICON_bottomProfile,
                                  theme: SvgTheme(currentColor: black[20]!),
                                )
                              : null),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.item.writer.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            height: 24 / 15,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await reviewOptions(userModel: widget.item.writer);
                  },
                  child: Container(
                      width: 52,
                      height: 52,
                      padding: const EdgeInsets.all(16),
                      child: SvgPicture.asset(SvgIcon.ICON_moreHoriz)),
                )
              ],
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: PageView.builder(
            itemCount: widget.item.imgDetail.length,
            controller: pageCtl,
            onPageChanged: (value) {
              setState(() {});
            },
            itemBuilder: (context, idx) => Image.network(
              widget.item.imgDetail[idx],
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            width: double.infinity,
            child: SmoothPageIndicator(
                controller: pageCtl, // PageController
                count: widget.item.imgDetail.length,
                effect: SwapEffect(
                    dotWidth: 6.0,
                    dotHeight: 6.0,
                    spacing: 10.0,
                    dotColor: black[20]!,
                    activeDotColor: black[80]!), // your preferred effect
                onDotClicked: (index) {
                  pageCtl.jumpToPage(index);
                  setState(() {});
                })),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            height: 33,
            width: double.infinity,
            child: Row(
              children: [
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16), color: yellow),
                    child: Text(
                      widget.item.room.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          height: 21 / 15,
                          color: white),
                    )),
                const SizedBox(
                  width: 10,
                ),
                ratingWidget()
              ],
            )),
        InkWell(
          onTap: () {
            expandTxt = !expandTxt;
            setState(() {});
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              width: double.infinity,
              child: LayoutBuilder(builder: (context, constraints) {
                final textSpan = TextSpan(
                    text: widget.item.txtdetail,
                    style: DefaultTextStyle.of(context).style);
                final textPainter = TextPainter(
                  text: textSpan,
                  maxLines: 2,
                  textDirection: ui.TextDirection.ltr,
                );
                textPainter.layout(maxWidth: constraints.maxWidth);
                final isOverflowing = textPainter.didExceedMaxLines;
                return Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Text(
                      widget.item.txtdetail,
                      maxLines: expandTxt ? 100 : 2,
                    ),
                    if (isOverflowing && !expandTxt)
                      Positioned(
                        right: 0,
                        child: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.white,
                            child: Text('   ... 더보기')),
                      )
                  ],
                );
              })),
        )
      ],
    );
  }

  Widget ratingWidget() {
    return Row(
      children: [
        for (int i = 0; i < 5; i++)
          Stack(
            alignment: Alignment.centerRight,
            children: [
              SizedBox(
                  width: 22,
                  height: 22,
                  child: SvgPicture.asset(
                    SvgIcon.ICON_ratingstars,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      i - 1 < widget.item.rating ? yellow : black[60]!,
                      BlendMode.srcIn,
                    ),
                  )),
              if ((i == widget.item.rating.ceil() &&
                  widget.item.rating % 1 == 0.5))
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerRight,
                    widthFactor: 0.52,
                    heightFactor: 1.0,
                    child: SvgPicture.asset(
                      SvgIcon.ICON_ratingstars,
                      fit: BoxFit.cover,
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        black[60]!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                )
            ],
          )
      ],
    );
  }
}
