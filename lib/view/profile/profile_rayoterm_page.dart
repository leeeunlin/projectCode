import 'package:rayo/utils/import_index.dart';

class ProfileRayotermPage extends StatelessWidget {
  const ProfileRayotermPage({super.key});
  @override
  Widget build(context) {
    InkWell rayoMenu({
      required String title,
      required VoidCallback func,
    }) =>
        InkWell(
            onTap: func,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                title,
                style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 19.09 / 16),
              ),
            ));
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text('Rayo'),
        leading: BackBtn(
            color: black,
            func: () async {
              Navigator.pop(context);
            }),
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              rayoMenu(
                  title: '오픈소스 라이선스',
                  func: () {
                    p('오픈소스 라이선스 페이지 이동');
                  }),
              rayoMenu(
                  title: '커뮤니티 가이드 라인',
                  func: () {
                    p('커뮤니티 가이드 라인 페이지 이동');
                  }),
              rayoMenu(
                  title: '이용 약관',
                  func: () {
                    p('이용 약관 페이지 이동');
                  }),
              rayoMenu(
                  title: '개인정보 처리 방침',
                  func: () {
                    p('개인정보 처리 방침 페이지 이동');
                  }),
              rayoMenu(
                  title: '위치기반서비스약관',
                  func: () {
                    p('위치기반서비스약관 페이지 이동');
                  }),
              rayoMenu(
                  title: '청소년 보호정책',
                  func: () {
                    p('청소년 보호정책 페이지 이동');
                  }),
            ],
          )),
    );
  }
}
