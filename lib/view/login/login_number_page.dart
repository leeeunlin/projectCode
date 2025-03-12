import 'package:rayo/utils/import_index.dart';

class LoginNumberPage extends StatelessWidget {
  final bool modify;
  const LoginNumberPage({required this.modify, super.key});

  @override
  Widget build(context) {
    TextEditingController phoneInput = TextEditingController();
    String myCode = PlatformDispatcher.instance.locale.countryCode!;
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
                      padding: const EdgeInsets.only(top: 3, bottom: 21),
                      child: Row(children: [
                        Expanded(
                          child: Text('phonenumberverify'.tr(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  height: 24 / 20,
                                  color: black)),
                        ),
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
                                  onTap: phoneInput.value.text != ''
                                      ? () async {
                                          await LoginCtl.instance.numberAuth(
                                              context: context,
                                              countryCode:
                                                  countryToNumber[myCode]!,
                                              phoneNum: phoneInput.value.text,
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
                                        color: phoneInput.value.text != '' &&
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
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: white[90]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: 14,
                              child: Text(
                                'phonenumber'.tr(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              )),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 28,
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () async {
                                      String tmp = await countryCodeSelecter(
                                          context,
                                          myCode: myCode);
                                      if (tmp != '') {
                                        LoginCtl.instance.errorVal = '';
                                        myCode = tmp;
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        width: 62,
                                        height: 28,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: black[60]),
                                        child: Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: 31,
                                              height: 20,
                                              child: AutoSizeText(
                                                '${countryToNumber[myCode]}',
                                                minFontSize: 1,
                                                maxFontSize: 17,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    height: 20.29 / 17,
                                                    color: white),
                                              ),
                                            ),
                                            const Spacer(),
                                            SizedBox(
                                              width: 9,
                                              height: 8,
                                              child: SvgPicture.asset(
                                                  SvgIcon.ICON_arrowDropdown),
                                            )
                                          ],
                                        ))),
                                const SizedBox(
                                  width: 11,
                                ),
                                Expanded(
                                    child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  autofocus: true,
                                  onChanged: (_) {
                                    LoginCtl.instance.errorVal = '';
                                    setState(() {});
                                  },
                                  onFieldSubmitted: (value) async => value != ''
                                      ? await LoginCtl.instance.numberAuth(
                                          context: context,
                                          countryCode: countryToNumber[myCode]!,
                                          phoneNum: phoneInput.value.text,
                                          retry: false,
                                          modify: modify)
                                      : null,
                                  controller: phoneInput,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        REG_number),
                                  ],
                                  decoration: InputDecoration.collapsed(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 22,
                                        height: 26.25 / 22,
                                        fontWeight: FontWeight.w400,
                                        color: black[40]),
                                    hintText: 'enterphonenumber'.tr(),
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
                                    phoneInput.clear();
                                    setState(() {});
                                  },
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: SvgPicture.asset(
                                        SvgIcon.ICON_closeCircle),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'phonecontent0'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
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
