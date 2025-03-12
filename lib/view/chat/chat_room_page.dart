import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rayo/controller/chat_ctl.dart';
import 'package:rayo/db/hive_db.dart';
import 'package:rayo/db/model/hive_message_model.dart';
import 'package:rayo/db/model/hive_room_model.dart';
import 'package:rayo/utils/import_index.dart';
import 'package:rayo/view/chat/widget/chat_message_widget.dart';

class ChatRoomPage extends StatefulWidget {
  final HiveRoomModel room;
  const ChatRoomPage({required this.room, super.key});
  @override
  State<ChatRoomPage> createState() => _ChatRoomPage();
}

class _ChatRoomPage extends State<ChatRoomPage> {
  bool loading = false;
  late ValueListenable<Box<dynamic>> chatBox;
  TextEditingController messageCtl = TextEditingController();
  ScrollController scrollCtl = ScrollController();
  @override
  void initState() {
    super.initState();
    ChatCtl.instance.currentRoom = widget.room.dataKey;
    Hive.openBox<HiveObject>(widget.room.dataKey).then((_) async {
      await ChatCtl.instance.lastReadSet(roomKey: widget.room.dataKey);
      chatBox = Hive.box<HiveObject>(widget.room.dataKey).listenable();
      loading = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    chatBox.value.close();
    ChatCtl.instance.currentRoom = '';
    super.dispose();
  }

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () async {
        await SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            leading: BackBtn(func: () async {
              Navigator.pop(context);
            }),
            title: Text(widget.room.name),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: 36,
                height: 36,
                child: CloudWidget(
                  color: black[60]!,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: !loading
                    ? SizedBox()
                    : ValueListenableBuilder(
                        valueListenable: chatBox,
                        builder: (_, chatBox, child) {
                          List chat = chatBox.values
                              .where(
                                (element) => true,
                              )
                              .toList();
                          List<HiveMessageModel> finalChat = List.from(chat);
                          return GroupedListView<HiveMessageModel, String>(
                            padding: EdgeInsets.all(16),
                            controller: scrollCtl,
                            reverse: true,
                            order: GroupedListOrder.DESC,
                            elements: finalChat,
                            groupBy: (e) => DateFormat.yMMMd().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    e.createdAt)),
                            groupSeparatorBuilder: (String date) {
                              return Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(17),
                                child: Text(
                                  date,
                                  style: const TextStyle(
                                      color: Color(0xFF606060),
                                      fontSize: 12,
                                      height: 18 / 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                            indexedItemBuilder: (_, e, index) {
                              return ValueListenableBuilder(
                                  valueListenable: HiveDB.instance.roomBox,
                                  builder: (_, roomBox, child) {
                                    int idx = chatBox.length - 1 - index;
                                    HiveMessageModel message =
                                        chatBox.getAt(idx);
                                    HiveMessageModel? previousMessage;
                                    HiveMessageModel? nextMessage;
                                    int unReadCount = 0;
                                    for (int seq
                                        in widget.room.lastReadTime.keys) {
                                      if ((seq != message.userModel!.dataKey) &&
                                          (widget.room.lastReadTime[seq] <
                                              message.createdAt)) {
                                        unReadCount++;
                                      }
                                    }

                                    if (idx > 0) {
                                      previousMessage = chatBox.getAt(idx - 1);
                                    }
                                    if (idx < chatBox.length - 1) {
                                      nextMessage = chatBox.getAt(idx + 1);
                                    }

                                    return ChatMessageWidget(
                                        unReadCount: unReadCount,
                                        message: message,
                                        previousMessage: previousMessage,
                                        nextMessage: nextMessage);
                                  });
                            },
                          );
                        }),
              ),
              Container(
                  height: 100,
                  decoration: BoxDecoration(color: white, boxShadow: [
                    BoxShadow(
                        color: Color(0x263C3C46),
                        blurRadius: 10,
                        offset: Offset(2, 0)),
                  ]),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          p('이미지전송');
                        },
                        child: SvgPicture.asset(
                          SvgIcon.ICON_imageSend,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      InkWell(
                        onTap: () async {
                          p('메시지 음성통화?');
                        },
                        child: SvgPicture.asset(
                          SvgIcon.ICON_chatCall,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        height: 40,
                        decoration: BoxDecoration(
                          color: black[20],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          autofocus: false,
                          maxLines: 1,
                          controller: messageCtl,
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 21 / 14),
                          decoration: InputDecoration.collapsed(
                            hintText: 'entermessage'.tr(),
                            hintStyle: TextStyle(
                              color: black[80],
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 21 / 14,
                            ),
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 12,
                      ),
                      InkWell(
                        onTap: () async {
                          await ChatCtl.instance.sendMessage(
                              roomKey: widget.room.dataKey,
                              message: messageCtl.text,
                              type: 0);
                          messageCtl.clear();
                          scrollCtl.jumpTo(0);
                        },
                        child: SvgPicture.asset(
                          SvgIcon.ICON_chatSend,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ))
            ],
          )),
    );
  }
}
