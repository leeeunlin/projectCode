import 'package:rayo/utils/import_index.dart';

class LocaleModel {
  int seq;
  String mainLocale;
  String detailedLocale;

  LocaleModel({
    required this.seq,
    required this.mainLocale,
    required this.detailedLocale,
  });
  factory LocaleModel.fromJson(Map<String, dynamic> json) {
    return LocaleModel(
      seq: json[DB_seq] ?? 0,
      mainLocale: json['mainLocale'] ?? '',
      detailedLocale: json['detailedLocale'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      DB_seq: seq,
      'mainLocale': mainLocale,
      'detailedLocale': detailedLocale,
    };
  }
}
