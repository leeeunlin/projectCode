import 'package:rayo/utils/import_index.dart';

class RecruitPage extends StatefulWidget {
  const RecruitPage({super.key});

  @override
  State<RecruitPage> createState() => RecruitPageState();
}

class RecruitPageState extends State<RecruitPage> {
  RoomModel roomModel = RoomModel.fromJson({});
  @override
  void initState() {
    super.initState();
    roomModel = RoomModel.fromJson({});
  }

  void init() {
    roomModel = RoomModel.fromJson({});
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black[80],
        shape: Border(
            bottom: BorderSide(
          color: black[80]!,
        )),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(shape: BoxShape.circle, color: white),
              child: BackBtn(func: () async {
                appStateKey.currentState!.idx2toLast();
              }),
            ),
            Spacer(),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), color: black[120]),
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
                'meetType'.tr(),
                style: TextStyle(
                    fontSize: 16,
                    height: 19.2 / 16,
                    fontWeight: FontWeight.w600,
                    color: white),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 16),
                physics: ClampingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              roomModel.roomCat.food = !roomModel.roomCat.food;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white,
                                  border: Border.all(
                                      color: roomModel.roomCat.food
                                          ? yellow
                                          : white,
                                      width: 3)),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25.5, horizontal: 36.5),
                              child: Column(
                                children: [
                                  Image.asset(
                                    PngIcon.ICON_food,
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'food'.tr(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        height: 14.4 / 12,
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              roomModel.roomCat.amity =
                                  !roomModel.roomCat.amity;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white,
                                  border: Border.all(
                                      color: roomModel.roomCat.amity
                                          ? yellow
                                          : white,
                                      width: 3)),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25.5, horizontal: 36.5),
                              child: Column(
                                children: [
                                  Image.asset(
                                    PngIcon.ICON_amity,
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'socializing'.tr(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        height: 14.4 / 12,
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              roomModel.roomCat.art = !roomModel.roomCat.art;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white,
                                  border: Border.all(
                                      color: roomModel.roomCat.art
                                          ? yellow
                                          : white,
                                      width: 3)),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25.5, horizontal: 36.5),
                              child: Column(
                                children: [
                                  Image.asset(PngIcon.ICON_art,
                                      width: 100, height: 100),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'artsCulture'.tr(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        height: 14.4 / 12,
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              roomModel.roomCat.exercise =
                                  !roomModel.roomCat.exercise;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white,
                                  border: Border.all(
                                      color: roomModel.roomCat.exercise
                                          ? yellow
                                          : white,
                                      width: 3)),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25.5, horizontal: 36.5),
                              child: Column(
                                children: [
                                  Image.asset(
                                    PngIcon.ICON_exercise,
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'sports'.tr(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        height: 14.4 / 12,
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (roomModel.roomCat.food ||
                roomModel.roomCat.amity ||
                roomModel.roomCat.art ||
                roomModel.roomCat.exercise)
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, NAV_RecruitNamePage, arguments: {
                    'roomModel': roomModel,
                  });
                },
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16), color: yellow),
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
              )
          ],
        ),
      )),
    );
  }
}
