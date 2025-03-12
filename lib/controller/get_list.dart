import 'package:rayo/model/alert_model.dart';
import 'package:rayo/model/locale_model.dart';
import 'package:rayo/utils/import_index.dart';

class GetList {
  static final GetList _instance = GetList._internal();
  factory GetList() {
    return _instance;
  }
  GetList._internal();
  static GetList get instance => _instance;

  Future<Map<String, dynamic>> userList(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    p(query);
    Map<String, dynamic> returnItem = {};
    List<UserModel> userList = <UserModel>[];
    String paginationQuery = '';
    final resbody =
        await API.get(uri: uri, query: query, returnControl: returnControl);
    if (resbody[statusCode] == 200 && resbody[data] != null) {
      for (var user in resbody[data]) {
        userList.add(UserModel.fromJson(user));
      }
      if (resbody[pagination] != null && resbody[pagination]['next'] != null) {
        paginationQuery = resbody[pagination]['next'];
      }
    }
    returnItem[data] = userList;
    returnItem[pagination] = paginationQuery;
    returnItem[statusCode] = resbody[statusCode];
    return returnItem;
  }

  Future<Map<String, dynamic>> moreUserList(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await Future.delayed(Duration(seconds: 3));
    Map<String, dynamic> returnItem = {};
    List<UserModel> userList = <UserModel>[];
    userList.add(UserModel.fromJson(
        {'seq': 5, 'name': '추가된 모델', DB_introduce: '자기소개하기'}));
    userList.add(UserModel.fromJson(
        {'seq': 6, 'name': '추가된 모델', DB_introduce: '자기소개하기'}));
    userList.add(UserModel.fromJson(
        {'seq': 7, 'name': '추가된 모델', DB_introduce: '자기소개하기'}));
    userList.add(UserModel.fromJson(
        {'seq': 8, 'name': '추가된 모델', DB_introduce: '자기소개하기'}));
    returnItem[data] = userList;
    returnItem[pagination] = '';
    returnItem[statusCode] = 200;
    return returnItem;
  }

  Future<Map<String, dynamic>> localeList(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> returnItem = {};
    // List<UserModel> userList = <UserModel>[];
    // final resbody = await API.get(uri: uri, query: query, returnControl: returnControl);
    returnItem[statusCode] = 200;
    returnItem[data] = [
      LocaleModel.fromJson(
          {'seq': 0, 'mainLocale': '서울', 'detailedLocale': '서울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 1, 'mainLocale': '서서서울', 'detailedLocale': '서서서서울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '사울', 'detailedLocale': '사울시 강남구'}),
      LocaleModel.fromJson(
          {'seq': 2, 'mainLocale': '마지막', 'detailedLocale': '사울시 강남구'}),
    ];
    return returnItem;
  }

  Future<Map<String, dynamic>> moretest(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await Future.delayed(Duration(seconds: 3));
    Map<String, dynamic> returnItem = {};
    List<UserModel> userList = <UserModel>[];
    userList.add(UserModel.fromJson(
        {'seq': 5, 'name': '추가된 모델', DB_introduce: '자기소개하기'}));
    userList.add(UserModel.fromJson(
        {'seq': 6, 'name': '추가된 모델', DB_introduce: '자기소개하기'}));
    userList.add(UserModel.fromJson(
        {'seq': 7, 'name': '추가된 모델', DB_introduce: '자기소개하기'}));
    userList.add(UserModel.fromJson(
        {'seq': 8, 'name': '추가된 모델', DB_introduce: '자기소개하기'}));
    returnItem[data] = userList;
    returnItem[pagination] = '';
    returnItem[statusCode] = 200;
    return returnItem;
  }

  Future<Map<String, dynamic>> testInit(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    p(uri);
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> returnItem = {};
    List<UserModel> userList = <UserModel>[];
    userList.add(UserModel.fromJson({
      'seq': 99,
      'name': 'ㅅㅎㄹㄹㄹ',
      DB_introduce: 'ㅎㅎㅎㅎ',
      'profileImg':
          'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
    }));
    userList.add(UserModel.fromJson({
      'seq': 2,
      'name': '테스트2번 모델',
      DB_introduce:
          'overflowTEST @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n@@@@@\n123'
    }));
    userList.add(UserModel.fromJson({
      'seq': 3,
      'name': '테스트3번 모델',
      DB_introduce: 'LimitOverflow60@@@@@\n@@@@@@@@@@\n@@@@@@@'
    }));
    userList.add(UserModel.fromJson({
      'seq': 4,
      'name': '테스트4번 모델',
      DB_introduce:
          'maxLine1 overFlowTest@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
    }));
    returnItem[data] = userList;
    returnItem[pagination] = '123';
    returnItem[statusCode] = 200;
    return returnItem;
  }

