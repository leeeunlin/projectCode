import 'package:rayo/utils/import_index.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shape:
            Border(bottom: BorderSide(color: Colors.transparent, width: 0.25)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: Text(
                'joinMeet'.tr(),
                style: TextStyle(
                    fontSize: 16,
                    height: 19.2 / 16,
                    fontWeight: FontWeight.w600,
                    color: white),
              ),
            ),
            Expanded(
              child: ListView(
                padding:
                    EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (SearchCtl.instance.near == 3) {
                              SearchCtl.instance.near = 0;
                            } else {
                              SearchCtl.instance.near += 1;
                            }
                            setState(() {});
                            p(SearchCtl.instance.near);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(7),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 45,
                                    height: 45,
                                    child: Image.asset(PngIcon.ICON_mini_near),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'nearby'.tr(),
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
                            if (SearchCtl.instance.gender == 99) {
                              SearchCtl.instance.gender = 1;
                            } else if (SearchCtl.instance.gender == 2) {
                              SearchCtl.instance.gender = 0;
                            } else if (SearchCtl.instance.gender == 0) {
                              SearchCtl.instance.gender = 99;
                            } else {
                              SearchCtl.instance.gender++;
                            }
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: white,
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(7),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 45,
                                    height: 45,
                                    child: Image.asset(
                                        SearchCtl.instance.gender == 99
                                            ? PngIcon.ICON_gender
                                            : SearchCtl.instance.gender == 1
                                                ? PngIcon.ICON_female_gender
                                                : SearchCtl.instance.gender == 2
                                                    ? PngIcon.ICON_male_gender
                                                    : PngIcon.ICON_all_gender),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    SearchCtl.instance.gender == 99
                                        ? 'Random'.tr()
                                        : SearchCtl.instance.gender == 1 ||
                                                SearchCtl.instance.gender == 2
                                            ? LoginCtl.instance.user.gender ==
                                                    SearchCtl.instance.gender
                                                ? 'SameGender'.tr()
                                                : 'OppositeGender'.tr()
                                            : 'All'.tr(),
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
                  Divider(
                    height: 24,
                    color: white,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            SearchCtl.instance.food = !SearchCtl.instance.food;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white,
                                  border: Border.all(
                                      color: SearchCtl.instance.food
                                          ? yellow
                                          : white,
                                      width: 3)),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25.5, horizontal: 36.5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(PngIcon.ICON_food),
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
                            SearchCtl.instance.amity =
                                !SearchCtl.instance.amity;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white,
                                  border: Border.all(
                                      color: SearchCtl.instance.amity
                                          ? yellow
                                          : white,
                                      width: 3)),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25.5, horizontal: 36.5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(PngIcon.ICON_amity),
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
                            SearchCtl.instance.art = !SearchCtl.instance.art;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white,
                                  border: Border.all(
                                      color: SearchCtl.instance.art
                                          ? yellow
                                          : white,
                                      width: 3)),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25.5, horizontal: 36.5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(PngIcon.ICON_art),
                                  ),
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
                            SearchCtl.instance.exercise =
                                SearchCtl.instance.exercise ? false : true;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white,
                                  border: Border.all(
                                      color: SearchCtl.instance.exercise
                                          ? yellow
                                          : white,
                                      width: 3)),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25.5, horizontal: 36.5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(PngIcon.ICON_exercise),
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
            InkWell(
              onTap: () async {
                Navigator.pushNamed(
                  context,
                  NAV_SearchListPage,
                );
              },
              child: Container(
                  margin: EdgeInsets.only(right: 16, left: 16, bottom: 76),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16), color: yellow),
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.5),
                  child: Text(
                    'start'.tr(),
                    style: TextStyle(
                        fontSize: 16,
                        height: 19.09 / 16,
                        fontWeight: FontWeight.w700,
                        color: black),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
