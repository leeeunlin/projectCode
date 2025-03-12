import 'package:rayo/utils/import_index.dart';

class ReviewWritePage extends StatefulWidget {
  final RoomModel roomModel;
  const ReviewWritePage({required this.roomModel, super.key});

  @override
  State<ReviewWritePage> createState() => _ReviewWritePageState();
}

class _ReviewWritePageState extends State<ReviewWritePage> {
  List<CnvImgMd> tmpImageSet = [];
  PageController pageCtl = PageController(viewportFraction: 0.9);
  TextEditingController txtdetail = TextEditingController();
  double rating = 0.0;
  @override
  Widget build(context) => GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
        },
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
              actions: [
                ValueListenableBuilder(
                    valueListenable: ReviewCtl.instance.loadingVal,
                    builder: (_, loading, child) => InkWell(
                        onTap: () async {
                          ReviewModel reviewModel = ReviewModel.fromJson({});
                          reviewModel.txtdetail = txtdetail.text;
                          reviewModel.rating = rating;
                          reviewModel.room = widget.roomModel;
                          ReviewModel review =
                              await ReviewCtl.instance.writeReview(reviewModel);
                          p(review.toJson());
                          if (context.mounted) {
                            Navigator.pop(context, widget.roomModel);
                          }
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: loading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Text(
                                    'save'.tr(),
                                    style: TextStyle(
                                        color: yellow,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        height: 16.71 / 14),
                                  ))))
              ],
              shape: Border(bottom: BorderSide(color: black[40]!, width: 0.25)),
              leading: BackBtn(func: () => Navigator.pop(context)),
            ),
            body: SafeArea(
                child: Container(
              margin: EdgeInsets.all(16),
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    DottedBorder(
                        borderType: BorderType.RRect,
                        padding: EdgeInsets.zero,
                        radius: const Radius.circular(16),
                        color: yellow,
                        strokeWidth: 2,
                        dashPattern: const <double>[4, 3],
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: black[120]),
                            child: Text(
                              widget.roomModel.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: black,
                                  fontSize: 18,
                                  height: 21 / 18),
                            ))),
                    SizedBox(
                      height: 12,
                    ),
                    Text('HowWasMeetup'.tr(),
                        style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 21 / 12)),
                    SizedBox(
                      height: 16,
                    ),
                    InkWell(onTap: () async {
                      bool photo = await Permission.photos.request().isGranted;
                      bool photoAddOnly =
                          await Permission.photosAddOnly.request().isGranted;
                      if (context.mounted && (photo || photoAddOnly)) {
                        List<CnvImgMd> tmp =
                            await showSelectImage(context, multiSelect: true);
                        if (tmp.isNotEmpty) {
                          tmpImageSet = tmp;
                          if (pageCtl.hasClients) {
                            pageCtl.jumpTo(0);
                          }
                        }
                        setState(() {});
                      }
                    }, child: LayoutBuilder(builder: (_, constraints) {
                      double infinityWidth = constraints.maxWidth;
                      return Container(
                          alignment: Alignment.topCenter,
                          width: infinityWidth,
                          height: infinityWidth,
                          color: tmpImageSet.isEmpty ? white[80] : white,
                          child: tmpImageSet.isEmpty
                              ? Center(
                                  child: SvgPicture.asset(
                                      width: 50,
                                      height: 50,
                                      SvgIcon.ICON_selectImage),
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: infinityWidth * 0.9,
                                      child: PageView.builder(
                                          controller: pageCtl,
                                          itemCount: tmpImageSet.length,
                                          itemBuilder: (_, idx) {
                                            return Container(
                                                margin: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: MemoryImage(
                                                            tmpImageSet[idx]
                                                                    .memoryImage
                                                                as Uint8List),
                                                        fit: BoxFit.cover)),
                                                child: Container(
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          tmpImageSet
                                                              .removeAt(idx);
                                                          if (tmpImageSet
                                                                  .isNotEmpty &&
                                                              pageCtl.page
                                                                      ?.toInt() ==
                                                                  tmpImageSet
                                                                      .length) {
                                                            pageCtl.jumpTo(0);
                                                          }

                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                            width: 36,
                                                            height: 36,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    black[80],
                                                                border: Border.all(
                                                                    color:
                                                                        white,
                                                                    width:
                                                                        1.5)),
                                                            child: SvgPicture
                                                                .asset(SvgIcon
                                                                    .ICON_close)),
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                          }),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: infinityWidth * 0.1,
                                        child: SmoothPageIndicator(
                                          controller: pageCtl,
                                          count: tmpImageSet.length,
                                          effect: SwapEffect(
                                              dotWidth: 6.0,
                                              dotHeight: 6.0,
                                              spacing: 10.0,
                                              dotColor: black[20]!,
                                              activeDotColor: black[80]!),
                                        ))
                                  ],
                                ));
                    })),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: black[40]!, width: 0.5)),
                        child: TextFormField(
                          controller: txtdetail,
                          maxLines: null,
                          maxLength: 100,
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 24 / 16,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: 'LeaveReviewMeetup'.tr(),
                            hintStyle: TextStyle(
                              color: black[40],
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 24 / 16,
                            ),
                          ).copyWith(
                            counterText: '',
                          ),
                          onChanged: (_) {
                            setState(() {});
                          },
                        )),
                    SizedBox(
                        width: double.infinity,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                        color: black[40],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 8,
                                        height: 18 / 8,
                                      ),
                                      children: [
                                    TextSpan(
                                        text: '(${txtdetail.text.length}',
                                        style: TextStyle(color: black)),
                                    TextSpan(text: '/100)'),
                                  ]))
                            ])),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 1; i <= 5; i++)
                          InkWell(
                              onTap: () async {
                                if (rating == i) {
                                  rating = i - 0.5;
                                } else {
                                  rating = i.toDouble();
                                }
                                p(rating);
                                // p('api 레이팅 발송 ${widget.item.rating}');
                                setState(() {});
                              },
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  SizedBox(
                                      width: 44,
                                      height: 44,
                                      child: SvgPicture.asset(
                                        SvgIcon.ICON_ratingstars,
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                          i - 1 < rating ? yellow : black[40]!,
                                          BlendMode.srcIn,
                                        ),
                                      )),
                                  if ((i == rating.ceil() && rating % 1 == 0.5))
                                    ClipRect(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        widthFactor: 0.52,
                                        heightFactor: 1.0,
                                        child: SvgPicture.asset(
                                          SvgIcon.ICON_ratingstars,
                                          fit: BoxFit.cover,
                                          width: 44,
                                          height: 44,
                                          colorFilter: ColorFilter.mode(
                                            black[40]!,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ))
                      ],
                    ),
                  ],
                ),
              ),
            ))),
      );
}
