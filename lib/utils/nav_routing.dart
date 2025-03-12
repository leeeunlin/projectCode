import 'package:rayo/db/model/hive_room_model.dart';
import 'package:rayo/utils/import_index.dart';
import 'package:rayo/view/chat/chat_room_page.dart';
import 'package:rayo/view/profile/profile_call_history_page.dart';
import 'package:rayo/view/profile/profile_friend_reconnect_page.dart';

/// 페이지 이동함수 페이지가 많거나 너무 길어질 경우 파일 분할 고려
GlobalKey<AppState> appStateKey = GlobalKey<AppState>();
GlobalKey<RecruitPageState> recruitPageStateKey = GlobalKey<RecruitPageState>();
GlobalKey<ReviewListPageState> reviewListPageStateKey =
    GlobalKey<ReviewListPageState>();
dynamic routeFunc(RouteSettings settings) {
  final Map<String, dynamic> args =
      settings.arguments as Map<String, dynamic>? ?? {};
  switch (settings.name) {
    case NAV_Root:
      Widget widget = Root();
      return route(widget, settings.name!);
    case NAV_LoginProblemPage:
      Widget widget = LoginProblemPage();
      return route(widget, settings.name!);
    case NAV_LoginTermsPage:
      Widget widget = LoginTermsPage();
      return route(widget, settings.name!);
    case NAV_LoginNumberPage:
      bool modify = args['modify'] ?? false;
      Widget widget = LoginNumberPage(modify: modify);
      return route(widget, settings.name!);
    case NAV_LoginNumberVerifyPage:
      Widget widget = LoginNumberVerifyPage(args: args);
      return route(widget, settings.name!);
    case NAV_LoginBirthPage:
      Widget widget = LoginBirthPage();
      return route(widget, settings.name!);
    case NAV_LoginGenderPage:
      Widget widget = LoginGenderPage();
      return route(widget, settings.name!);
    case NAV_LoginProfilePage:
      Widget widget = LoginProfilePage();
      return route(widget, settings.name!);
    case NAV_LoginFinishPage:
      Widget widget = LoginFinishPage();
      return route(widget, settings.name!);
    case NAV_VideoCallPage:
      RoomModel roomModel = args['roomModel'];
      Widget widget = VideoCallPage(roomModel: roomModel);
      return route(widget, settings.name!);
    case NAV_HomePage:
      Widget widget = HomePage();
      return route(widget, settings.name!);
    case NAV_HomeAlertPage:
      Widget widget = HomeAlertPage();
      return route(widget, settings.name!);
    case NAV_SearchPage:
      Widget widget = SearchPage();
      return route(widget, settings.name!);
    case NAV_ReviewListPage:
      Widget widget = ReviewListPage(key: reviewListPageStateKey);
      return route(widget, settings.name!);
    case NAV_RecruitPage:
      Widget widget = RecruitPage(
        key: recruitPageStateKey, // app.dart 파일에서 init 사용하기위한 StateKey
      );
      return route(widget, settings.name!);
    case NAV_RecruitNamePage:
      RoomModel roomModel = args['roomModel'];
      Widget widget = RecruitNamePage(roomModel: roomModel);
      return route(widget, settings.name!);
    case NAV_RecruitDateLocalePage:
      RoomModel roomModel = args['roomModel'];
      Widget widget = RecruitDateLocalePage(roomModel: roomModel);
      return route(widget, settings.name!);
    case NAV_RecruitPersonGenderPage:
      RoomModel roomModel = args['roomModel'];
      Widget widget = RecruitPersonGenderPage(roomModel: roomModel);
      return route(widget, settings.name!);
    case NAV_RecruitVerifyPage:
      RoomModel roomModel = args['roomModel'];
      Widget widget = RecruitVerifyPage(roomModel: roomModel);
      return route(widget, settings.name!);
    case NAV_ProfilePage:
      Widget widget = ProfilePage();
      return route(widget, settings.name!);
    case NAV_SearchListPage:
      Widget widget = SearchListPage();
      return route(widget, settings.name!);
    case NAV_ProfileModifyPage:
      Widget widget = ProfileModifyPage();
      return route(widget, settings.name!);
    case NAV_ProfileSettingPage:
      Widget widget = ProfileSettingPage();
      return route(widget, settings.name!);
    case NAV_LoginMailPage:
      bool modify = args['modify'] ?? false;
      Widget widget = LoginMailPage(modify: modify);
      return route(widget, settings.name!);
    case NAV_LoginMailVerifyPage:
      Widget widget = LoginMailVerifyPage(args: args);
      return route(widget, settings.name!);
    case NAV_ProfileAccountManagementPage:
      Widget widget = ProfileAccountManagementPage();
      return route(widget, settings.name!);
    case NAV_ProfileAccountClosePage:
      Widget widget = ProfileAccountClosePage();
      return route(widget, settings.name!);
    case NAV_ProfileAccountCloseVerifyPage:
      Widget widget = ProfileAccountCloseVerifyPage();
      return route(widget, settings.name!);
    case NAV_ProfileAlertPage:
      Widget widget = ProfileAlertPage();
      return route(widget, settings.name!);
    case NAV_ShopPage:
      Widget widget = ShopPage();
      return route(widget, settings.name!);
    case NAV_ProfileBlockedHiddenPage:
      String type = args['type'];
      Widget widget = ProfileBlockedHiddenPage(type: type);
      return route(widget, settings.name!);
    case NAV_ProfileReviewPage:
      Widget widget = ProfileReviewPage();
      return route(widget, settings.name!);
    case NAV_ProfileHostedPage:
      Widget widget = ProfileHostedPage();
      return route(widget, settings.name!);
    case NAV_ProfileJoinedPage:
      Widget widget = ProfileJoinedPage();
      return route(widget, settings.name!);
    case NAV_ProfileCsCenterPage:
      Widget widget = ProfileCsCenterPage();
      return route(widget, settings.name!);
    case NAV_ProfileRayotermPage:
      Widget widget = ProfileRayotermPage();
      return route(widget, settings.name!);
    case NAV_ReviewWritePage:
      RoomModel roomModel = args['roomModel'];
      Widget widget = ReviewWritePage(
        roomModel: roomModel,
      );
      return route(widget, settings.name!);
    case NAV_ReportPage:
      UserModel userModel = args['userModel'];
      Widget widget = ReportPage(userModel: userModel);
      return route(widget, settings.name!);
    case NAV_ChatListPage:
      Widget widget = ChatListPage();
      return route(widget, settings.name!);
    case NAV_ChatRoomPage:
      HiveRoomModel hiveRoomModel = args['HiveRoomModel'];
      Widget widget = ChatRoomPage(room: hiveRoomModel);
      return route(widget, settings.name!);
    case NAV_ProfileFriendReconnectPage:
      int catIdx = args['catIdx'];
      Widget widget = ProfileFriendReconnectPage(catIdx: catIdx);
      return route(widget, settings.name!);
    case NAV_ProfileCallHistoryPage:
      Widget widget = ProfileCallHistoryPage();
      return route(widget, settings.name!);
  }
}

