import 'package:rayo/utils/import_index.dart';

class RecruitPersonGenderPage extends StatefulWidget {
  final RoomModel roomModel;
  const RecruitPersonGenderPage({required this.roomModel, super.key});
  @override
  State<RecruitPersonGenderPage> createState() =>
      _RecruitPersonGenderPageState();
}

class _RecruitPersonGenderPageState extends State<RecruitPersonGenderPage> {
  @override
  void initState() {
    super.initState();
    widget.roomModel.memberLimit = 0;
    widget.roomModel.roomCat.gender = 99;
  }

  @override
  Widget build(context) {
    InkWell setMemberLimit(int idx) => InkWell(
        onTap: () async {
          if (idx == 2) {
            await durationPopup(
                context,
                defaultAlertDalog(context, '본인과 다른 성별을\n모집할 수 있습니다.',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 24 / 16,
                        color: black)));
          }
          widget.roomModel.memberLimit = idx;
          widget.roomModel.roomCat.gender = 99;
          setState(() {});
        },
        child: Container(
            alignment: Alignment.center,
            height: 45,
            width: MediaQuery.of(context).size.width / 3 - 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: white,
              border: Border.all(
                  color: widget.roomModel.memberLimit == idx ? yellow : white,
                  width: 3),
            ),
            child: Text(
              '$idx명',
              style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 14.32 / 12),
            )));

    Widget setGender(int idx) => InkWell(
        onTap: () async {
          widget.roomModel.roomCat.gender = idx;
          setState(() {});
        },
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 8),
            width: widget.roomModel.memberLimit == 2
                ? MediaQuery.of(context).size.width / 3 - 24
                : MediaQuery.of(context).size.width / 2 - 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: white,
              border: Border.all(
                  color:
                      widget.roomModel.roomCat.gender == idx ? yellow : white,
                  width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  idx == 1
                      ? PngIcon.ICON_female_gender
                      : idx == 2
                          ? PngIcon.ICON_male_gender
                          : PngIcon.ICON_all_gender,
                  width: 70,
                  height: 45,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  idx == 1
                      ? 'womenOnly'.tr()
                      : idx == 2
                          ? 'menOnly'.tr()
                          : 'allGenders'.tr(),
                  style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 14 / 12),
                )
              ],
            )));

    return Scaffold(
        backgroundColor: black[80],
        appBar: AppBar(
          backgroundColor: black[80],
          shape: Border(
              bottom: BorderSide(
            color: black[80]!,
          )),
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: white),
                child: BackBtn(func: () async {
                  Navigator.pop(context);
                }),
              ),
              Spacer(),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: black[120]),
                  child: Container(
                      width: 36,
                      height: 36,
                      margin: EdgeInsets.all(8),
                      child: CloudWidget())),
            ],
          ),
        ),
        body: SafeArea(
            child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'HowManyRecruit'.tr(),
                        style: TextStyle(
                            fontSize: 16,
                            height: 19.2 / 16,
                            fontWeight: FontWeight.w600,
                            color: white),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 2; i < 5; i++) setMemberLimit(i),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.roomModel.memberLimit == 2)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [setGender(0), setGender(1), setGender(2)],
                      ),
                    if (widget.roomModel.memberLimit != 2 &&
                        widget.roomModel.memberLimit != 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          setGender(0),
                          setGender(LoginCtl.instance.user.gender)
                        ],
                      ),
                    Spacer(),
                    if (widget.roomModel.roomCat.gender != 99)
                      InkWell(
                        onTap: () async {
                          Navigator.pushNamed(context, NAV_RecruitVerifyPage,
                              arguments: {
                                'roomModel': widget.roomModel,
                              });
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: yellow),
                            width: double.infinity,
                            padding: const EdgeInsets.all(15.5),
                            child: Text(
                              'next'.tr(),
                              style: TextStyle(
                                  fontSize: 16,
                                  height: 19.09 / 16,
                                  fontWeight: FontWeight.w700,
                                  color: black),
                            )),
                      ),
                  ],
                ))));
  }
}
