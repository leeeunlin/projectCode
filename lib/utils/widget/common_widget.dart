import 'package:rayo/model/locale_model.dart';
import 'package:rayo/utils/import_index.dart';

class BackBtn extends StatelessWidget {
  final VoidCallback func;

  final Color color;

  const BackBtn({
    required this.func,
    this.color = black,
    super.key,
  });

  @override
  Widget build(context) => InkWell(
      onTap: () async {
        func();
      },
      child: Container(
          alignment: Alignment.center,
          child: SvgPicture.asset(SvgIcon.ICON_arrowBack,
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn,
              ))));
}

class UserListWidget extends StatelessWidget {
  final UserModel user;
  const UserListWidget({required this.user, super.key});
  @override
  Widget build(context) => Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(SvgIcon.ICON_bottomProfile,
                  width: 50,
                  height: 50,
                  theme: SvgTheme(
                    currentColor: Color(0xFFDCDCE6),
                  )),
              if (user.profileImg != '')
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(user.profileImg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 21 / 14),
              ),
              if (user.introduce != '')
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    user.introduce,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 16 / 12),
                  ),
                ),
            ],
          )),
        ],
      );
}

class LocaleListWidget extends StatelessWidget {
  final LocaleModel locale;
  final VoidCallback func;
  const LocaleListWidget({required this.locale, required this.func, super.key});
  @override
  Widget build(context) => InkWell(
        onTap: () async {
          func();
        },
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(locale.mainLocale,
                  style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 21 / 14)),
              Text(
                locale.detailedLocale,
                style: TextStyle(
                    color: black[60],
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 21 / 12),
              )
            ],
          ),
        ),
      );
}

class ActionBtn extends StatelessWidget {
  final VoidCallback func;
  final String asset;
  final Color color;
  final int? cloud;

  const ActionBtn({
    required this.func,
    this.color = black,
    required this.asset,
    this.cloud,
    super.key,
  });

  @override
  Widget build(context) => InkWell(
      onTap: () async {
        func();
      },
      child: SizedBox(
          width: 30,
          height: 30,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if (asset.endsWith('svg'))
                SvgPicture.asset(
                  asset,
                ),
              if (asset.endsWith('png')) Image.asset(asset),
              if (cloud != null)
                Positioned(
                    bottom: 0,
                    child: Text(cloud.toString(),
                        style: TextStyle(
                          fontFamily: 'MCMerchant',
                          fontSize: 6,
                          height: 9.6 / 6,
                          color: black[60],
                        )))
            ],
          )));
}

Future<String> countryCodeSelecter(context, {required String myCode}) async {
  String selectCode = '';
  String tmpSelectCode = '';
  List<Container> item = [];
  int startIndex = 0;
  for (int i = 0; i < countryCode.length; i++) {
    String code = countryToNumber[countryCode[i]]!;
    String contryName = myCode == 'KR'
        ? countryToKr[countryCode[i]]!
        : countryToEn[countryCode[i]]!;

    if (countryCode[i] == myCode) {
      startIndex = i;
    }
    item.add(Container(
      alignment: Alignment.center,
      child: Text(
        '$code $contryName',
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
            height: 26.25 / 22,
            color: black),
      ),
    ));
  }
  await showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) => Container(
          width: MediaQuery.of(context).size.width,
          height: 280 + 49,
          color: black[40],
          child: Column(
            children: [
              Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                      color: white,
                      border: Border(
                          top: BorderSide(
                              color: Color(0xFFC8C8D2), width: 0.25))),
                  height: 49,
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                      onTap: () {
                        selectCode = tmpSelectCode;
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'complete'.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              height: 16.71 / 14,
                              color: yellow),
                        ),
                      ))),
              Expanded(
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: startIndex),
                  backgroundColor: black[40],
                  itemExtent: 58,
                  onSelectedItemChanged: (value) {
                    tmpSelectCode = countryCode[value];
                  },
                  children: item,
                ),
              ),
            ],
          )));
  return selectCode;
}

