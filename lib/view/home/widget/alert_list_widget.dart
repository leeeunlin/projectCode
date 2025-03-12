import 'package:rayo/model/alert_model.dart';
import 'package:rayo/utils/import_index.dart';
import 'package:rayo/utils/timeago/timeago.dart';

class AlertListWidget extends StatelessWidget {
  final AlertModel alertModel;
  const AlertListWidget({required this.alertModel, super.key});

  @override
  Widget build(context) {
    List<UserModel> userList = <UserModel>[];
    for (UserModel user in alertModel.room.memberList) {
      if (user.seq != LoginCtl.instance.user.seq) {
        userList.add(user);
      }
    }

    return Row(children: [
      SizedBox(
          width: 50,
          height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (userList.length == 1)
                InkWell(
                  onTap: () {
                    p('프로필 페이지 이동');
                  },
                  child: SizedBox(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(SvgIcon.ICON_bottomProfile,
                            width: 50,
                            height: 50,
                            theme: SvgTheme(
                              currentColor: Color(0xFFDCDCE6),
                            )),
                        if (userList[0].profileImg != '')
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(userList[0].profileImg),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              if (userList.length == 2)
                SizedBox(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          left: 0,
                          child: Stack(
                            children: [
                              SvgPicture.asset(SvgIcon.ICON_bottomProfile,
                                  width: 35,
                                  height: 35,
                                  theme: SvgTheme(
                                    currentColor: Color(0xFFDCDCE6),
                                  )),
                              if (userList[0].profileImg != '')
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(userList[0].profileImg),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          )),
                      Positioned(
                          right: 0,
                          child: Stack(
                            children: [
                              SvgPicture.asset(SvgIcon.ICON_bottomProfile,
                                  width: 35,
                                  height: 35,
                                  theme: SvgTheme(
                                    currentColor: Color(0xFFDCDCE6),
                                  )),
                              if (userList[1].profileImg != '')
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(userList[1].profileImg),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ))
                    ],
                  ),
                ),
              if (userList.length == 3)
                SizedBox(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          top: 0,
                          child: Stack(
                            children: [
                              SvgPicture.asset(SvgIcon.ICON_bottomProfile,
                                  width: 30,
                                  height: 30,
                                  theme: SvgTheme(
                                    currentColor: Color(0xFFDCDCE6),
                                  )),
                              if (userList[0].profileImg != '')
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(userList[0].profileImg),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          )),
                      Positioned(
                          left: 0,
                          bottom: 0,
                          child: Stack(
                            children: [
                              SvgPicture.asset(SvgIcon.ICON_bottomProfile,
                                  width: 30,
                                  height: 30,
                                  theme: SvgTheme(
                                    currentColor: Color(0xFFDCDCE6),
                                  )),
                              if (userList[1].profileImg != '')
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(userList[1].profileImg),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          )),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Stack(
                            children: [
                              SvgPicture.asset(SvgIcon.ICON_bottomProfile,
                                  width: 30,
                                  height: 30,
                                  theme: SvgTheme(
                                    currentColor: Color(0xFFDCDCE6),
                                  )),
                              if (userList[2].profileImg != '')
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(userList[2].profileImg),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ))
                    ],
                  ),
                ),
            ],
          )),
      SizedBox(width: 16),
      Expanded(
          child: Opacity(
        opacity: alertModel.isRead ? 0.3 : 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alertModel.alertCategory,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 18 / 12,
                  color: black[60]),
            ),
            Text(alertModel.alertTitle,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 21 / 14,
                    color: black)),
            Text(
                timeSetFormat(
                    DateTime.fromMillisecondsSinceEpoch(alertModel.date),
                    locale: Localizations.localeOf(context).languageCode),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    height: 15 / 10,
                    color: black[60])),
          ],
        ),
      ))
    ]);
  }
}
