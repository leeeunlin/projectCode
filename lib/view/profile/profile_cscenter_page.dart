import 'package:rayo/utils/import_index.dart';

class ProfileCsCenterPage extends StatelessWidget {
  const ProfileCsCenterPage({super.key});
  @override
  Widget build(context) {
    InkWell csItem(
        {required String title,
        required String subtitle,
        required VoidCallback func}) {
      return InkWell(
        onTap: func,
        child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: black[60]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 21 / 14)),
                Text(subtitle,
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 21 / 14))
              ],
            )),
      );
    }

    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: Text('customerSupport'.tr()),
          leading: BackBtn(
              color: black,
              func: () async {
                Navigator.pop(context);
              }),
        ),
        body: Container(
            margin: EdgeInsets.all(16),
            child: ListView(children: [
              csItem(
                  title: '문의하기 >',
                  subtitle: '간편하게 메일로 답변을 받을 수 있어요',
                  func: () async => await _sendEmail(context)),
              csItem(
                  title: '문제 신고 >',
                  subtitle: '더욱 편리한 라요를 위해 노력하겠습니다.',
                  func: () {}),
            ])));
  }

  Future<void> _sendEmail(BuildContext context) async {
    final Email email = Email(
      body: '- ${'inquiry'.tr()}:\n\n\n\n${'replyguide'.tr()}',
      subject: '',
      recipients: ['help@rayomeet.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      if (context.mounted) {
        mailError(context);
      }
    }
  }

  Future<void> mailError(BuildContext context) async {
    TextStyle txtStyle = const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        height: 18 / 12,
        color: black);
    await showModalBottomSheet(
        context: context,
        builder: (_) => Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: white,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 6,
                  width: 64,
                  decoration: BoxDecoration(
                      color: black[40], borderRadius: BorderRadius.circular(3)),
                ),
                Container(
                    alignment: Alignment.center,
                    height: 70,
                    child: Text(
                      'defaultappnotavailable'.tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 19.09 / 16,
                          color: black),
                    )),
                Divider(
                  height: 0.25,
                  color: black[40],
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'quickresponse'.tr(),
                          style: txtStyle,
                        ),
                        Text(
                          '${'emailsend'.tr()}: help@rayomeet.com',
                          style: txtStyle,
                        ),
                        Text(
                          '${'emailsubject'.tr()} : ${'inquirycontent'.tr()}',
                          style: txtStyle,
                        ),
                        Text(
                          '${'emailcontent0'.tr()} : ${'emailcontent1'.tr()}',
                          style: txtStyle,
                        ),
                      ],
                    ))
              ],
            )));
  }
}
