import 'package:rayo/utils/import_index.dart';

class LoginMailPage extends StatelessWidget {
  final bool modify;
  const LoginMailPage({required this.modify, super.key});

  @override
  Widget build(context) {
    TextEditingController mailInput = TextEditingController();
    return GestureDetector(
      onTap: () async {
        await SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Scaffold(
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
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StatefulBuilder(
              builder: (_, setState) => ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  Container(
                      width: double.infinity,
                      height: 66,
                      padding: const EdgeInsets.only(top: 3, bottom: 21),
                      child: Row(children: [
                        Text('email'.tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                height: 24 / 20,
                                color: black)),
                        const Spacer(),
                        ValueListenableBuilder<bool>(
                          valueListenable: LoginCtl.instance.loadingVal,
                          builder: (context, loading, child) => loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                  ),
                                )
                              : InkWell(
                                  onTap: mailInput.value.text != '' &&
                                          REG_mail.hasMatch(
                                              mailInput.value.text) &&
                                          LoginCtl.instance.errorVal == ''
                                      ? () async {
                                          await LoginCtl.instance.mailAuth(
                                              context: context,
                                              mail: mailInput.value.text,
                                              retry: false,
                                              modify: modify);
                                        }
                                      : null,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'confirm'.tr(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        height: 16.71 / 14,
                                        color: mailInput.value.text != '' &&
                                                REG_mail.hasMatch(
                                                    mailInput.value.text) &&
                                                LoginCtl.instance.errorVal == ''
                                            ? yellow
                                            : black[60],
                                      ),
                                    ),
                                  ),
                                ),
                        )
                      ])),
                  const SizedBox(
                    height: 14,
                  ),
                  Container(
                      padding: const EdgeInsets.all(16),
                      height: 58,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: white[90]),
                      child: SizedBox(
                        height: 28,
                        child: Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autofocus: true,
                              onChanged: (_) {
                                LoginCtl.instance.errorVal = '';
                                setState(() {});
                              },
                              controller: mailInput,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    REG_mailInput),
                              ],
                              decoration: InputDecoration.collapsed(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 22,
                                    height: 26.25 / 22,
                                    fontWeight: FontWeight.w400,
                                    color: black[40]),
                                hintText: 'user@email.com',
                              ),
                              style: const TextStyle(
                                  fontSize: 22,
                                  height: 26.25 / 22,
                                  fontWeight: FontWeight.w400,
                                  color: black),
                            )),
                            const SizedBox(
                              width: 11,
                            ),
                            InkWell(
                              onTap: () {
                                LoginCtl.instance.errorVal = '';
                                mailInput.clear();
                                setState(() {});
                              },
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    SvgPicture.asset(SvgIcon.ICON_closeCircle),
                              ),
                            )
                          ],
                        ),
                      )),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.bottomCenter,
                          width: 12,
                          height: 15,
                          child: SvgPicture.asset(
                            SvgIcon.ICON_bang,
                            width: 12,
                            height: 12,
                            theme: SvgTheme(currentColor: mint[2]!),
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          'phonecontent1'.tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              height: 18 / 12,
                              color: mint[2]),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
