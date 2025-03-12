import 'package:hive/hive.dart';
import 'package:rayo/db/model/hive_model.dart';
import 'package:rayo/db/model/hive_user_model.dart';
import 'package:rayo/utils/key_dbname.dart';

@HiveType(typeId: typeId_message)
class HiveMessageModel extends HiveObject with HiveModel {
  @HiveField(0)
  String dataKey;
  @HiveField(1)
  String message;
  @HiveField(2)
  HiveUserModel? userModel;
  @HiveField(3)
  int type; // 0: text, 1: image
  @HiveField(4)
  int targetUserSeq;
  @HiveField(5)
  int createdAt;
  @override
  dynamic get(String key) {
    switch (key) {
      case DB_dataKey:
        return dataKey;
      case DB_type:
        return type;
      case DB_message:
        return message;
      case DB_userModel:
        return userModel;
      case DB_targetUserSeq:
        return targetUserSeq;
      case DB_createdAt:
        return createdAt;
    }
  }

  @override
  set(String key, dynamic value) {
    switch (key) {
      case DB_dataKey:
        dataKey = value;
      case DB_type:
        type = value;
      case DB_message:
        message = value;
      case DB_userModel:
        userModel = value;
      case DB_targetUserSeq:
        targetUserSeq = value;
      case DB_createdAt:
        createdAt = value;
    }
  }

  HiveMessageModel({
    required this.dataKey,
    required this.message,
    required this.userModel,
    required this.type,
    required this.targetUserSeq,
    required this.createdAt,
  });
}

class HiveMessageAdapter extends TypeAdapter<HiveMessageModel> {
  @override
  final typeId = typeId_message;

  @override
  HiveMessageModel read(BinaryReader reader) {
    int field = reader.readByte();
    var setField = <int, dynamic>{
      for (int i = 0; i < field; i++) reader.readByte(): reader.read()
    };

    return HiveMessageModel(
      dataKey: setField[0] ?? '',
      message: setField[1] ?? '',
      userModel: setField[2] as HiveUserModel,
      type: setField[3] ?? 0,
      targetUserSeq: setField[4] ?? 0,
      createdAt: setField[5] ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMessageModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dataKey)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.userModel)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.targetUserSeq)
      ..writeByte(5)
      ..write(obj.createdAt);
  }
}
