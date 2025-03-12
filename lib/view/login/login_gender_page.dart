import 'package:rayo/utils/import_index.dart';

class LoginGenderPage extends StatelessWidget {
  const LoginGenderPage({super.key});

  @override
  Widget build(context) {
    ValueNotifier<int> selectValue = ValueNotifier<int>(0);

    return Scaffold(
        backgroundColor: yellow,
        appBar: AppBar(
          backgroundColor: yellow,
          shape: const Border(
            bottom: BorderSide(color: yellow, width: 0.25),
          ),
          leading: BackBtn(
            color: white,
            func: () async {
              Navigator.pop(context);
            },
          ),
        ),
        body: ValueListenableBuilder<int>(
          valueListenable: selectValue,
          builder: (_, selectVal, child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  color: yellow,
                  child: Text(
                    'selectgender'.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        height: 40 / 30,
                        color: white),
                  )),
              const SizedBox(
                height: 44,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 75,
                    child: Container(
                      height: 666,
                      width: 654,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          selectValue.value = 1;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              top: 0, right: 16, bottom: 21, left: 16),
                          width: MediaQuery.of(context).size.width * 0.5 - 32,
                          height: 130,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  width: 3,
                                  color: selectVal == 1 ? yellow : white),
                              color: white,
                              boxShadow: [
                                BoxShadow(
                                  color: black[40]!,
                                  blurRadius: 20,
                                  offset: const Offset(0, 0),
                                ),
                              ]),
                          child: SizedBox(
                              width: 62,
                              height: 75,
                              child: Image.asset(PngIcon.ICON_genderFemale)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          selectValue.value = 2;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              top: 0, right: 16, bottom: 21, left: 16),
                          width: MediaQuery.of(context).size.width * 0.5 - 32,
                          height: 130,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  width: 3,
                                  color: selectVal == 2 ? yellow : white),
                              color: white,
                              boxShadow: [
                                BoxShadow(
                                  color: black[40]!,
                                  blurRadius: 20,
                                  offset: const Offset(0, 0),
                                ),
                              ]),
                          child: SizedBox(
                              width: 62,
                              height: 75,
                              child: Image.asset(PngIcon.ICON_genderMale)),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Expanded(
                  child: Container(
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                      color: white,
                      child: InkWell(
                        onTap: selectVal != 0
                            ? () async {
                                LoginCtl.instance.user.gender = selectVal;
                                Navigator.pushNamed(
                                    context, NAV_LoginProfilePage);
                              }
                            : null,
                        child: Container(
                            margin: const EdgeInsets.all(23),
                            child: SvgPicture.asset(SvgIcon.ICON_arrowNext,
                                colorFilter: ColorFilter.mode(
                                  selectVal != 0 ? yellow : black[60]!,
                                  BlendMode.srcIn,
                                ))),
                      ))),
            ],
          ),
        ));
  }
}
