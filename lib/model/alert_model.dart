import 'package:rayo/utils/import_index.dart';

class AlertModel {
  int seq;
  String alertCategory;
  String alertTitle;
  bool isRead;
  int date;
  RoomModel room;

  AlertModel({
    required this.seq,
    required this.alertCategory,
    required this.alertTitle,
    required this.isRead,
    required this.date,
    required this.room,
  });
  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      seq: json[DB_seq] ?? 0,
      alertCategory: json[DB_alertCategory] ?? '',
      alertTitle: json[DB_alertTitle] ?? '',
      isRead: json[DB_isRead] ?? false,
      date: json[DB_date] ?? 0,
      room: RoomModel.fromJson(json[DB_room] ?? {}),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      DB_seq: seq,
      DB_alertCategory: alertCategory,
      DB_alertTitle: alertTitle,
      DB_date: date,
      DB_isRead: isRead,
      DB_room: room.toJson(),
    };
  }
}
