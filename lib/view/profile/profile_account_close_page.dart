import 'package:rayo/utils/import_index.dart';

class ProfileAccountClosePage extends StatelessWidget {
  const ProfileAccountClosePage({super.key});

  @override
  Widget build(context) {
    ValueNotifier<bool> check = ValueNotifier<bool>(false);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text('deleteAccount'.tr()),
        backgroundColor: white,
        leading: BackBtn(
            color: black,
            func: () async {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'leavingRAYO'.tr(),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 19 / 16,
                    color: black),
              ),
              SizedBox(
                height: 34,
              ),
              EasyRichText(
                'deletedData'.tr(),
                textAlign: TextAlign.start,
                defaultStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 21 / 14,
                    color: black),
                patternList: [
                  EasyRichTextPattern(
                      targetString: 'deletedDataNotRecovered'.tr(),
                      style: const TextStyle(color: red))
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<bool>(
                  valueListenable: check,
                  builder: (context, val, child) => Column(
                        children: [
                          InkWell(
                              onTap: () => check.value = !check.value,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: val ? mint : black[40]!,
                                              width: 2)),
                                      child: val
                                          ? SvgPicture.asset(
                                              SvgIcon.ICON_mintCheck)
                                          : null),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text('reviewedGuidelines'.tr(),
                                        style: TextStyle(
                                            color: black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            height: 16 / 14)),
                                  )
                                ],
                              )),
                          SizedBox(height: 12),
                          InkWell(
                            onTap: () async {
                              if (val) {
                                Navigator.pushNamed(
                                    context, NAV_ProfileAccountCloseVerifyPage);
                              }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: val ? yellow : white[80]),
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
                      )),
              SizedBox(height: 16 + AppState.systemBarHeight)
            ],
          )),
    );
  }
}
