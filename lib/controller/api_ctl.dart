import 'package:rayo/utils/import_index.dart';

// 200 : 정상
// 401 : 인증 실패
// 408 : 타임아웃
// 422 : Validation 통과 실패
// 400 : 잘못된 요청
// 500 : 런타임 에러
bool testServer = false; // localDB connect 필요시 true 변경

class API {
  static String _token = '';

  static Future<dynamic> get(
      {required String uri,
      Map<String, String>? query,
      bool returnControl = false}) async {
    await _expCheck();
    try {
      Uri setUri = _getUri(uri: uri, query: query);
      final Response res = await Client().get(setUri, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $_token',
        'app-version': LoginCtl.instance.appInfo.version,
      }).timeout(Duration(seconds: 30));
      await _apiHeaderCheck(header: res.headers);
      final Map<String, dynamic> resbody =
          jsonDecode(const Utf8Decoder().convert(res.bodyBytes))
              as Map<String, dynamic>;
      resbody[statusCode] = res.statusCode;
      await _statusCheck(
          code: res.statusCode, resbody: resbody, returnControl: returnControl);
      return resbody;
    } on TimeoutException catch (_) {
      return _timeoutCheck();
    } catch (e) {
      return e;
    } finally {
      Client().close();
    }
  }

  static Future<dynamic> post(
      {required String uri,
      String data = '',
      List<MultipartFile> imageDataList = const [],
      bool returnControl = false}) async {
    await _expCheck();
    try {
      Uri setUri = _getUri(uri: uri);
      final MultipartRequest request = MultipartRequest('post', setUri)
        ..headers.addAll({
          'Authorization': 'Bearer $_token',
          'app-version': LoginCtl.instance.appInfo.version,
        })
        ..fields.addAll({"data": data})
        ..files.addAll(imageDataList);
      StreamedResponse res =
          await request.send().timeout(Duration(seconds: 30));
      await _apiHeaderCheck(header: res.headers);
      String bodyConvert = await res.stream.bytesToString();
      final Map<String, dynamic> resbody =
          jsonDecode(bodyConvert) as Map<String, dynamic>;
      resbody[statusCode] = res.statusCode;
      await _statusCheck(
          code: res.statusCode, resbody: resbody, returnControl: returnControl);
      return resbody;
    } on TimeoutException catch (_) {
      return _timeoutCheck();
    } catch (e) {
      return e;
    }
  }

  static Future<dynamic> put(
      {required String uri,
      String data = '',
      List<MultipartFile> imageDataList = const [],
      bool returnControl = false}) async {
    await _expCheck();
    try {
      Uri setUri = _getUri(uri: uri);
      final MultipartRequest request = MultipartRequest('put', setUri)
        ..headers.addAll({
          'Authorization': 'Bearer $_token',
          'app-version': LoginCtl.instance.appInfo.version,
        })
        ..fields.addAll({"data": data})
        ..files.addAll(imageDataList);
      StreamedResponse res =
          await request.send().timeout(Duration(seconds: 30));
      await _apiHeaderCheck(header: res.headers);
      String bodyConvert = await res.stream.bytesToString();
      final Map<String, dynamic> resbody =
          jsonDecode(bodyConvert) as Map<String, dynamic>;
      resbody[statusCode] = res.statusCode;
      await _statusCheck(
          code: res.statusCode, resbody: resbody, returnControl: returnControl);
      return resbody;
    } on TimeoutException catch (_) {
      return _timeoutCheck();
    } catch (e) {
      return e;
    }
  }

  static Future<dynamic> delete(
      {required String uri,
      required String data,
      bool returnControl = false}) async {
    await _expCheck();
    try {
      Uri setUri = _getUri(uri: uri);
      final MultipartRequest request = MultipartRequest('delete', setUri)
        ..headers.addAll({
          'Authorization': 'Bearer $_token',
          'app-version': LoginCtl.instance.appInfo.version,
        })
        ..fields.addAll({"data": data});
      StreamedResponse res =
          await request.send().timeout(Duration(seconds: 30));
      await _apiHeaderCheck(header: res.headers);
      String bodyConvert = await res.stream.bytesToString();
      final Map<String, dynamic> resbody =
          jsonDecode(bodyConvert) as Map<String, dynamic>;
      resbody[statusCode] = res.statusCode;
      await _statusCheck(
          code: res.statusCode, resbody: resbody, returnControl: returnControl);
      return resbody;
    } on TimeoutException catch (_) {
      return _timeoutCheck();
    } catch (e) {
      return e;
    }
  }

  static Uri _getUri({
    required String uri,
    Map<String, String>? query,
  }) {
    return testServer
        ? Uri.http(localUri, uri, query ?? {})
        : Uri.https(serverUri, uri, query ?? {});
  }

  static Future<void> _expCheck() async {
    if (_token != '') {
      Duration expired = JwtDecoder.getRemainingTime(_token);
      if (expired.inMinutes < 10) {
        _token = LoginCtl.instance.prefs.getString('refTK') ?? '';
      }
    } else {
      _token = LoginCtl.instance.prefs.getString('refTK') ?? '';
    }
  }

  static Future<void> _apiHeaderCheck(
      {required Map<String, String> header}) async {
    if (header['refresh-token'] != null) {
      LoginCtl.instance.prefs.setString('refTK', header['refresh-token']!);
    }
    if (header['access-token'] != null) {
      _token = header['access-token']!;
    }
  }

  static Future<void> _statusCheck(
      {required int code,
      required Map<String, dynamic> resbody,
      required bool returnControl}) async {
    // 401의 경우 인증 실패 코드지만 첫 회원가입시 가입판단여부를 위해 사용함
    // returnControl이 false일 경우 모든 페이지를 닫고 로그인 페이지로 이동
    // returnControl이 true일 경우 401반환
    if (code == 200) {
      p('$code 정상');
    }
    if (code != 200) {
      switch (code) {
        case 401:
          if (!returnControl) {
            LoginCtl.instance.logOut(accountClose: true);
          }
          p('$code 인증실패(최초로그인의 경우 무시)');
          throw {statusCode: code, 'message': resbody['message'] ?? ''};
        case 422:
          p('$code 서버요청 처리 실패');
          throw {statusCode: code, 'message': resbody['message'] ?? ''};
        case 400:
          p('$code 잘못된 요청');
          snackBar(content: '잠시 후 다시 시도해주세요.');
          throw {statusCode: code, 'message': resbody['message'] ?? ''};
        case 500:
          p('$code 서버 응답없음');
          snackBar(content: '잠시 후 다시 시도해주세요.');
          throw {statusCode: code, 'message': resbody['message'] ?? ''};
        default:
          p('$code 기타 에러');
          snackBar(content: '잠시 후 다시 시도해주세요.');
          throw {statusCode: code, 'message': resbody['message'] ?? ''};
      }
    }
  }

  static Future<Map<String, dynamic>> _timeoutCheck() async {
    snackBar(content: '잠시 후 다시 시도해주세요.');
    p('408 타임아웃');
    return {statusCode: 408};
  }
}