dynamic route(Widget widget, String name) {
  if (Platform.isIOS) {
    return CupertinoPageRoute(
      settings: RouteSettings(name: name),
      builder: (context) => widget,
    );
  } else {
    return PageRouteBuilder(
      settings: RouteSettings(
        name: name,
      ),
      pageBuilder: (context, animation, secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: transitionsBuilder,
    );
  }
}

SlideTransition transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  var begin = const Offset(1.0, 0);
  var end = Offset.zero;
  // Curves.ease: 애니메이션이 부드럽게 동작하도록 명령
  var curve = Curves.ease;
  // 애니메이션의 시작과 끝을 담당
  var tween = Tween(
    begin: begin,
    end: end,
  ).chain(
    CurveTween(
      curve: curve,
    ),
  );
  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}

List<String> hiddenRoutes = [
  NAV_VideoCallPage,
  NAV_ProfileModifyPage,
  NAV_LoginNumberPage,
  NAV_LoginNumberVerifyPage,
  NAV_LoginMailPage,
  NAV_LoginMailVerifyPage,
  NAV_ReviewWritePage,
  NAV_ShopPage,
  NAV_ChatListPage,
  NAV_ChatRoomPage,
  NAV_ProfileFriendReconnectPage,
  NAV_ProfileCallHistoryPage,
  NAV_ProfileHostedPage,
  NAV_ProfileJoinedPage,
  NAV_ProfileSettingPage,
  NAV_ProfileBlockedHiddenPage,
  NAV_ProfileReviewPage,
  NAV_ProfileAlertPage,
  NAV_ProfileAccountClosePage,
  NAV_ProfileAccountCloseVerifyPage,
  NAV_ProfileAccountManagementPage,
  NAV_SearchListPage,
  NAV_ReportPage
];
