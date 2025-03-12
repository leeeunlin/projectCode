import 'package:rayo/utils/import_index.dart';

class ReviewModel {
  int seq;
  UserModel writer;
  List<String> imgDetail;
  String txtdetail;
  double rating;
  RoomModel room;
  ReviewModel({
    required this.seq,
    required this.writer,
    required this.imgDetail,
    required this.txtdetail,
    required this.rating,
    required this.room,
  });
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      seq: json[DB_seq] ?? 0,
      writer: UserModel.fromJson(json[DB_writer] ?? {}),
      imgDetail: json[DB_imgDetail] ?? <String>[],
      txtdetail: json[DB_txtdetail] ?? '',
      rating: json[DB_rating] ?? 0.0,
      room: RoomModel.fromJson(json[DB_room] ?? {}),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      DB_seq: seq,
      DB_writer: writer.toJson(),
      DB_imgDetail: imgDetail,
      DB_txtdetail: txtdetail,
      DB_rating: rating,
      DB_room: room.toJson()
    };
  }
}
