// ignore_for_file: constant_identifier_names

const int typeId_hiveData = 0;
const int typeId_user = 1;
const int typeId_room = 3;
const int typeId_info = 4;
const int typeId_message = 5;

mixin class HiveModel {
  dynamic get(String key) => null;
  set(String key, dynamic value) {}
}
