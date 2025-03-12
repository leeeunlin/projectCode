import 'package:rayo/utils/import_index.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                alignment: Alignment.bottomRight,
                color: yellow,
                child: SizedBox(
                    height: 509,
                    child: Image.asset(PngIcon.ICON_rayoImg,
                        fit: BoxFit.fitHeight,
                        opacity: const AlwaysStoppedAnimation(.2))),
              ),
            ),
            SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  child: Text(
                    'title'.tr(),
                    style: const TextStyle(
                      fontSize: 30,
                      color: white,
                      fontWeight: FontWeight.w800,
                      height: 40 / 30,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  child: Text(
                    'subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: white,
                      fontWeight: FontWeight.w600,
                      height: 30 / 20,
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, NAV_LoginTermsPage);
                  },
                  child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: white),
                      child: Text('phonestart'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 24 / 16,
                              color: Color(0xFF82828C)))),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, NAV_LoginProblemPage);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 16,
                      child: Text(
                        'loginproblem'.tr(),
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: white,
                            color: white),
                      ),
                    )),
                const SizedBox(
                  height: 130,
                )
              ],
            ))
          ],
        ));
  }
}