Future<Map<String, dynamic>> dateSelecter(context, {required int date}) async {
  Map<String, dynamic> item = {
    'select': false,
  };
  DateTime tmpSelectDate = date == 0
      ? DateTime.parse('1998-11-21')
      : DateTime.fromMillisecondsSinceEpoch(date);
  await showModalBottomSheet(
    barrierColor: Colors.transparent,
    context: context,
    builder: (_) => SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        color: black[40],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                  color: white,
                  border: Border(
                      top: BorderSide(color: Color(0xFFC8C8D2), width: 0.25))),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: () {
                  item['select'] = true;
                  item['dateTime'] = tmpSelectDate.millisecondsSinceEpoch;
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'complete'.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 16.71 / 14,
                        color: yellow),
                  ),
                ),
              ),
            ),
            Expanded(
                child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: tmpSelectDate,
              onDateTimeChanged: (value) {
                tmpSelectDate = value;
              },
            ))
          ],
        ),
      ),
    ),
  );
  return item;
}

/// 이미지 선택 페이지 팝업
///
/// [bottomSheet] 형식으로 팝업되도록 설정되어있으며
/// [SelectImagePage] 를 페이지처리하면 페이지로 적용 가능하다.
Future<List<CnvImgMd>> showSelectImage(context,
    {required bool multiSelect, bool profile = false}) async {
  List<CnvImgMd> items = [];
  var tmp = await showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black,
      backgroundColor: Colors.black,
      builder: (_) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SelectImagePage(
            multiSelect: multiSelect,
            profile: profile,
          )));
  if (tmp != null) {
    items = tmp;
  }
  return items;
}

AlertDialog defaultAlertDalog(BuildContext context, String txt,
    {Color? color = yellow, TextStyle? style}) {
  return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      title: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 22),
        // width: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.symmetric(horizontal: 37, vertical: 22),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24), color: color),
        child: Text(
          txt,
          style: style ?? Theme.of(context).textTheme.titleLarge,
        ),
      ));
}

AlertDialog rejectPopup(BuildContext context) {
  return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      title: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24), color: white),
        child: Column(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(SvgIcon.ICON_bang,
                  theme: const SvgTheme(currentColor: red)),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'reject'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 24 / 16,
                    color: black),
              ),
            )
          ],
        ),
      ));
}

Future<void> durationPopup(BuildContext context, AlertDialog dialog) async {
  await showDialog(
      barrierDismissible: false,
      barrierColor: const Color(0x80000000),
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
        return dialog;
      });
}

/// 프로필 이미지 설정에 사용되는 팝업
///
/// [showSelectImage] 함수가 포함되어있으며 [showSelectImage]는 개별 사용 가능함
Future<List<int>> profileImgSelectPage(BuildContext context) async {
  List<int> item = [];
  bool photo = await Permission.photos.request().isGranted;
  bool photoAddOnly = await Permission.photosAddOnly.request().isGranted;
  if (context.mounted && (photo || photoAddOnly)) {
    List<CnvImgMd> itemList =
        await showSelectImage(context, multiSelect: false, profile: true);
    if (itemList.isNotEmpty) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          maxWidth: 800,
          maxHeight: 800,
          sourcePath: itemList[0].path!,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.square,
          // ],

          uiSettings: [
            AndroidUiSettings(
              cropStyle: CropStyle.circle,
              toolbarTitle: 'cropImg'.tr(),
              statusBarColor: Colors.black,
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: yellow,
              showCropGrid: false,
              cropFrameColor: Colors.transparent,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              hideBottomControls: false,
            ),
            IOSUiSettings(
              title: 'cropImg'.tr(),
              cropStyle: CropStyle.circle,
              aspectRatioLockEnabled: true,
              hidesNavigationBar: true,
              aspectRatioLockDimensionSwapEnabled: true,
              aspectRatioPickerButtonHidden: true,
              doneButtonTitle: 'confirm'.tr(),
              cancelButtonTitle: 'cancel'.tr(),
            )
          ]);
      if (croppedFile != null) {
        item = await croppedFile.readAsBytes();
      }
    }
  }
  return item;
}

