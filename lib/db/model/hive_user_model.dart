import 'package:hive/hive.dart';
import 'package:rayo/db/model/hive_model.dart';
import 'package:rayo/utils/key_dbname.dart';

@HiveType(typeId: typeId_user)
class HiveUserModel extends HiveObject with HiveModel {
  @HiveField(0)
  int dataKey;
  @HiveField(1)
  String name;
  @HiveField(2)
  String profileImg;
  @override
  dynamic get(String key) {
    switch (key) {
      case DB_dataKey:
        return dataKey;
      case DB_name:
        return name;
      case DB_profileImg:
        return profileImg;
    }
  }

  @override
  set(String key, dynamic value) {
    switch (key) {
      case DB_dataKey:
        dataKey = value;
      case DB_name:
        name = value;
      case DB_profileImg:
        profileImg = value;
    }
  }

  HiveUserModel(
      {required this.dataKey, required this.name, required this.profileImg});
}

class HiveUserAdapter extends TypeAdapter<HiveUserModel> {
  @override
  final int typeId = typeId_user;
  @override
  HiveUserModel read(BinaryReader reader) {
    int field = reader.readByte();
    var setField = <int, dynamic>{
      for (int i = 0; i < field; i++) reader.readByte(): reader.read()
    };
    return HiveUserModel(
      dataKey: setField[0] ?? 0,
      name: setField[1] ?? '',
      profileImg: setField[2] ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, HiveUserModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dataKey)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.profileImg);
  }
}
