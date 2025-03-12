import 'package:rayo/utils/import_index.dart';

class LoginFinishPage extends StatelessWidget {
  const LoginFinishPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginCtl.instance.loginSuccessPage(context);
    return Scaffold(
        backgroundColor: white,
        body: Stack(
          children: [
            Container(
              alignment: Alignment.bottomRight,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: yellow,
              child: SizedBox(
                  height: 509,
                  child: Image.asset(PngIcon.ICON_rayoImg,
                      fit: BoxFit.fitHeight,
                      opacity: const AlwaysStoppedAnimation(.2))),
            ),
            SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 48,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Text(
                    'congratulations'.tr(),
                    style: const TextStyle(
                      fontSize: 30,
                      color: white,
                      fontWeight: FontWeight.w600,
                      height: 45 / 30,
                    ),
                  ),
                ),
              ],
            ))
          ],
        ));
  }
}
