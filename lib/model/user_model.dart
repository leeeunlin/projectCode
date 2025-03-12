import 'package:rayo/utils/import_index.dart';

class UserModel {
  int seq;
  String name;
  String introduce; //
  String profileImg; //
  String number;
  String mail;
  ValueNotifier<int> point;
  double rating;
  int birth;
  int gender;
  Agreement agreement;
  AlertSetting alertSetting;
  bool friend;
  List<int> friendList;
  UserModel({
    required this.seq,
    required this.name,
    required this.introduce,
    required this.profileImg,
    required this.number,
    required this.mail,
    required this.point,
    required this.rating,
    required this.birth,
    required this.gender,
    required this.agreement,
    required this.alertSetting,
    required this.friend,
    required this.friendList,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        seq: json[DB_seq] ?? 0,
        name: json[DB_name] ?? '',
        introduce: json[DB_introduce] ?? '',
        profileImg: json[DB_profileImg] ?? '',
        number: json[DB_number] ?? '',
        mail: json[DB_mail] ?? '',
        point: ValueNotifier<int>(json[DB_point] ?? 0),
        rating: json[DB_rating] ?? 0.0,
        birth: json[DB_birth] ?? 0,
        gender: json[DB_gender] ?? 0,
        agreement: Agreement.fromJson(json[DB_agreement] ?? {}),
        alertSetting: AlertSetting.fromJson(json[DB_alertSetting] ?? {}),
        friend: json[DB_friend] ?? false,
        friendList: List<int>.from(json[DB_friendList] ?? []));
  }
  Map<String, dynamic> toJson() {
    return {
      DB_name: name,
      DB_introduce: introduce,
      DB_profileImg: profileImg,
      DB_birth: birth,
      DB_gender: gender,
      DB_agreement: agreement.toJson(),
    };
  }
}

class Agreement {
  bool age;
  bool term;
  bool privacy;
  bool location;
  bool marketing;
  Agreement({
    required this.age,
    required this.term,
    required this.privacy,
    required this.location,
    required this.marketing,
  });
  factory Agreement.fromJson(Map<String, dynamic> json) {
    return Agreement(
      age: json[DB_age] ?? false,
      term: json[DB_term] ?? false,
      privacy: json[DB_privacy] ?? false,
      location: json[DB_location] ?? false,
      marketing: json[DB_marketing] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      DB_age: age,
      DB_term: term,
      DB_privacy: privacy,
      DB_location: location,
      DB_marketing: marketing,
    };
  }
}

class AlertSetting {
  bool deviceAlert;
  bool marketingAlert;
  AlertSetting({
    required this.deviceAlert,
    required this.marketingAlert,
  });
  factory AlertSetting.fromJson(Map<String, dynamic> json) {
    AlertSetting alertSetting = AlertSetting(
      deviceAlert: json[DB_deviceAlert] ?? true,
      marketingAlert: json[DB_marketingAlert] ?? true,
    );
    return alertSetting;
  }
  Map<String, dynamic> toJson() {
    return {
      DB_deviceAlert: deviceAlert,
      DB_marketingAlert: marketingAlert,
    };
  }
}
