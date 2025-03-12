import 'package:hive_flutter/hive_flutter.dart';
import 'package:rayo/controller/chat_ctl.dart';
import 'package:rayo/db/model/hive_message_model.dart';
import 'package:rayo/db/model/hive_room_model.dart';
import 'package:rayo/db/model/hive_user_model.dart';
import 'package:rayo/utils/import_index.dart';

class HiveDB {
  static final HiveDB _instance = HiveDB._internal();
  factory HiveDB() => _instance;
  HiveDB._internal();
  static HiveDB get instance => _instance;

  late ValueListenable<Box<dynamic>> roomBox;
  late ValueListenable<Box<dynamic>> userBox;
  // late ValueListenable<Box<dynamic>> messageBox;

  Future<void> init() async {
    p(Directory.systemTemp.path);
    await Hive.initFlutter();
    Hive.registerAdapter<HiveUserModel>(HiveUserAdapter());
    Hive.registerAdapter<HiveRoomModel>(HiveRoomAdapter());
    Hive.registerAdapter<HiveMessageModel>(HiveMessageAdapter());
    await Hive.openBox<HiveObject>(DB_user);
    await Hive.openBox<HiveObject>(DB_room);
    // await Hive.openBox<HiveObject>(DB_message);
    roomBox = Hive.box<HiveObject>(DB_room).listenable();
    userBox = Hive.box<HiveObject>(DB_user).listenable();
    // messageBox = Hive.box<HiveObject>(DB_message).listenable();
  }

