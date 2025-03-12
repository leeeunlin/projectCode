import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rayo/db/hive_db.dart';
import 'package:rayo/db/model/hive_room_model.dart';
import 'package:rayo/utils/import_index.dart';
import 'package:rayo/view/chat/widget/chat_room_widget.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});
  @override
  State<ChatListPage> createState() => _ChatListPage();
}

class _ChatListPage extends State<ChatListPage> {
  TextEditingController textEditingController = TextEditingController();
  int selectMessageCat = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: BackBtn(func: () async {
          Navigator.pop(context);
        }),
        title: Text('message'.tr()),
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
          Row(
            children: [
              InkWell(
                onTap: () {
                  selectMessageCat = 0;
                  textEditingController.clear();
                  setState(() {});
                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: selectMessageCat == 0 ? yellow : white,
                                width: 4))),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      'lightningmeet'.tr(),
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 21 / 14),
                    )),
              ),
              InkWell(
                onTap: () {
                  selectMessageCat = 1;
                  textEditingController.clear();
                  setState(() {});
                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: selectMessageCat == 1 ? yellow : white,
                                width: 4))),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      'friends'.tr(),
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 21 / 14),
                    )),
              )
            ],
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 12, right: 16, left: 16, bottom: 9),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: white[80]),
              child: Row(
                children: [
                  SvgPicture.asset(SvgIcon.ICON_search),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: TextFormField(
                      autofocus: false,
                      controller: textEditingController,
                      maxLines: 1,
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 21 / 14),
                      decoration: InputDecoration.collapsed(
                        hintText: 'searchName'.tr(),
                        hintStyle: TextStyle(
                          color: black[80],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 21 / 14,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 12, right: 16, left: 16),
              child: Column(
                children: [
                  Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: HiveDB.instance.roomBox,
                          builder: (_, roomBox, child) {
                            List<HiveRoomModel> room =
                                HiveDB.instance.sortRoom();
                            return ListView.separated(
                                shrinkWrap: true,
                                itemCount: room.length,
                                itemBuilder: (_, idx) => Slidable(
                                      key: UniqueKey(),
                                      endActionPane: ActionPane(
                                          motion: ScrollMotion(),
                                          extentRatio: 0.2,
                                          dismissible: DismissiblePane(
                                              dismissalDuration:
                                                  Duration(milliseconds: 200),
                                              resizeDuration:
                                                  Duration(milliseconds: 200),
                                              onDismissed: () async {
                                                Box<HiveObject> box =
                                                    Hive.isBoxOpen(
                                                            room[idx].dataKey)
                                                        ? Hive.box<HiveObject>(
                                                            room[idx].dataKey)
                                                        : await Hive.openBox<
                                                                HiveObject>(
                                                            room[idx].dataKey);

                                                box.deleteFromDisk();
                                                await room[idx].delete();
                                              }),
                                          children: [
                                            CustomSlidableAction(
                                                onPressed: (context) async {
                                                  Box<HiveObject> box = Hive
                                                          .isBoxOpen(
                                                              room[idx].dataKey)
                                                      ? Hive.box<HiveObject>(
                                                          room[idx].dataKey)
                                                      : await Hive.openBox<
                                                              HiveObject>(
                                                          room[idx].dataKey);

                                                  box.deleteFromDisk();
                                                  await room[idx].delete();
                                                },
                                                backgroundColor: Colors.red,
                                                child: SvgPicture.asset(
                                                    SvgIcon.ICON_delete))
                                          ]),
                                      child: ChatRoomWidget(room: room[idx]),
                                    ),
                                separatorBuilder: (_, index) => SizedBox(
                                      height: 20,
                                    ));
                          }))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
