import 'dart:ui';

import 'package:rayo/utils/import_index.dart';

class SearchListWidget extends StatelessWidget {
  final RoomModel roomModel;

  const SearchListWidget({required this.roomModel, super.key});
  @override
  Widget build(context) => InkWell(
        onTap: () async {
          _cloudAlert(context, SearchCtl.instance.calcFilter());
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Color(0x80FFFFFF),
                height: 50,
                child: Row(
                  children: [
                    Container(
                        height: 54,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(roomModel.master.profileImg),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              color: black.withAlpha(0),
                            ),
                          ),
                        )),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (roomModel.roomCat.food)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: SearchCtl.instance.food
                                        ? mint[2]
                                        : black[120],
                                    borderRadius: BorderRadius.circular(16)),
                                child: Text(
                                  'food'.tr(),
                                  style: TextStyle(
                                      color: white,
                                      fontSize: 10,
                                      height: 12 / 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            if (roomModel.roomCat.amity)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: SearchCtl.instance.amity
                                        ? mint[2]
                                        : black[120],
                                    borderRadius: BorderRadius.circular(16)),
                                child: Text(
                                  'socializing'.tr(),
                                  style: TextStyle(
                                      color: white,
                                      fontSize: 10,
                                      height: 12 / 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            if (roomModel.roomCat.art)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: SearchCtl.instance.art
                                        ? mint[2]
                                        : black[120],
                                    borderRadius: BorderRadius.circular(16)),
                                child: Text(
                                  'artsCulture'.tr(),
                                  style: TextStyle(
                                      color: white,
                                      fontSize: 10,
                                      height: 12 / 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            if (roomModel.roomCat.exercise)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: SearchCtl.instance.exercise
                                        ? mint[2]
                                        : black[120],
                                    borderRadius: BorderRadius.circular(16)),
                                child: Text(
                                  'sports'.tr(),
                                  style: TextStyle(
                                      color: white,
                                      fontSize: 10,
                                      height: 12 / 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: black[120],
                                  borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    roomModel.roomCat.gender == 0
                                        ? PngIcon.ICON_all_gender
                                        : roomModel.roomCat.gender == 1
                                            ? PngIcon.ICON_female_gender
                                            : PngIcon.ICON_male_gender,
                                    width: 14,
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    roomModel.roomCat.gender == 1
                                        ? 'womenOnly'.tr()
                                        : roomModel.roomCat.gender == 2
                                            ? 'menOnly'.tr()
                                            : 'allGenders'.tr(),
                                    style: TextStyle(
                                        color: white,
                                        fontSize: 10,
                                        height: 12 / 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: yellow,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16))),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 34,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: black[120],
                          borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        roomModel.name,
                        style: TextStyle(
                            color: white,
                            fontSize: 12,
                            height: 14.32 / 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${roomModel.location} ',
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  height: 14.32 / 12),
                            ),
                            Text(
                              DateFormat('MM/dd(E) a h:mm', 'ko_KR').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      roomModel.date)),
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  height: 14.32 / 12),
                            ),
                            SizedBox(width: 8),
                            SvgPicture.asset(
                              SvgIcon.ICON_roomMaster,
                              width: 12,
                              height: 7,
                            ),
                            SizedBox(width: 3.5),
                            Text(
                              roomModel.master.name,
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  height: 14.32 / 12),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '(${roomModel.memberCount}/${roomModel.memberLimit})',
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  height: 14.32 / 12),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
  void _cloudAlert(BuildContext context1, int calcCloud) {
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
                      Text(
                          'cloudUseInfo'.tr(namedArgs: {
                            'cloudCount': (calcCloud * 11 + 33).toString()
                          }),
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(
                        height: 22,
                      ),
                      if (calcCloud != 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 13),
                                constraints: BoxConstraints(
                                  minWidth: 132,
                                ),
                                height: 68,
                                decoration: BoxDecoration(
                                    border: Border(
                                  top: BorderSide(color: white, width: 2.0),
                                )),
                                child: Builder(builder: (context) {
                                  int selectCat = 0;
                                  String firstCat = '';
                                  if (SearchCtl.instance.food) {
                                    firstCat = 'food'.tr();
                                  } else if (SearchCtl.instance.amity) {
                                    firstCat = 'socializing'.tr();
                                  } else if (SearchCtl.instance.art) {
                                    firstCat = 'artsCulture'.tr();
                                  } else if (SearchCtl.instance.exercise) {
                                    firstCat = 'sports'.tr();
                                  }
                                  if (SearchCtl.instance.food) selectCat++;
                                  if (SearchCtl.instance.amity) selectCat++;
                                  if (SearchCtl.instance.art) selectCat++;
                                  if (SearchCtl.instance.exercise) selectCat++;
                                  selectCat--;
                                  return Row(
                                    children: [
                                      if (!(!SearchCtl.instance.food &&
                                          !SearchCtl.instance.amity &&
                                          !SearchCtl.instance.art &&
                                          !SearchCtl.instance.exercise))
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                firstCat == 'food'.tr()
                                                    ? PngIcon.ICON_food
                                                    : firstCat ==
                                                            'socializing'.tr()
                                                        ? PngIcon.ICON_amity
                                                        : firstCat ==
                                                                'artsCulture'
                                                                    .tr()
                                                            ? PngIcon.ICON_art
                                                            : PngIcon
                                                                .ICON_exercise,
                                                width: 30,
                                                height: 30,
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                selectCat == 0
                                                    ? firstCat
                                                    : 'joinInfo'.tr(namedArgs: {
                                                        'firstCat': firstCat,
                                                        'selectCat':
                                                            selectCat.toString()
                                                      }),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (SearchCtl.instance.gender != 99)
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  SearchCtl.instance.gender == 1
                                                      ? PngIcon
                                                          .ICON_female_gender
                                                      : SearchCtl.instance
                                                                  .gender ==
                                                              2
                                                          ? PngIcon
                                                              .ICON_male_gender
                                                          : PngIcon
                                                              .ICON_all_gender,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  SearchCtl.instance.gender == 1
                                                      ? 'womenOnly'.tr()
                                                      : SearchCtl.instance
                                                                  .gender ==
                                                              2
                                                          ? 'menOnly'.tr()
                                                          : 'allGenders'.tr(),
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: 16,
                                                      height: 24 / 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ))
                                    ],
                                  );
                                })),
                          ],
                        ),
                      SizedBox(
                        height: 8,
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
                                  onTap: () async {
                                    Navigator.pop(context);
                                    if (LoginCtl.instance.user.point.value >=
                                        calcCloud * 11 + 33) {
                                      LoginCtl.instance.user.point.value -=
                                          calcCloud * 11 + 33;
                                      // TODO : android 검색리스트 조인 시 UI세팅 이후 처리
                                      String? joinValue =
                                          await const MethodChannel(
                                                  'NativeFuncCall')
                                              .invokeMethod<String>(
                                                  'connectWebRTC', {
                                        'roomKey': roomModel.seq,
                                        'userKey': LoginCtl.instance.user.seq,
                                        'userName': LoginCtl.instance.user.name
                                      });

                                      if (joinValue == 'OK' &&
                                          context1.mounted) {
                                        Navigator.pushNamed(
                                            context1, NAV_VideoCallPage,
                                            arguments: {
                                              'roomModel': roomModel,
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
                                    margin: const EdgeInsets.all(15),
                                    height: 23,
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
                                        SizedBox(
                                          height: 23,
                                          child: Text(
                                            (calcCloud * 11 + 33).toString(),
                                            style: TextStyle(
                                              fontFamily: 'MCMerchant',
                                              fontSize: 12,
                                              height: 19.2 / 12,
                                              fontWeight: FontWeight.w400,
                                              color: black[60],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        SizedBox(
                                          height: 23,
                                          child: Text(
                                            'usage'.tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                height: 19 / 16,
                                                color: mint[2]),
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
                            ],
                          )),
                    ],
                  )),
            ));
  }
}