// 스넥바 UI
void snackBar({String? title, required String content}) {
  final snackbar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      padding: EdgeInsets.symmetric(horizontal: 16),
      duration: Duration(seconds: 1),
      content: Container(
          width: double.infinity,
          height: 50,
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: black,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title,
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.w600, fontSize: 16),
                ),
              Text(
                content,
                style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.w600,
                    fontSize: title == null ? 16 : 12),
              ),
            ],
          )));
  scaffoldMessengerKey.currentState!.clearSnackBars();
  scaffoldMessengerKey.currentState!.showSnackBar(snackbar);
}
// snackBar(content: '잠시 후 다시 시도해주세요.');

class GridViewRoomWidget extends StatelessWidget {
  final RoomModel roomModel;
  final VoidCallback func;
  final bool review;
  final bool hosted;
  final bool history;

  /// func에 대한 설명
  /// `review : true` 리뷰 작성 페이지로 이동
  /// `hosted : true` 다시모집하기(방 생성되어 이동)
  /// `review, hosted 둘다 false`인 경우 참여 취소하기 다이얼로그에서 참여 번개목록 삭제처리
  const GridViewRoomWidget(
      {required this.roomModel,
      required this.func,
      this.review = false,
      this.hosted = false,
      this.history = false,
      super.key});
  @override
  Widget build(context) {
    void joinCancel() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              title: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 34, vertical: 22),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            'areSureCancelParticipation'.tr(),
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 24 / 16),
                          ),
                        ],
                      ),
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
                                onTap: () async {
                                  Navigator.pop(context);
                                  await durationPopup(
                                      context,
                                      defaultAlertDalog(
                                          context, 'complete'.tr(),
                                          color: mint,
                                          style: TextStyle(
                                              color: white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              height: 19 / 16)));
                                  func();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'CancelParticipation'.tr(),
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
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'No'.tr(),
                                    style: TextStyle(
                                        color: black[60],
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
              ),
            );
          });
    }

    void showMenuDialog(Offset offset) {
      showDialog(
        context: context,
        builder: (context) => Container(
            margin: EdgeInsets.only(
                top: offset.dy - 50,
                left: offset.dx +
                    (Localizations.localeOf(context).languageCode == 'ar'
                        ? 24
                        : -94)),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  children: [
                    if (hosted)
                      Container(
                          width: 106,
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: white),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  p('메시지 보내기(채팅방 이동)');
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  child: Text(
                                    'sendMessage'.tr(),
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        height: 15 / 10),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 0.25,
                              color: black[40],
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  p('참여자 프로필 보는 페이지로 이동');
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  child: Text(
                                    'participantProfile'.tr(),
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        height: 15 / 10),
                                  ),
                                ),
                              ),
                            ),
                          ])),
                    if (!hosted)
                      Container(
                          width: 106,
                          height: 105,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: white),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  p('메시지 보내기(채팅방 이동)');
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  child: Text(
                                    'sendMessage'.tr(),
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        height: 15 / 10),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 0.25,
                              color: black[40],
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  p('참여자 프로필 보는 페이지로 이동');
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  child: Text(
                                    'participantProfile'.tr(),
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        height: 15 / 10),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 0.25,
                              color: black[40],
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  joinCancel();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  child: Text(
                                    'cancelParticipation'.tr(),
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        height: 15 / 10),
                                  ),
                                ),
                              ),
                            ),
                          ]))
                  ],
                ),
              ),
            )),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(roomModel.master.profileImg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: roomModel.completed
                        ? black[160]
                        : history &&
                                roomModel.memberCount == roomModel.memberLimit
                            ? black[160]
                            : black[120]),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Opacity(
                                opacity: roomModel.completed ? 0.6 : 1,
                                child: Row(
                                  children: [
                                    if (roomModel.roomCat.food)
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: mint[2],
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Text(
                                          'food'.tr(),
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 8,
                                              height: 9.55 / 8,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    if (roomModel.roomCat.amity)
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: mint[2],
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Text(
                                          'socializing'.tr(),
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 8,
                                              height: 9.55 / 8,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    if (roomModel.roomCat.art)
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: mint[2],
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Text(
                                          'artsCulture'.tr(),
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 8,
                                              height: 9.55 / 8,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    if (roomModel.roomCat.exercise)
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: mint[2],
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Text(
                                          'sports'.tr(),
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 8,
                                              height: 9.55 / 8,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: black[120],
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Text(
                                        roomModel.roomCat.gender == 1
                                            ? 'womenOnly'.tr()
                                            : roomModel.roomCat.gender == 2
                                                ? 'menOnly'.tr()
                                                : 'allGenders'.tr(),
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 8,
                                            height: 9.55 / 8,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: black[120],
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Text(
                                        '(${roomModel.memberCount}/${roomModel.memberLimit})',
                                        style: TextStyle(
                                            color: yellow,
                                            fontSize: 8,
                                            height: 9.55 / 8,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (!review && !history)
                            Builder(builder: (context) {
                              final GlobalKey dialogKey = GlobalKey();
                              return InkWell(
                                key: dialogKey,
                                onTap: () {
                                  showMenuDialog((dialogKey.currentContext!
                                          .findRenderObject() as RenderBox)
                                      .localToGlobal(Offset.zero));
                                },
                                child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: SvgPicture.asset(
                                      SvgIcon.ICON_moreHoriz,
                                      width: 20,
                                      height: 4,
                                    )),
                              );
                            }),
                          SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      Spacer(),
                      Opacity(
                        opacity: roomModel.completed ? 0.6 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    SvgIcon.ICON_roomMaster,
                                    width: 10,
                                    height: 6,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    roomModel.master.name,
                                    style: TextStyle(
                                        color: white,
                                        fontSize: 8,
                                        height: 9.55 / 8,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(width: 1, color: yellow),
                                  color: black[120]),
                              child: Text(
                                roomModel.name,
                                style: TextStyle(
                                    color: white,
                                    fontSize: 8,
                                    height: 9.55 / 8,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                      if (hosted)
                        InkWell(
                          onTap: () {
                            if (!roomModel.completed) {
                              func();
                            }
                          },
                          child: Container(
                              height: 58,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              color:
                                  roomModel.completed ? white[90] : yellow[1]!,
                              child: Row(
                                children: [
                                  Text(
                                    'RecruitAgain'.tr(),
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 14,
                                        height: 21 / 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: white),
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.diagonal3Values(
                                          -1, 1, 1), // 좌우 반전
                                      child: SvgPicture.asset(
                                        SvgIcon.ICON_arrowBack,
                                        colorFilter: ColorFilter.mode(
                                            roomModel.completed
                                                ? white[90]!
                                                : yellow[1]!,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        )
                    ],
                  ),
                ),
              ),
              if (review)
                InkWell(
                    onTap: () {
                      func();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: white),
                      child: Text(
                        'LeaveReview'.tr(),
                        style: TextStyle(
                            color: black,
                            fontSize: 14,
                            height: 27 / 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ))
            ],
          ),
        ),
        if (!review)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            width: double.infinity,
            child: Text(
              textAlign: TextAlign.start,
              DateFormat.yMMMd(Localizations.localeOf(context).toString())
                  .add_jm()
                  .format(DateTime.fromMillisecondsSinceEpoch(roomModel.date)),
              style: TextStyle(
                  color: black[80],
                  fontWeight: FontWeight.w400,
                  fontSize: 8,
                  height: 12 / 8),
            ),
          )
      ],
    );
  }
}

class CloudWidget extends StatelessWidget {
  final Color color;
  const CloudWidget({this.color = white, super.key});
  @override
  Widget build(context) => InkWell(
        onTap: () {
          Navigator.pushNamed(context, NAV_ShopPage);
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              PngIcon.ICON_cloud,
              width: 28,
            ),
            Positioned(
              bottom: 0,
              child: ValueListenableBuilder<int>(
                valueListenable: LoginCtl.instance.user.point,
                builder: (context, point, child) {
                  return Text(point > 9999 ? '9999+' : point.toString(),
                      style: TextStyle(
                        fontFamily: 'MCMerchant',
                        fontSize: 10,
                        height: 15 / 10,
                        color: color,
                      ));
                },
              ),
            )
          ],
        ),
      );
}