  Future<Map<String, dynamic>> roomList(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> returnItem = {};
    List<RoomModel> roomList = <RoomModel>[];
    p(uri);
    for (int i = 0; i < 20; i++) {
      int limit = Random().nextInt(3) + 2;
      roomList.add(RoomModel.fromJson({
        'seq': i,
        'name': '테스트$i번 모델',
        'location': '서울',
        'date': DateTime.now().millisecondsSinceEpoch,
        'master': {
          'seq': i,
          'name': '$i번방장',
          'gender': Random().nextInt(2) + 1,
          'birth': 1990,
          'profileImg':
              'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
        },
        'memberCount': Random().nextInt(limit) + 1,
        'memberLimit': limit,
        'completed': Random().nextBool(),
        'roomCat': {
          'food': Random().nextBool(),
          'amity': Random().nextBool(),
          'art': Random().nextBool(),
          'exercise': Random().nextBool(),
          'gender': Random().nextInt(2),
          'near': 0,
        }
      }));
    }
    returnItem[data] = roomList;
    returnItem[pagination] = '123';
    returnItem[statusCode] = 200;
    return returnItem;
  }

  Future<Map<String, dynamic>> moreRoomList(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> returnItem = {};
    List<RoomModel> roomList = <RoomModel>[];
    p(uri);
    for (int i = 20; i < 40; i++) {
      int limit = Random().nextInt(3) + 2;
      roomList.add(RoomModel.fromJson({
        'seq': i,
        'name': '테스트$i번 모델',
        'location': '서울',
        'date': DateTime.now().millisecondsSinceEpoch,
        'master': {
          'seq': i,
          'name': '$i번방장',
          'gender': Random().nextInt(2) + 1,
          'birth': 1990,
          'profileImg':
              'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
        },
        'memberCount': Random().nextInt(limit) + 1,
        'memberLimit': limit,
        'roomCat': {
          'food': Random().nextBool(),
          'amity': Random().nextBool(),
          'art': Random().nextBool(),
          'exercise': Random().nextBool(),
          'gender': Random().nextInt(2),
          'near': 0,
        }
      }));
    }
    returnItem[data] = roomList;
    if (query!['q'] == '123') {
      returnItem[pagination] = '456';
    } else {
      returnItem[pagination] = '';
    }

    returnItem[statusCode] = 200;
    return returnItem;
  }

  Future<Map<String, dynamic>> reviewBeforeWriteList(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> returnItem = {};
    List<ReviewModel> reviewList = <ReviewModel>[];
    p('작성해야할 방정보 가져오기 api');
    for (int i = 0; i < 20; i++) {
      // reviewList.add(ReviewModel(
      //     seq: i,
      //     profileImg:
      //         'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
      //     imgDetail: [
      //       'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
      //       'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG'
      //     ],
      //     name: 'test$i',
      //     txtdetail: '다같이 뛰니까\nkajsdhfjkahsdkjfhalksdj',
      //     rating: Random().nextDouble() * 5));
    }
    return returnItem;
  }

