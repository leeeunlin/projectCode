import 'package:rayo/utils/import_index.dart';

class LoginNumberVerifyPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const LoginNumberVerifyPage({required this.args, super.key});

  @override
  State<LoginNumberVerifyPage> createState() => _LoginNumberVerifyPage();
}

class _LoginNumberVerifyPage extends State<LoginNumberVerifyPage> {
  TextEditingController smsCode = TextEditingController();
  @override
  void initState() {
    super.initState();
    LoginCtl.instance.timerStart(time: 180);
  }

  @override
  void dispose() {
    LoginCtl.instance.timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(context) {
    String countryCode = widget.args['countryCode'];
    String phoneNum = widget.args['phoneNum'];
    String verificationId = widget.args['verificationId'];
    bool modify = widget.args['modify'];

    // 문자 재발송 타이머 (실제 UI단에서만 사용되는 타이머, 실제 타이머는 183초로 진행됨)

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
            child: ValueListenableBuilder<int>(
                valueListenable: LoginCtl.instance.expireTime,
                builder: (_, expireTime, child) => ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        Container(
                          width: double.infinity,
                          height: 66,
                          padding: const EdgeInsets.only(top: 3, bottom: 21),
                          child: Row(
                            children: [
                              Text(
                                'verifycode'.tr(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    height: 24 / 20,
                                    color: black),
                              ),
                              const Spacer(),
                              ValueListenableBuilder<bool>(
                                valueListenable: LoginCtl.instance.loadingVal,
                                builder: (_, loading, child) => loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 4,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: smsCode.value.text.length == 6 &&
                                                LoginCtl.instance.errorVal ==
                                                    '' &&
                                                expireTime != 0
                                            ? () async {
                                                await LoginCtl.instance
                                                    .numberSignIn(
                                                        context: context,
                                                        verificationId:
                                                            verificationId,
                                                        smsCode:
                                                            smsCode.value.text,
                                                        modify: modify);
                                              }
                                            : null,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            'confirm'.tr(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              height: 16.71 / 14,
                                              color:
                                                  smsCode.value.text.length ==
                                                              6 &&
                                                          LoginCtl.instance
                                                                  .errorVal ==
                                                              '' &&
                                                          expireTime != 0
                                                      ? yellow
                                                      : black[60],
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: yellow, width: 1),
                              color: white),
                          child: Text(
                            '$countryCode $phoneNum\n${'entercode'.tr()}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ValueListenableBuilder<bool>(
                            valueListenable: LoginCtl.instance.loadingVal,
                            builder: (_, loading, child) => PinCodeTextField(
                                  readOnly: loading,
                                  enableActiveFill: true,
                                  enablePinAutofill: false,
                                  appContext: context,
                                  length: 6,
                                  controller: smsCode,
                                  autoDisposeControllers: false,
                                  autoFocus: true,
                                  keyboardType: TextInputType.number,
                                  animationType: AnimationType.none,
                                  showCursor: false,
                                  beforeTextPaste: (_) => false,
                                  textStyle: const TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22,
                                      height: 26.4 / 22),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        REG_number),
                                  ],
                                  onTap: () async {
                                    if (!loading) {
                                      LoginCtl.instance.errorVal = '';
                                      await Future.delayed(
                                          const Duration(milliseconds: 200));
                                      smsCode.clear();
                                    }
                                  },
                                  onChanged: (value) {
                                    LoginCtl.instance.errorVal = '';
                                    setState(() {});
                                  },
                                  onCompleted: (value) async {
                                    if (LoginCtl.instance.errorVal == '' &&
                                        expireTime != 0) {
                                      await LoginCtl.instance.numberSignIn(
                                          context: context,
                                          verificationId: verificationId,
                                          smsCode: smsCode.value.text,
                                          modify: modify);
                                      setState(() {});
                                    }
                                  },
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(12),
                                    fieldHeight: 58,
                                    fieldWidth: 46,
                                    activeBorderWidth: 1,
                                    activeColor: white[90],
                                    activeFillColor: white[90],
                                    selectedBorderWidth: 1,
                                    selectedFillColor: white[90],
                                    selectedColor: black[80],
                                    inactiveFillColor: white[90],
                                    inactiveBorderWidth: 1,
                                    inactiveColor: white[90],
                                  ),
                                )),
                        SizedBox(
                            height: 30,
                            child: Text(
                              LoginCtl.instance.errorVal == ''
                                  ? ''
                                  : LoginCtl.instance.errorVal ==
                                          'invalid-verification-code'
                                      ? 'correctCode'.tr()
                                      : 'tryagain'.tr(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  height: 18 / 12,
                                  color: red),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 45,
                              child: Text(
                                '${(expireTime ~/ 60).toString().padLeft(2, "0")}:${(expireTime % 60).toString().padLeft(2, "0")}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    height: 21 / 14,
                                    color: yellow),
                              ),
                            ),
                            InkWell(
                              onTap: expireTime < 150
                                  ? () async {
                                      await LoginCtl.instance.numberAuth(
                                          context: context,
                                          countryCode: countryCode,
                                          phoneNum: phoneNum,
                                          retry: true,
                                          modify: modify);
                                      smsCode.clear();
                                      LoginCtl.instance.timer!.cancel();
                                    }
                                  : null,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text('resendcode'.tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      height: 21 / 14,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          expireTime < 150 ? yellow : black[80],
                                      color:
                                          expireTime < 150 ? yellow : black[80],
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text('codecontent0'.tr(),
                            style: Theme.of(context).textTheme.bodyMedium)
                      ],
                    )),
          ))),
    );
  }
}