  List<HiveRoomModel> sortRoom() {
    List item = roomBox.value.values.where((e) {
      HiveList members = e.get(DB_member);
      if (members.keys.contains(LoginCtl.instance.user.seq)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    item.sort((a, b) => b.lastTime.compareTo(a.lastTime));
    List<HiveRoomModel> convert = List<HiveRoomModel>.from(item);
    return convert;
  }

  // int reverseComparator(dynamic k1, dynamic k2) {
  //   if (k1 is int) {
  //     if (k2 is int) {
  //       if (k1 > k2) {
  //         return -1;
  //       } else if (k1 < k2) {
  //         return 1;
  //       } else {
  //         return 0;
  //       }
  //     } else {
  //       return -1;
  //     }
  //   } else if (k2 is String) {
  //     return (k1 as String).compareTo(k2);
  //   } else {
  //     return 1;
  //   }
  // }

  /// 방 생성 함수
  /// 메시지 초기 수신 혹은 대화방 시작 생성시 호출된다.
  Future<HiveRoomModel> createRoom(
      {required Map<String, dynamic> docData}) async {
    List<int> member = List<int>.from(docData['roomData'][DB_member]);
    Map lastReadTime = {
      for (int e in member) e: 1
    }; // 초기 방 생성값 맴버당 마지막 읽은 시간 1로 초기화 진행
    HiveList<HiveUserModel> memberList = await getRoomMember(member: member);
    String name = docData['roomData'][DB_name];
    if (docData['roomData'][DB_type] == 0) // 타입이 0이면 일반1:1메시지
    {
      for (HiveUserModel userModel in memberList) {
        if (userModel.dataKey != LoginCtl.instance.user.seq) {
          name = userModel.name;
        }
      }
    }
    HiveRoomModel convertModel = HiveRoomModel(
      dataKey: docData['roomData'][DB_dataKey],
      name: name,
      type: docData['roomData'][DB_type],
      lastTime: docData[DB_createdAt],
      member: memberList,
      lastReadTime: lastReadTime,
      unreadCount: 0,
      message: docData[DB_message] ?? '',
    );

    await roomBox.value.put(docData['roomData'][DB_dataKey], convertModel);
    return roomBox.value.get(docData['roomData'][DB_dataKey]);
  }

  /// 방에 소속된 유저 정보 가져오기
  Future<HiveList<HiveUserModel>> getRoomMember(
      {required List<int> member}) async {
    /// 유저정보를 가져오는 API 호출 후 리턴값을 hive에 넣어준다.
    final resbody = await GetList.instance.getSeqtoUser(
        uri: '시퀀스리스트로 유저리스트 가져오기', query: {'q': member.toString()});

    HiveList<HiveUserModel> userList = HiveList(userBox.value);
    if (resbody[statusCode] == 200 && resbody[data] != null) {
      for (UserModel userModel in resbody[data]) {
        HiveUserModel convertModel = HiveUserModel(
          dataKey: userModel.seq,
          name: userModel.name,
          profileImg: userModel.profileImg,
        );
        HiveUserModel? alreadyUser = userBox.value.get(userModel.seq);
        if (alreadyUser == null) {
          await userBox.value.put(userModel.seq, convertModel);
        } else {
          alreadyUser.name = userModel.name;
          alreadyUser.profileImg = userModel.profileImg;
          await alreadyUser.save();
        }
        userList.add(userBox.value.get(userModel.seq));
      }
    }
    return userList;
  }

  /// 메시지 보내기 혹은 받은 메시지 데이터가 수신됨
  Future<void> setMessage({required Map<String, dynamic> docData}) async {
    /// 박스정보를 가져온다.
    /// 박스정보는 개별 파일로 저장되고있다.
    /// 박스가 열려있다면 해당 박스정보를 가져오고 닫힌상태라면 오픈한다
    /// 해당 방에 들어가야 메시지박스가 오픈된다.
    Box<HiveObject> messageBox = Hive.isBoxOpen(docData['roomData'][DB_dataKey])
        ? Hive.box<HiveObject>(docData['roomData'][DB_dataKey])
        : await Hive.openBox<HiveObject>(docData['roomData'][DB_dataKey]);
    if (docData[DB_message] != null) {
      List<int> senderUser = List<int>.from([docData[DB_targetUserSeq]]);
      for (int userSeq in senderUser) {
        HiveUserModel? alreadyUser = userBox.value.get(userSeq);
        if (alreadyUser == null) {
          if (userSeq == 0) {
            /// userseq가 0번일 경우 시스템메시지로 처리함
            HiveUserModel convertUserModel = HiveUserModel(
                dataKey: 0, name: '<SYSTEM_RAYO>', profileImg: '');
            await userBox.value.put(0, convertUserModel);
          } else {
            /// 메시지 저장할때 유저 리스트 갱신하여 저장한다. 위치 변경이 필요 할 수 있따.
            final resbody = await GetList.instance.getSeqtoUser(
                uri: '시퀀스리스트로 유저리스트 가져오기', query: {'q': senderUser.toString()});
            if (resbody[statusCode] == 200 && resbody[data] != null) {
              for (UserModel userModel in resbody[data]) {
                HiveUserModel convertUserModel = HiveUserModel(
                    dataKey: userModel.seq,
                    name: userModel.name,
                    profileImg: userModel.profileImg);
                await userBox.value.put(userModel.seq, convertUserModel);
              }
            }
          }
        }
      }

      /// 메시지 모델을 세팅한다
      HiveMessageModel convertModel = HiveMessageModel(
        dataKey: docData[DB_dataKey],
        message: docData[DB_message],
        userModel: userBox.value.get(docData[DB_userSeq]),
        type: docData[DB_type],
        targetUserSeq: docData[DB_targetUserSeq],
        createdAt: docData[DB_createdAt],
      );
      await messageBox.put(docData[DB_dataKey], convertModel);

      /// 대화방이 열려있는 상태에서 메시지가 수신된 경우
      if (ChatCtl.instance.currentRoom == docData['roomData'][DB_dataKey]) {
        HiveRoomModel room = roomBox.value.get(docData['roomData'][DB_dataKey]);
        room.lastReadTime[docData[DB_userSeq]] = docData[DB_createdAt];
        await room.save();
      }

      /// 대화방이 열려있지 않은 상태에서 메시지가 수신된 경우
      else {
        List<HiveMessageModel> messageList =
            List<HiveMessageModel>.from(messageBox.values.toList());
        HiveRoomModel room = roomBox.value.get(docData['roomData'][DB_dataKey]);
        int unreadCount = 0;
        for (HiveMessageModel message in messageList) {
          p('---------');
          p(room.lastReadTime[LoginCtl.instance.user.seq] - message.createdAt);

          if (room.lastReadTime[LoginCtl.instance.user.seq] <
              message.createdAt) {
            unreadCount++;
          }
        }
        room.unreadCount = unreadCount;
        await room.save();

        /// 대화방이 열려있지 않은 경우 사용하지 않는 박스를 close 처리한다.
        /// room.save 이후 close 를 해야 정상동작함
        await messageBox.close();
      }
    }
  }
}
