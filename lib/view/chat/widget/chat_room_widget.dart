import 'package:rayo/controller/chat_ctl.dart';
import 'package:rayo/db/model/hive_room_model.dart';
import 'package:rayo/db/model/hive_user_model.dart';
import 'package:rayo/utils/import_index.dart';

class ChatRoomWidget extends StatelessWidget {
  final HiveRoomModel room;
  const ChatRoomWidget({required this.room, super.key});

  @override
  Widget build(context) {
    List<HiveUserModel> member = room.member!.where((e) {
      if (e.dataKey == LoginCtl.instance.user.seq) {
        return false;
      } else {
        return true;
      }
    }).toList();
    return Row(
      children: [
        Builder(builder: (context) {
          return SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (member.length == 1)
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
                            if (member[0].profileImg != '')
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(member[0].profileImg),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  if (member.length == 2)
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
                                  if (member[0].profileImg != '')
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              member[0].profileImg),
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
                                  if (member[1].profileImg != '')
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              member[1].profileImg),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  if (member.length == 3)
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
                                  if (member[0].profileImg != '')
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              member[0].profileImg),
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
                                  if (member[1].profileImg != '')
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              member[1].profileImg),
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
                                  if (member[2].profileImg != '')
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              member[2].profileImg),
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
              ));
        }),
        SizedBox(
          width: 16,
        ),
        Expanded(
            child: InkWell(
          onTap: () async {
            Navigator.pushNamed(context, NAV_ChatRoomPage,
                arguments: {'HiveRoomModel': room});

            await room.save();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 21 / 14),
                    ),
                    Text(
                      room.message,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 21 / 14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: room.unreadCount == 0
                    ? null
                    : Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: mint),
                        child: Text(
                          room.unreadCount > 99
                              ? '99+'
                              : room.unreadCount.toString(),
                          style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              height: 18 / 12),
                        )),
              )
            ],
          ),
        ))
      ],
    );
  }
}