  Future<Map<String, dynamic>> reviewList(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> returnItem = {};
    List<ReviewModel> reviewList = <ReviewModel>[];
    p(uri);
    for (int i = 0; i < 20; i++) {
      int limit = Random().nextInt(3) + 2;
      List<double> possibleValues =
          List.generate(10, (index) => (index + 1) * 0.5);
      reviewList.add(ReviewModel.fromJson({
        'seq': i,
        'imgDetail': [
          'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
          'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG'
        ],
        'txtdetail':
            '다같이 뛰니까 서로 응원하게 되고 중간에 포기도 안하고\n러닝 후 먹는 고기는 또 얼마나 맛있게요\n이 멤버 기억할겁니다 꼭 다시 만나요~!~!~!\n특히 먹잘알 방장님.. 최고!!\n다같이 뛰니까 서로 응원하게 되고 중간에 포기도 안하고\n러닝 후 먹는 고기는 또 얼마나 맛있게요\n이 멤버 기억할겁니다 꼭 다시 만나요~!~!~!\n특히 먹잘알 방장님.. 최고!!',
        'rating': possibleValues[Random().nextInt(possibleValues.length)],
        'writer': {
          'seq': i == 2 ? LoginCtl.instance.user.seq : i,
          'name': i == 2 ? LoginCtl.instance.user.name : '$i번작성자',
          'profileImg': i == 2 ? LoginCtl.instance.user.profileImg : '',
        },
        'room': {
          'seq': i,
          'name': '테스트$i번 모델',
          'location': '서울',
          'date': DateTime.now().millisecondsSinceEpoch,
          'master': {
            'seq': i,
            'name': '$i번방장',
            'gender': Random().nextInt(2) + 1,
            'birth': 1990,
            'profileImg':
                'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
          },
          'memberCount': Random().nextInt(limit) + 1,
          'memberLimit': limit,
          'completed': Random().nextBool(),
          'roomCat': {
            'food': Random().nextBool(),
            'amity': Random().nextBool(),
            'art': Random().nextBool(),
            'exercise': Random().nextBool(),
            'gender': Random().nextInt(2),
            'near': 0,
          }
        }
      }));
    }
    returnItem[data] = reviewList;
    returnItem[pagination] = '123';
    returnItem[statusCode] = 200;
    return returnItem;
  }

  Future<Map<String, dynamic>> moreReviewList(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> returnItem = {};
    List<ReviewModel> reviewList = <ReviewModel>[];
    p(uri);
    for (int i = 20; i < 40; i++) {
      int limit = Random().nextInt(3) + 2;
      List<double> possibleValues =
          List.generate(10, (index) => (index + 1) * 0.5);
      reviewList.add(ReviewModel.fromJson({
        'seq': i,
        'imgDetail': [
          'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
          'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG'
        ],
        'txtdetail':
            '다같이 뛰니까 서로 응원하게 되고 중간에 포기도 안하고\n러닝 후 먹는 고기는 또 얼마나 맛있게요\n이 멤버 기억할겁니다 꼭 다시 만나요~!~!~!\n특히 먹잘알 방장님.. 최고!!\n다같이 뛰니까 서로 응원하게 되고 중간에 포기도 안하고\n러닝 후 먹는 고기는 또 얼마나 맛있게요\n이 멤버 기억할겁니다 꼭 다시 만나요~!~!~!\n특히 먹잘알 방장님.. 최고!!',
        'rating': possibleValues[Random().nextInt(possibleValues.length)],
        'writer': {
          'seq': i == 2 ? LoginCtl.instance.user.seq : i,
          'name': i == 2 ? LoginCtl.instance.user.name : '$i번작성자',
          'profileImg': i == 2 ? LoginCtl.instance.user.profileImg : '',
        },
        'room': {
          'seq': i,
          'name': '테스트$i번 모델',
          'location': '서울',
          'date': DateTime.now().millisecondsSinceEpoch,
          'master': {
            'seq': i,
            'name': '$i번방장',
            'gender': Random().nextInt(2) + 1,
            'birth': 1990,
            'profileImg':
                'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
          },
          'memberCount': Random().nextInt(limit) + 1,
          'memberLimit': limit,
          'completed': Random().nextBool(),
          'roomCat': {
            'food': Random().nextBool(),
            'amity': Random().nextBool(),
            'art': Random().nextBool(),
            'exercise': Random().nextBool(),
            'gender': Random().nextInt(2),
            'near': 0,
          }
        }
      }));
    }
    returnItem[data] = reviewList;
    if (query!['q'] == '123') {
      returnItem[pagination] = '456';
    } else {
      returnItem[pagination] = '';
    }

    returnItem[statusCode] = 200;
    return returnItem;
  }

