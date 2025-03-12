import 'package:rayo/utils/import_index.dart';

class LoginProblemPage extends StatelessWidget {
  const LoginProblemPage({super.key});

  @override
  Widget build(context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: Text('loginproblem'.tr()),
          leading: BackBtn(
            func: () async {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'problem0'.tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 19.09 / 16,
                          color: black),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'problem1'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      )),
                  const SizedBox(
                    height: 45,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '1.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Expanded(
                        child: Text(
                          'problem2'.tr(),
                          maxLines: 10,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '2.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Expanded(
                        child: Text(
                          'problem3'.tr(),
                          maxLines: 10,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  RichText(
                    maxLines: 10,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(text: 'problem4'.tr()),
                        TextSpan(
                          text: '[${'clickhere'.tr()}]',
                          style: TextStyle(
                            color: mint[2],
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 21 / 14,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await _sendEmail(context);
                            },
                        ),
                        TextSpan(text: '\n${'problem5'.tr()}'),
                      ],
                    ),
                  ),
                ],
              )),
        ));
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
