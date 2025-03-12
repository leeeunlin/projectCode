import 'package:rayo/utils/import_index.dart';

class LoginBirthPage extends StatelessWidget {
  const LoginBirthPage({super.key});

  @override
  Widget build(context) {
    ValueNotifier<bool> selectVal = ValueNotifier<bool>(false);
    int selectDate = 883580400000;

    TextStyle ymdtxtStyle({required bool selectDate}) {
      return TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          height: 18 / 18,
          color: selectDate ? black : black[20]);
    }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              color: yellow,
              child: Text(
                'enterbirth'.tr(),
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
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, color: white),
                ),
              ),
              StatefulBuilder(
                builder: (_, setState) => InkWell(
                  onTap: () async {
                    Map<String, dynamic> item =
                        await dateSelecter(context, date: selectDate);
                    if (item['select']) {
                      selectVal.value = true;
                      selectDate = item['dateTime'];
                    }
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(34),
                    margin: const EdgeInsets.only(
                      top: 0,
                      right: 16,
                      bottom: 21,
                      left: 16,
                    ),
                    height: 130,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: white,
                      boxShadow: [
                        BoxShadow(
                          color: black[40]!,
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: 75,
                            height: 34,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: yellow),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              '${DateTime.fromMillisecondsSinceEpoch(selectDate).year}',
                              style: ymdtxtStyle(selectDate: selectVal.value),
                            )),
                        Text(
                          'year'.tr(),
                          style: ymdtxtStyle(selectDate: true),
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: 49,
                            height: 34,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: yellow),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              '${DateTime.fromMillisecondsSinceEpoch(selectDate).month}',
                              style: ymdtxtStyle(selectDate: selectVal.value),
                            )),
                        Text(
                          'month'.tr(),
                          style: ymdtxtStyle(selectDate: true),
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: 49,
                            height: 34,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: yellow),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              '${DateTime.fromMillisecondsSinceEpoch(selectDate).day}',
                              style: ymdtxtStyle(selectDate: selectVal.value),
                            )),
                        Text(
                          'day'.tr(),
                          style: ymdtxtStyle(selectDate: true),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          ValueListenableBuilder<bool>(
            valueListenable: selectVal,
            builder: (_, selectVal, child) => Expanded(
                child: Container(
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    color: white,
                    child: InkWell(
                      onTap: selectVal
                          ? () async {
                              LoginCtl.instance.user.birth = selectDate;
                              Navigator.pushNamed(context, NAV_LoginGenderPage);
                            }
                          : null,
                      child: Container(
                          margin: const EdgeInsets.all(23),
                          child: SvgPicture.asset(SvgIcon.ICON_arrowNext,
                              colorFilter: ColorFilter.mode(
                                selectVal ? yellow : black[60]!,
                                BlendMode.srcIn,
                              ))),
                    ))),
          ),
        ],
      ),
    );
  }
}
