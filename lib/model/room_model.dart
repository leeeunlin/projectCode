import 'package:rayo/utils/import_index.dart';

class RoomModel {
  int seq;
  String name; // 방제
  String location; // 모임위치
  int date; // 만날 시간
  UserModel master;
  List<UserModel> memberList;
  int memberCount; // 참여인원수
  int memberLimit;
  RoomCat roomCat;
  bool completed;

  RoomModel({
    required this.seq,
    required this.name,
    required this.location,
    required this.date,
    required this.master,
    required this.memberList,
    required this.memberCount,
    required this.memberLimit,
    required this.roomCat,
    required this.completed,
  });
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
        seq: json[DB_seq] ?? 0,
        name: json[DB_name] ?? '',
        location: json[DB_location] ?? '',
        date: json[DB_date] ?? 0,
        master: UserModel.fromJson(json[DB_master] ?? {}),
        memberList: json[DB_memberList] == null
            ? <UserModel>[]
            : List<UserModel>.from(
                json[DB_memberList].map((e) => UserModel.fromJson(e))),
        memberCount: json[DB_memberCount] ?? 0,
        memberLimit: json[DB_memberLimit] ?? 0,
        roomCat: RoomCat.fromJson(json[DB_roomCat] ?? {}),
        completed: json[DB_completed] ?? false);
  }
  Map<String, dynamic> toJson() {
    return {
      DB_seq: seq,
      DB_name: name,
      DB_location: location,
      DB_date: date,
      DB_master: master.toJson(),
      DB_memberCount: memberCount,
      DB_memberLimit: memberLimit,
      DB_roomCat: roomCat.toJson(),
      DB_completed: completed
    };
  }
}

class RoomCat {
  int near;
  int gender;
  bool food;
  bool amity;
  bool art;
  bool exercise;

  RoomCat({
    required this.near,
    required this.gender,
    required this.food,
    required this.amity,
    required this.art,
    required this.exercise,
  });
  factory RoomCat.fromJson(Map<String, dynamic> json) {
    return RoomCat(
      near: json[DB_near] ?? 0,
      gender: json[DB_gender] ?? 0,
      food: json[DB_food] ?? false,
      amity: json[DB_amity] ?? false,
      art: json[DB_art] ?? false,
      exercise: json[DB_exercise] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      DB_near: near,
      DB_gender: gender,
      DB_food: food,
      DB_amity: amity,
      DB_art: art,
      DB_exercise: exercise,
    };
  }
}
