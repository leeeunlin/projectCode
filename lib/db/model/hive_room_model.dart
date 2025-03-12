import 'package:hive/hive.dart';
import 'package:rayo/db/model/hive_model.dart';
import 'package:rayo/db/model/hive_user_model.dart';
import 'package:rayo/utils/key_dbname.dart';

@HiveType(typeId: typeId_room)
class HiveRoomModel extends HiveObject with HiveModel {
  @HiveField(0)
  String dataKey;
  @HiveField(1)
  String name;
  @HiveField(2)
  int type; // 0 : friend, 1 : group(번개)
  @HiveField(3)
  int lastTime;
  @HiveField(4)
  HiveList<HiveUserModel>? member;
  @HiveField(5)
  Map lastReadTime;
  @HiveField(6)
  int unreadCount;
  @HiveField(7)
  String message;
  @override
  dynamic get(String key) {
    switch (key) {
      case DB_dataKey:
        return dataKey;
      case DB_name:
        return name;
      case DB_type:
        return type;
      case DB_lastTime:
        return lastTime;
      case DB_member:
        return member;
      case DB_lastReadTime:
        return lastReadTime;
      case DB_unreadCount:
        return unreadCount;
      case DB_message:
        return message;
    }
  }

  @override
  set(String key, dynamic value) {
    switch (key) {
      case DB_dataKey:
        dataKey = value;
      case DB_name:
        name = value;
      case DB_type:
        type = value;
      case DB_lastTime:
        lastTime = value;
      case DB_member:
        member = value;
      case DB_lastReadTime:
        lastReadTime = value;
      case DB_unreadCount:
        unreadCount = value;
      case DB_message:
        message = value;
    }
  }

  HiveRoomModel({
    required this.dataKey,
    required this.name,
    required this.type,
    required this.lastTime,
    this.member,
    required this.lastReadTime,
    required this.unreadCount,
    required this.message,
  });
}

class HiveRoomAdapter extends TypeAdapter<HiveRoomModel> {
  @override
  final int typeId = typeId_room;
  @override
  HiveRoomModel read(BinaryReader reader) {
    int field = reader.readByte();
    var setField = <int, dynamic>{
      for (int i = 0; i < field; i++) reader.readByte(): reader.read()
    };
    return HiveRoomModel(
      dataKey: setField[0] ?? '',
      name: setField[1] ?? '',
      type: setField[2] ?? 0,
      lastTime: setField[3] ?? 0,
      member: (setField[4] as HiveList?)?.castHiveList<HiveUserModel>(),
      lastReadTime: setField[5] ?? {},
      unreadCount: setField[6] ?? 0,
      message: setField[7] ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, HiveRoomModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.dataKey)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.lastTime)
      ..writeByte(4)
      ..write(obj.member)
      ..writeByte(5)
      ..write(obj.lastReadTime)
      ..writeByte(6)
      ..write(obj.unreadCount)
      ..writeByte(7)
      ..write(obj.message);
  }
}
