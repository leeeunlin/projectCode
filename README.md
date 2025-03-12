# rayo

### 1회성 컨트롤러의 경우 추가적인 컨트롤러 생성하지 않고 UI에서 처리한다.
- `PageController`, `TextEditingController` 등

### 컨트롤러 생성의 경우 다중 사용할 컨트롤러가 아닌이상 싱글톤처리후 적용한다
```dart
class TestCtl {
   static final TestCtl _instance = TestCtl._internal();
   factory TestCtl(){
      return _instance;
   }
   TestCtl._internal();
   static TestCtl get instance => _instance;
   // 아래 코드 작성
   ..
}
```

### 리스트를 가져오는 컨트롤러는 get_list.dart에서 전부 처리한다.
- 해당 컨트롤러는 1회성 컨트롤러로 API처리 후 리턴값을 그대로 가져와 처리한다.
- 값에 대한 후처리는 각 UI에서 진행한다
- init이 필요한 경우 `StatefulWidget` 으로 처리하며, initState()에서 해당 항목을 불러온다.
```dart
@override
void initState() {
 super.initState();
 GetList.instance.가져올리스트함수()
}
// 세부적인 코드 처리 방식은 profile_blocked_page.dart 파일을 참고
```
- 기본적인 문법으로 `initState()` 에서는 super.initState(); 아래에 init작업처리를 하고 `dispose()` 에서는 dispose작업 처리를 진행 후 super.dispose(); 처리한다.
```dart
@override
void initState() {
   super.initState();
   // 이곳에 코드 작성
}
@override
void dispose() {
   // 이곳에 코드 작성
   super.dispose();
}
```

### 라우팅 처리에 관한 사항
- 새로운 페이지 생성하여 라우팅을 처리할경우에는 `key_nav.dart` 파일에 라우팅 이름을 넣고 `nav_routing.dart` 파일에 라우팅을 적용한다.
- API statusCode의 경우 전체 로직에 무조건 리턴을 해줘야하며, 특이사항인 최초 가입시 휴대폰번호 인증만 401 예외처리를 진행해두었다.
```dart
  static Future<void> _statusCheck(
      {required int code,
      required Map<String, dynamic> resbody,
      required bool returnControl}) async {
    if (code != 200) {
      switch (code) {
        case 401:
          if (!returnControl) {
            AppState.allPageClose();
          }
          p(code);
          throw {statusCode: code, 'message': resbody['message'] ?? ''};
        case 422:
          p(code);
          throw {statusCode: code, 'message': resbody['message'] ?? ''};
        case 400:
          p(code);
          snackBar(content: '잠시 후 다시 시도해주세요.');
          throw {statusCode: code, 'message': resbody['message'] ?? ''};
        case 500:
          p(code);
          snackBar(content: '잠시 후 다시 시도해주세요.');
          throw {statusCode: code, 'message': resbody['message'] ?? ''};
        default:
          p(code);
          snackBar(content: '잠시 후 다시 시도해주세요.');
          throw {statusCode: code, 'message': resbody['message'] ?? ''};
      }
    }
  }
```

### 하단바가 없어야 될 상황
- `nav_routing.dart` 파일의 `hiddenRoutes` 리스트에 해당 라우팅 이름을 나열해둔다.
```dart
List<String> hiddenRoutes = [
  NAV_VideoCallPage,
  NAV_ProfileModifyPage,
  NAV_LoginNumberPage,
  NAV_LoginNumberVerifyPage,
  NAV_LoginMailPage,
  ...
]
```
- 하단탭은 `IndexedStack`으로 생성되어있으며 각각의 `Navigator`에 호출 `observers`가 달려있다. 자세한 내용은 `app.dart` 파일 참고
### 노드 테스트 서버
```
% cd server
% npm run dev
```
