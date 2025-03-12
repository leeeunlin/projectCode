import 'package:rayo/utils/import_index.dart';

class LoginTermsPage extends StatefulWidget {
  const LoginTermsPage({super.key});

  @override
  State<LoginTermsPage> createState() => _LoginTermsPage();
}

class _LoginTermsPage extends State<LoginTermsPage> {
  Map<String, dynamic> agree = Agreement.fromJson({}).toJson();
  @override
  Widget build(BuildContext context) {
    InkWell agreeWidget(
        {required String txt, required String type, String url = ''}) {
      TextStyle txtStyle = const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 19.2 / 16,
        color: black,
      );
      return InkWell(
        onTap: () {
          if (agree[type]!) {
            agree[type] = false;
          } else {
            agree[type] = true;
          }
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 23,
                height: 23,
                child: SvgPicture.asset(
                  SvgIcon.ICON_check,
                  colorFilter: ColorFilter.mode(
                    agree[type]! ? yellow : black[40]!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txt,
                      style: txtStyle,
                    ),
                    if (url != '')
                      InkWell(
                          onTap: () {
                            p('url 이동링크 페이지생성후 작업');
                          },
                          child: Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: Text('learnmore'.tr())))
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: white,
            width: 0.25,
          ),
        ),
        leading: BackBtn(
          func: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 3, bottom: 21),
              child: Row(
                children: [
                  Expanded(
                    child: Text('termsagreement'.tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            height: 24 / 20,
                            color: black)),
                  ),
                  InkWell(
                      onTap: agree['age'] &&
                              agree['term'] &&
                              agree['privacy'] &&
                              agree['location']
                          ? () {
                              LoginCtl.instance.user.agreement =
                                  Agreement.fromJson(agree);
                              Navigator.pushNamed(context, NAV_LoginNumberPage);
                            }
                          : null,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Text('confirm'.tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                height: 16.71 / 14,
                                color: agree['age'] &&
                                        agree['term'] &&
                                        agree['privacy'] &&
                                        agree['location']
                                    ? yellow
                                    : black[60])),
                      ))
                ],
              )),
          Container(
              width: double.infinity,
              height: 68,
              padding: const EdgeInsets.all(16),
              color: white[80],
              child: Text('termscontent'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 18 / 12,
                    color: black,
                  ))),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (agree['age'] &&
                          agree['term'] &&
                          agree['privacy'] &&
                          agree['location'] &&
                          agree['marketing']) {
                        agree['age'] = false;
                        agree['term'] = false;
                        agree['privacy'] = false;
                        agree['location'] = false;
                        agree['marketing'] = false;
                      } else {
                        agree['age'] = true;
                        agree['term'] = true;
                        agree['privacy'] = true;
                        agree['location'] = true;
                        agree['marketing'] = true;
                      }

                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: yellow, width: 1),
                          borderRadius: BorderRadius.circular(12)),
                      width: double.infinity,
                      padding: const EdgeInsets.all(17),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 24,
                              height: 24,
                              child: SvgPicture.asset(
                                SvgIcon.ICON_checkCircle,
                                theme: SvgTheme(
                                    currentColor: agree['age'] &&
                                            agree['term'] &&
                                            agree['privacy'] &&
                                            agree['location'] &&
                                            agree['marketing']
                                        ? yellow
                                        : black[40]!),
                              )),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: Text(
                            'termsallagree'.tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 22,
                                height: 26.4 / 22,
                                color: black),
                          ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  agreeWidget(txt: 'termsage'.tr(), type: 'age'),
                  agreeWidget(
                      txt: 'termsuse'.tr(), type: 'term', url: 'https://'),
                  agreeWidget(
                      txt: 'termspersonal'.tr(),
                      type: 'privacy',
                      url: 'https://'),
                  agreeWidget(
                      txt: 'termslocation'.tr(),
                      type: 'location',
                      url: 'https://'),
                  agreeWidget(
                      txt: 'termsmarketing'.tr(),
                      type: 'marketing',
                      url: 'https://'),
                ],
              ))
        ],
      ),
    );
  }
}
