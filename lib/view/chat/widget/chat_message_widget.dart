import 'package:rayo/db/model/hive_message_model.dart';
import 'package:rayo/utils/import_index.dart';

class ChatMessageWidget extends StatelessWidget {
  final HiveMessageModel message;
  final HiveMessageModel? previousMessage;
  final HiveMessageModel? nextMessage;
  final int unReadCount;
  const ChatMessageWidget(
      {required this.unReadCount,
      required this.message,
      this.previousMessage,
      this.nextMessage,
      super.key});

  bool shouldShowProfileAndName() {
    if (previousMessage == null) return true;
    return message.userModel!.dataKey != previousMessage!.userModel!.dataKey;
  }

  bool shouldShowDate() {
    if (nextMessage == null) return true;
    if (message.userModel!.dataKey != nextMessage!.userModel!.dataKey) {
      return true;
    }
    DateTime currentMessageTime =
        DateTime.fromMillisecondsSinceEpoch(message.createdAt);
    DateTime nextMessageTime =
        DateTime.fromMillisecondsSinceEpoch(nextMessage!.createdAt);
    return currentMessageTime.minute != nextMessageTime.minute;
  }

  @override
  Widget build(context) {
    List<Widget> widgets;
    // 내가보낸 메시지
    if (message.userModel!.dataKey == LoginCtl.instance.user.seq ||
        message.userModel!.dataKey == 0) {
      widgets = [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (unReadCount != 0 && !shouldShowDate() && message.type != 99)
              Text(unReadCount.toString(),
                  style: TextStyle(
                    color: yellow,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    height: 15 / 10,
                  )),
            if (shouldShowDate())
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (unReadCount != 0 && message.type != 99)
                    Text(unReadCount.toString(),
                        style: TextStyle(
                          color: yellow,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          height: 15 / 10,
                        )),
                  Text(
                      DateFormat.jm(
                        Localizations.localeOf(context).languageCode,
                      ).format(DateTime.fromMillisecondsSinceEpoch(
                          message.createdAt)),
                      style: TextStyle(
                        color: black[60],
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        height: 15 / 10,
                      )),
                ],
              ),
            SizedBox(width: 8),
            messageWidget(context),
          ],
        )
      ];
    } else {
      // 상대방 메시지
      widgets = [
        SizedBox(
          width: 30,
          child: shouldShowProfileAndName()
              ? InkWell(
                  onTap: () {
                    p('프로필 페이지 이동');
                  },
                  child: SizedBox(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(SvgIcon.ICON_bottomProfile,
                            width: 30,
                            height: 30,
                            theme: SvgTheme(
                              currentColor: Color(0xFFDCDCE6),
                            )),
                        if (message.userModel!.profileImg != '')
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    NetworkImage(message.userModel!.profileImg),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : null,
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (shouldShowProfileAndName())
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(message.userModel!.name,
                    style: TextStyle(
                        color: black[80],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 21 / 14)),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                messageWidget(context),
                SizedBox(width: 8),
                if (unReadCount != 0 && !shouldShowDate())
                  Text(unReadCount.toString(),
                      style: TextStyle(
                        color: yellow,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        height: 15 / 10,
                      )),
                if (shouldShowDate())
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (unReadCount != 0)
                        Text(unReadCount.toString(),
                            style: TextStyle(
                              color: yellow,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              height: 15 / 10,
                            )),
                      Text(
                          DateFormat.jm(
                            Localizations.localeOf(context).languageCode,
                          ).format(DateTime.fromMillisecondsSinceEpoch(
                              message.createdAt)),
                          style: TextStyle(
                            color: black[60],
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            height: 15 / 10,
                          )),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ];
    }
    List<Widget> wrapColumn = [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (previousMessage != null &&
              message.userModel!.dataKey != previousMessage!.userModel!.dataKey)
            SizedBox(
              height: 8,
            ),
          Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets),
          if (nextMessage != null &&
              message.userModel!.dataKey != nextMessage!.userModel!.dataKey)
            SizedBox(
              height: 8,
            )
        ],
      )
    ];
    return Row(
        crossAxisAlignment:
            message.userModel!.dataKey == LoginCtl.instance.user.seq
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        mainAxisAlignment:
            message.userModel!.dataKey == LoginCtl.instance.user.seq
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: wrapColumn);
  }

  Container messageWidget(context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: message.type == 0
            ? EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
            color: message.userModel!.dataKey == LoginCtl.instance.user.seq
                ? yellow[4]
                : white[90],
            borderRadius: message.userModel!.dataKey == LoginCtl.instance.user.seq
                ? BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 0
                            : 16),
                    bottomRight: Radius.circular(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 16
                            : 0))
                : BorderRadius.only(
                    topLeft: Radius.circular(
                        Localizations.localeOf(context).languageCode == 'ar' ? 16 : 0),
                    topRight: Radius.circular(Localizations.localeOf(context).languageCode == 'ar' ? 0 : 16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16))),
        child: Text(
          message.message,
          style: TextStyle(
              color: black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 21 / 14),
        ));
  }
}