  Future<Map<String, dynamic>> alertList(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> returnItem = {};
    List<AlertModel> alertList = <AlertModel>[];
    p(uri);
    List<String> alertCategory = ['친구방', '번개방', '담벼락', '대화방', '리커넥팅'];
    List<String> fL = ['새로운 메시지가 도착했어요', '새로운 영상메시지가 도착했어요'];
    for (int i = 0; i < 20; i++) {
      DateTime now = DateTime.now();
      Random random = Random();
      int randomDays = random.nextInt(30); // 0부터 29일까지의 랜덤한 일 수
      DateTime randomDate = now.subtract(Duration(days: randomDays));
      String alertCat = alertCategory[Random().nextInt(alertCategory.length)];
      alertList.add(AlertModel.fromJson({
        DB_seq: i,
        DB_alertCategory: alertCat,
        DB_alertTitle: alertCat == '친구방' || alertCat == '번개방'
            ? fL[Random().nextInt(fL.length)]
            : alertCat == '담벼락'
                ? '주최했던 [방제] 번개방 후기가 도착했어요'
                : alertCat == '대화방'
                    ? '[방제] 방이 한자리 남았어요!'
                    : '[닉네임]님의 메시지가 도착했어요',
        DB_date: randomDate.millisecondsSinceEpoch,
        DB_isRead: Random().nextBool(),
        DB_room: {
          'seq': i,
          'name': '테스트$i번 모델',
          'location': '서울',
          'date': DateTime.now().millisecondsSinceEpoch,
          'master': {
            'seq': i,
            'name': '$i번방장',
            'gender': Random().nextInt(2) + 1,
            'birth': 1990,
            'profileImg':
                'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
          },
          DB_memberList: i == 1
              ? [
                  {
                    DB_seq: i,
                    DB_profileImg:
                        'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
                  },
                  {
                    DB_seq: i,
                    DB_profileImg:
                        'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
                  },
                ]
              : i == 2
                  ? [
                      {
                        DB_seq: i,
                        DB_profileImg:
                            'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
                      },
                      {
                        DB_seq: i,
                        DB_profileImg:
                            'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
                      },
                      {
                        DB_seq: i,
                        DB_profileImg:
                            'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
                      }
                    ]
                  : [
                      {
                        DB_seq: i,
                        DB_profileImg:
                            'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
                      },
                    ]
        },
      }));
    }
    returnItem[data] = alertList;
    returnItem[pagination] = '123';
    returnItem[statusCode] = 200;
    return returnItem;
  }

  Future<Map<String, dynamic>> moreAlertList(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> returnItem = {};
    List<AlertModel> alertList = <AlertModel>[];
    p(uri);
    List<String> alertCategory = ['친구방', '번개방', '담벼락', '대화방', '리커넥팅'];
    List<String> fL = ['새로운 메시지가 도착했어요', '새로운 영상메시지가 도착했어요'];
    for (int i = 20; i < 40; i++) {
      DateTime now = DateTime.now();
      Random random = Random();
      int randomDays = random.nextInt(30); // 0부터 29일까지의 랜덤한 일 수
      DateTime randomDate = now.add(Duration(days: randomDays));
      String alertCat = alertCategory[Random().nextInt(alertCategory.length)];
      alertList.add(AlertModel.fromJson({
        DB_seq: i,
        DB_alertCategory: alertCat,
        DB_alertTitle: alertCat == '친구방' || alertCat == '번개방'
            ? fL[Random().nextInt(fL.length)]
            : alertCat == '담벼락'
                ? '주최했던 [방제] 번개방 후기가 도착했어요'
                : alertCat == '대화방'
                    ? '[방제] 방이 한자리 남았어요!'
                    : '[닉네임]님의 메시지가 도착했어요',
        DB_date: randomDate.millisecondsSinceEpoch,
        DB_isRead: Random().nextBool(),
        DB_room: {
          'seq': i,
          'name': '테스트$i번 모델',
          'location': '서울',
          'date': DateTime.now().millisecondsSinceEpoch,
          'master': {
            'seq': i,
            'name': '$i번방장',
            'gender': Random().nextInt(2) + 1,
            'birth': 1990,
            'profileImg':
                'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
          },
          DB_memberList: [
            {
              DB_seq: i,
              DB_profileImg:
                  'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
            },
          ]
        },
      }));
    }
    returnItem[data] = alertList;
    returnItem[statusCode] = 200;
    if (query!['q'] == '123') {
      returnItem[pagination] = '456';
    } else {
      returnItem[pagination] = '';
    }
    return returnItem;
  }

  Future<Map<String, dynamic>> getSeqtoUser(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> returnItem = {};

    List<UserModel> userList = <UserModel>[];
    p(uri);
    userList.add(
        UserModel.fromJson({'seq': 99, 'name': 'ㅅㅎㄹㄹㄹ', 'profileImg': ''}));
    userList.add(UserModel.fromJson({
      'seq': 85,
      'name': '12',
      'profileImg': 'user/85/17340431992345651000cf887d930a4b.webp'
    }));
    returnItem[data] = userList;
    returnItem[statusCode] = 200;
    return returnItem;
  }
}
