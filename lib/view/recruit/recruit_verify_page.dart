import 'package:rayo/utils/import_index.dart';

class RecruitVerifyPage extends StatelessWidget {
  final RoomModel roomModel;
  const RecruitVerifyPage({required this.roomModel, super.key});
  @override
  Widget build(context) => Scaffold(
      backgroundColor: black[80],
      appBar: AppBar(
        backgroundColor: black[80],
        shape: Border(bottom: BorderSide(color: black[80]!)),
        automaticallyImplyLeading: false,
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                'ReviewRecruit'.tr(),
                style: TextStyle(
                    fontSize: 16,
                    height: 19.2 / 16,
                    fontWeight: FontWeight.w600,
                    color: white),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
                padding: EdgeInsets.all(24),
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: white,
                ),
                child: Column(
                  children: [
                    Text(roomModel.name,
                        style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            height: 21 / 18)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(
                      color: black[40],
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Builder(builder: (context) {
                      RoomCat roomCat = roomModel.roomCat;
                      int selectCat = 0;
                      String firstCat = '';
                      if (roomCat.food) {
                        firstCat = 'food'.tr();
                      } else if (roomCat.amity) {
                        firstCat = 'socializing'.tr();
                      } else if (roomCat.art) {
                        firstCat = 'artsCulture'.tr();
                      } else if (roomCat.exercise) {
                        firstCat = 'sports'.tr();
                      }
                      if (roomCat.food) selectCat++;
                      if (roomCat.amity) selectCat++;
                      if (roomCat.art) selectCat++;
                      if (roomCat.exercise) selectCat++;
                      selectCat--;
                      return Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          SizedBox(
                              child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                firstCat == 'food'.tr()
                                    ? PngIcon.ICON_food
                                    : firstCat == 'socializing'.tr()
                                        ? PngIcon.ICON_amity
                                        : firstCat == 'artsCulture'.tr()
                                            ? PngIcon.ICON_art
                                            : PngIcon.ICON_exercise,
                                width: 36,
                                height: 36,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                  selectCat == 0
                                      ? firstCat
                                      : 'joinInfo'.tr(namedArgs: {
                                          'firstCat': firstCat,
                                          'selectCat': selectCat.toString()
                                        }),
                                  style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      height: 19 / 16)),
                            ],
                          )),
                          SizedBox(
                            width: 23,
                          ),
                          SizedBox(
                              child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 36,
                                child: Image.asset(
                                  roomModel.roomCat.gender == 1
                                      ? PngIcon.ICON_female_gender
                                      : roomModel.roomCat.gender == 2
                                          ? PngIcon.ICON_male_gender
                                          : PngIcon.ICON_all_gender,
                                  width: 46,
                                  height: 28,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                  '${roomModel.roomCat.gender == 1 ? 'womenOnly'.tr() : roomModel.roomCat.gender == 2 ? 'menOnly'.tr() : 'allGenders'.tr()} / ${'participants'.tr(namedArgs: {
                                        'count':
                                            roomModel.memberLimit.toString()
                                      })}',
                                  style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      height: 19 / 16)),
                            ],
                          ))
                        ],
                      );
                    }),
                  ],
                )),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () async {
                if (roomModel.memberLimit == 2 &&
                    roomModel.roomCat.gender != 0 &&
                    roomModel.roomCat.gender != LoginCtl.instance.user.gender) {
                  _cloudAlert(context);
                } else {
                  appStateKey.currentState!.allPageClose();
                  appStateKey.currentState!.goTohome();
                  await createRoom();
                  p('방 입장 API발송');
                }
              },
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25), color: yellow),
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.5),
                  child: Text(
                    'confirm'.tr(),
                    style: TextStyle(
                        fontSize: 16,
                        height: 19.09 / 16,
                        fontWeight: FontWeight.w700,
                        color: black),
                  )),
            ),
          ],
        ),
      )));
  Future<void> createRoom() async {
    p('방 생성 API발송 // 시퀀스 번호 리턴 필요');
    int roomSeq = 123;
    roomModel.seq = roomSeq;
    String? joinValue = await const MethodChannel('NativeFuncCall')
        .invokeMethod<String>('connectWebRTC', {
      'roomKey': roomSeq,
      'userKey': LoginCtl.instance.user.seq,
      'userName': LoginCtl.instance.user.name
    });
    if (joinValue == 'OK' &&
        appStateKey.currentState!.currentContext().mounted) {
      Navigator.pushNamed(
          appStateKey.currentState!.currentContext(), NAV_VideoCallPage,
          arguments: {
            'roomModel': roomModel,
          });
    }
  }

  void _cloudAlert(BuildContext context1) {
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
                      Text('cloudUseInfo'.tr(namedArgs: {'cloudCount': '11'}),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium),
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
                                child: Container(
                                  margin: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              )),
                              VerticalDivider(
                                width: 0.25,
                                color: black[40],
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    if (LoginCtl.instance.user.point.value >
                                        11) {
                                      LoginCtl.instance.user.point.value -= 11;
                                      p('11클라우드 사용하면서 방 입장 API발송 리턴 시퀀스 필요');
                                      appStateKey.currentState!.allPageClose();
                                      appStateKey.currentState!.goTohome();
                                      await createRoom();
                                    } else {
                                      if (context1.mounted) {
                                        InAppPurchaseCtl.instance
                                            .needCloud(context1);
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(15),
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
                                          '11',
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
                              ),
                            ],
                          )),
                    ],
                  )),
            ));
  }
}
