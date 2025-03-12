import 'package:rayo/model/locale_model.dart';
import 'package:rayo/utils/import_index.dart';
import 'package:rayo/utils/widget/custom_calendar_date_picker.dart';

class RecruitDateLocalePage extends StatefulWidget {
  final RoomModel roomModel;
  const RecruitDateLocalePage({required this.roomModel, super.key});
  @override
  State<RecruitDateLocalePage> createState() => _RecruitDateLocalePage();
}

class _RecruitDateLocalePage extends State<RecruitDateLocalePage> {
  @override
  void initState() {
    super.initState();
    widget.roomModel.location = '';
    widget.roomModel.date = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(context) => Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: black[80],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: black[80],
        shape: Border(bottom: BorderSide(color: black[80]!)),
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
            Spacer(),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), color: black[120]),
                child: Container(
                    width: 36,
                    height: 36,
                    margin: EdgeInsets.all(8),
                    child: CloudWidget())),
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'WhenMeet'.tr(),
                      style: TextStyle(
                          fontSize: 16,
                          height: 19.2 / 16,
                          fontWeight: FontWeight.w600,
                          color: white),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InkWell(
                      onTap: () async {
                        await dateSelector(context, date: widget.roomModel.date)
                            .then((value) => setState(() {
                                  DateTime val =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          value);
                                  DateTime mainVal =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          widget.roomModel.date);
                                  DateTime changeVal = DateTime(
                                      val.year,
                                      val.month,
                                      val.day,
                                      mainVal.hour,
                                      mainVal.minute);
                                  widget.roomModel.date =
                                      changeVal.millisecondsSinceEpoch;
                                }));
                      },
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: white[180],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            DateFormat.yMMMMd(
                                    Localizations.localeOf(context).toString())
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    widget.roomModel.date)),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 19 / 16,
                                color: black),
                          ))),
                  SizedBox(
                    height: 8,
                  ),
                  InkWell(
                      onTap: () async {
                        await timerSelector(context,
                                date: widget.roomModel.date)
                            .then((value) => setState(() {
                                  widget.roomModel.date = value;
                                }));
                        setState(() {});
                      },
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: white[180],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            DateFormat.jm(
                                    Localizations.localeOf(context).toString())
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    widget.roomModel.date)),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 19 / 16,
                                color: black),
                          ))),
                  SizedBox(
                    height: 72,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'WhereMeet'.tr(),
                      style: TextStyle(
                          fontSize: 16,
                          height: 19.2 / 16,
                          fontWeight: FontWeight.w600,
                          color: white),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  InkWell(
                      onTap: () async {
                        await setLocale(context).then((value) => setState(() {
                              widget.roomModel.location = value;
                            }));
                      },
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: white[180],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            widget.roomModel.location == ''
                                ? '장소를 입력해주세요'
                                : widget.roomModel.location,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 19 / 16,
                                color: black),
                          ))),
                  Spacer(),
                  if (widget.roomModel.location != '')
                    InkWell(
                      onTap: () async {
                        Navigator.pushNamed(
                            context, NAV_RecruitPersonGenderPage,
                            arguments: {
                              'roomModel': widget.roomModel,
                            });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: yellow),
                          width: double.infinity,
                          padding: const EdgeInsets.all(15.5),
                          child: Text(
                            'next'.tr(),
                            style: TextStyle(
                                fontSize: 16,
                                height: 19.09 / 16,
                                fontWeight: FontWeight.w700,
                                color: black),
                          )),
                    ),
                ],
              ))));

  Future<int> dateSelector(BuildContext context, {required int date}) async {
    int item = date;
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              title: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: yellow,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16)),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'confirm'.tr(),
                              style: TextStyle(
                                  color: yellow,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  height: 19 / 16),
                            ),
                            Text(
                              'Date'.tr(),
                              style: TextStyle(
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  height: 19 / 16),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                child: Text(
                                  'confirm'.tr(),
                                  style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      height: 19 / 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      CustomCalendarDatePicker(
                          currentDate: DateTime.now(),
                          initialDate: DateTime.fromMillisecondsSinceEpoch(
                              widget.roomModel.date),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                          widget.roomModel.date)
                                      .year +
                                  2,
                              12,
                              31),
                          onDateChanged: (value) {
                            item = value.millisecondsSinceEpoch;
                          }),
                    ],
                  )),
            ));
    return item;
  }

  Future<int> timerSelector(BuildContext context, {required int date}) async {
    int item = date;
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        title: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: yellow,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'confirm'.tr(),
                        style: TextStyle(
                            color: yellow,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 19 / 16),
                      ),
                      Text(
                        'Time'.tr(),
                        style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 19 / 16),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          child: Text(
                            'confirm'.tr(),
                            style: TextStyle(
                                color: white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                height: 19 / 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: CupertinoTheme(
                  data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle:
                        TextStyle(color: black, fontSize: 16, height: 19 / 16),
                  )),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime.fromMillisecondsSinceEpoch(item),
                    onDateTimeChanged: (value) {
                      item = value.millisecondsSinceEpoch;
                    },
                  ),
                ))
              ],
            )),
      ),
    );
    return item;
  }

  Future<String> setLocale(BuildContext context) async {
    double height = MediaQuery.of(context).size.height * 0.9 * 0.7 - 200;
    List<LocaleModel> localeList = [];
    String item = '';
    bool loading = false;
    final TextEditingController localeInput = TextEditingController();
    final DraggableScrollableController draggableCtl =
        DraggableScrollableController();
    final ScrollController listViewScrollCtl = ScrollController();
    Timer? debounce;
    await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (bottomContext) => GestureDetector(
            onTap: () {
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Container(
                color: Colors.transparent,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: StatefulBuilder(builder: (_, setState) {
                  listViewScrollCtl.addListener(() async {
                    await SystemChannels.textInput
                        .invokeMethod('TextInput.hide');
                  });
                  draggableCtl.addListener(() {
                    if (draggableCtl.size < 0.8) {
                      setState(() {
                        height =
                            MediaQuery.of(context).size.height * 0.9 * 0.7 -
                                200;
                      });
                    } else {
                      setState(() {
                        height = MediaQuery.of(context).size.height * 0.9 - 200;
                      });
                    }
                  });
                  return DraggableScrollableSheet(
                      controller: draggableCtl,
                      initialChildSize: 0.7,
                      minChildSize: 0.7,
                      maxChildSize: 1,
                      snap: true,
                      builder: (_, scrollController) {
                        return SingleChildScrollView(
                            physics: ClampingScrollPhysics(),
                            controller: scrollController,
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    Container(
                                      height: 92,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: yellow,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 6,
                                            width: 64,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              color: white,
                                            ),
                                          ),
                                          Container(
                                            height: 70,
                                            padding: const EdgeInsets.all(25),
                                            child: Text(
                                              '장소 선택',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                height: 19 / 16,
                                                color: black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(
                                            top: 16, left: 16, right: 16),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 12),
                                              decoration: BoxDecoration(
                                                color: white[80],
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      SvgIcon.ICON_search),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Expanded(
                                                      child: TextFormField(
                                                    controller: localeInput,
                                                    maxLines: 1,
                                                    autofocus: false,
                                                    style: TextStyle(
                                                        color: black[100],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        height: 18 / 14),
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                      border: InputBorder.none,
                                                      hintStyle: TextStyle(
                                                          fontSize: 14,
                                                          height: 18 / 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: black[80]),
                                                      hintText:
                                                          'WhereMeet'.tr(),
                                                    ),
                                                    onChanged: (val) {
                                                      if (val.length > 1) {
                                                        loading = true;
                                                        setState(() {});
                                                        if (debounce
                                                                ?.isActive ??
                                                            false) {
                                                          debounce?.cancel();
                                                        }
                                                        debounce = Timer(
                                                            const Duration(
                                                                seconds: 1),
                                                            () async {
                                                          p('주소검색 API 호출 필요');
                                                          await GetList.instance
                                                              .localeList(
                                                                  uri:
                                                                      '주소서치API')
                                                              .then((val) {
                                                            if (bottomContext
                                                                .mounted) {
                                                              if (val[statusCode] ==
                                                                  200) {
                                                                localeList =
                                                                    val[data];
                                                              }
                                                              loading = false;
                                                              setState(() {});
                                                            }
                                                          });
                                                        });
                                                      }
                                                      if (val.isEmpty) {
                                                        setState(() {});
                                                      }
                                                    },
                                                  ))
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                height: height,
                                                child: localeInput.text == ''
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SvgPicture.asset(SvgIcon
                                                              .ICON_localeInfo),
                                                          SizedBox(
                                                            height: 16,
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child: Text(
                                                              'SearchLocation'
                                                                  .tr(),
                                                              style: TextStyle(
                                                                  color:
                                                                      black[80],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  height:
                                                                      24 / 16),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : ListView.separated(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 16,
                                                                right: 16,
                                                                left: 16,
                                                                bottom: 16),
                                                        controller:
                                                            listViewScrollCtl,
                                                        itemCount: loading
                                                            ? 20
                                                            : localeList.length,
                                                        itemBuilder: (context,
                                                                idx) =>
                                                            loading
                                                                ? SkeletonLocaleList()
                                                                : LocaleListWidget(
                                                                    locale:
                                                                        localeList[
                                                                            idx],
                                                                    func:
                                                                        () async {
                                                                      item = localeList[
                                                                              idx]
                                                                          .mainLocale;
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                        separatorBuilder:
                                                            (context, idx) {
                                                          return SizedBox(
                                                            height: 16,
                                                          );
                                                        }))
                                          ],
                                        ))
                                  ],
                                )));
                      });
                }))));
    return item;
  }
}
