import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rayo/db/hive_db.dart';
import 'package:rayo/db/model/hive_room_model.dart';
import 'package:rayo/utils/import_index.dart';

class ChatCtl {
  static final ChatCtl _instance = ChatCtl._internal();
  factory ChatCtl() => _instance;
  ChatCtl._internal();
  static ChatCtl get instance => _instance;
  String currentRoom = '';
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listener;

  Future<void> init() async {
    listener = FirebaseFirestore.instance
        .collectionGroup("chatSocket")
        .where(DB_targetUserSeq, isEqualTo: LoginCtl.instance.user.seq)
        .orderBy(DB_createdAt, descending: false)
        .snapshots()
        .listen((event) async {
      for (var docChange in event.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          Map<String, dynamic>? docData = docChange.doc.data();
          switch (docData![DB_type]) {
            case 0:
              await setHive(docData: docData);
              break;
            case 1:
              p('image type');
              break;
            case 99: // 읽음 확인처리
              await readUpdate(docData: docData);
              break;
            default:
              p('unknown type');
          }

          await docChange.doc.reference.delete();
        }
      }
    });
  }

  Future<void> dispose() async {
    listener.cancel();
  }

  /// 대화가 수신되었을때 방이 없다면 새로 생성하고 해당 메시지를 넣어줌
  /// 수신된 docu를 가지고 방이 없다면 새로 HIVE에 저장한다.
  /// 방 정보를 저장한 이후 메시지를 저장한다.
  Future<void> setHive({required Map<String, dynamic> docData}) async {
    HiveRoomModel? alreadyRoom =
        HiveDB.instance.roomBox.value.get(docData['roomData'][DB_dataKey]);
    alreadyRoom ??= await HiveDB.instance.createRoom(docData: docData);
    alreadyRoom.lastTime = docData[DB_createdAt];
    if (currentRoom == alreadyRoom.dataKey) {
      await lastReadSet(roomKey: docData['roomData'][DB_dataKey]);
    }
    alreadyRoom.message = docData[DB_message] ?? '';
    await alreadyRoom.save();

    await HiveDB.instance.setMessage(docData: docData);
  }

  /// 읽음 정보 업데이트
  /// docData type이 99일때 해당 함수가 호출되며, 해당 doc에는 createAt, roomData, 보낸, 받을사람 정보만 들어있다.
  /// 이 정보로 메시지 옆 숫자 1 카운트가 생성되고 사라지도록 할 수 있다.
  Future<void> readUpdate({required Map<String, dynamic> docData}) async {
    HiveRoomModel? alreadyRoom =
        HiveDB.instance.roomBox.value.get(docData['roomData'][DB_dataKey]);
    if (alreadyRoom != null) {
      alreadyRoom.lastReadTime[docData[DB_userSeq]] = docData[DB_createdAt];
      await alreadyRoom.save();
    }
  }

  /// 내가 읽었을 경우 해당 정보를 Firebase측으로 송신한다.
  /// 이 값을 받은 상대방은 메시지 옆 숫자 1카운트를 제어할 수 있다.
  /// 방에 진입하거나 메시지를 보낼때, 혹은 메시지를 받는 상대방이 해당 방에 있는경우 함께 발송한다.
  Future<void> lastReadSet({required String roomKey}) async {
    HiveRoomModel? alreadyRoom = HiveDB.instance.roomBox.value.get(roomKey);
    int readTime = DateTime.now().millisecondsSinceEpoch;
    alreadyRoom!.unreadCount = 0;
    alreadyRoom.lastReadTime[LoginCtl.instance.user.seq] = readTime;
    // await alreadyRoom.save();
    final collection =
        FirebaseFirestore.instance.collection('chat').doc(roomKey);
    Map<String, dynamic> roomData =
        await collection.get().then((value) => value.data()!);
    final batch = FirebaseFirestore.instance.batch();
    for (int seq in alreadyRoom.lastReadTime.keys) {
      if (seq != LoginCtl.instance.user.seq) {
        batch.set(
            collection
                .collection('chatSocket')
                .doc('readUpdate_${seq}_$readTime'),
            {
              'roomData': roomData,
              DB_type: 99,
              DB_userSeq: LoginCtl.instance.user.seq,
              DB_targetUserSeq: seq,
              DB_createdAt: readTime,
            });
      }
    }
    await batch.commit();
  }

  /// 1:1 대화방 생성 초기 세팅값 적용
  Future<HiveRoomModel> setDirectChat(
      {required UserModel user, required bool friend}) async {
    String roomKey =
        'direct_${min(LoginCtl.instance.user.seq, user.seq)}_${max(LoginCtl.instance.user.seq, user.seq)}';
    Map<String, dynamic> roomData = {
      DB_dataKey: roomKey,
      DB_name: '',
      DB_type: 0,
      DB_member: [LoginCtl.instance.user.seq, user.seq],
    };
    final collection = FirebaseFirestore.instance.collection('chat');
    await collection.doc(roomKey).set(roomData); // TODO :: 머지옵션 필요여부 체크
    int createAt = DateTime.now().millisecondsSinceEpoch;

    /// 방 생성하면서 하단부 로컬 메시지 바로 삽입처리하도록 함
    Map<String, dynamic> message;
    if (friend) {
      message = {
        DB_roomData: roomData,
        DB_createdAt: createAt,
      };
    } else {
      message = {
        DB_roomData: roomData,
        DB_dataKey: 'msgKey_$createAt',
        DB_createdAt: createAt,
        DB_type: 99,
        DB_userSeq: LoginCtl.instance.user.seq,
        DB_targetUserSeq: LoginCtl.instance.user.seq,
        DB_message:
            // TODO :: 번역 필요
            '친구 신청 메시지가 전송되었어요.\n이제 [${user.name}] 님에게 메시지를 보낼 수 있습니다. 친구가 7일 이내 수락해야 메시지를 계속 주고 받을 수 있어요. 메시지 시에는 커뮤니티 가이드를 지켜주세요!',
      };
    }

    currentRoom = roomKey;
    await setHive(docData: message);

    return HiveDB.instance.roomBox.value.get(roomKey);
  }

  /// 메시지 전달 함수
  Future<void> sendMessage(
      {required String roomKey,
      required String message,
      required int type}) async {
    int createAt = DateTime.now().millisecondsSinceEpoch;
    String msgKey = 'msgKey_$createAt';
    HiveRoomModel? alreadyRoom = HiveDB.instance.roomBox.value.get(roomKey);

    List<int> targetUserSeq = List<int>.from(alreadyRoom!.member!.keys);
    targetUserSeq.remove(LoginCtl.instance.user.seq);
    Map<String, dynamic> messageSet = {
      DB_roomData: {
        DB_dataKey: roomKey,
        DB_name: alreadyRoom.name,
        DB_type: alreadyRoom.type,
        DB_member: alreadyRoom.member!.keys,
      },
      DB_dataKey: msgKey,
      DB_message: message,
      DB_createdAt: createAt,
      DB_type: type,
      DB_userSeq: LoginCtl.instance.user.seq,
      DB_targetUserSeq: LoginCtl.instance.user.seq,
    };
    alreadyRoom.message = message;
    await HiveDB.instance.setMessage(docData: messageSet);
    for (int seq in targetUserSeq) {
      messageSet[DB_targetUserSeq] = seq;

      await FirebaseFirestore.instance
          .collection('chat')
          .doc(roomKey)
          .collection('chatSocket')
          .doc(msgKey)
          .set(messageSet);
    }
  }
}
