import 'package:rayo/utils/import_index.dart';

class LoginMailVerifyPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const LoginMailVerifyPage({required this.args, super.key});

  @override
  State<LoginMailVerifyPage> createState() => _LoginMailVerifyPage();
}

class _LoginMailVerifyPage extends State<LoginMailVerifyPage>
    with SingleTickerProviderStateMixin {
  TextEditingController verifycode = TextEditingController();
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    // 이메일 인증 제한시간 없음 차후 이메일 인증 제한 필요할 경우 하단 UI부분 주석 체크 후 해제 필요
    // 이메일 인증은 15초 마다 재발송 가능하도록 설정
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..forward();
    LoginCtl.instance.timerStart(time: 15);
  }

  @override
  void dispose() {
    _animationController.dispose();
    LoginCtl.instance.timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(context) {
    String mail = widget.args['mail'] ?? '';
    bool modify = widget.args['modify'] ?? false;

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
                                        onTap: verifycode.value.text.length ==
                                                    6 &&
                                                LoginCtl.instance.errorVal == ''
                                            ? () async {
                                                await LoginCtl.instance
                                                    .mailSignIn(
                                                        context: context,
                                                        mail: mail,
                                                        verifycode: verifycode
                                                            .value.text,
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
                                                  verifycode.value.text.length ==
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
                            modify
                                ? '$mail\n${'entercode'.tr()}'
                                : 'entercode'.tr(),
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
                            controller: verifycode,
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
                              FilteringTextInputFormatter.allow(REG_number),
                            ],
                            onTap: () async {
                              if (!loading) {
                                LoginCtl.instance.errorVal = '';
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                verifycode.clear();
                              }
                            },
                            onChanged: (value) {
                              LoginCtl.instance.errorVal = '';
                              setState(() {});
                            },
                            onCompleted: (value) async {
                              if (LoginCtl.instance.errorVal == '') {
                                await LoginCtl.instance.mailSignIn(
                                    context: context,
                                    mail: mail,
                                    verifycode: verifycode.value.text,
                                    modify: modify);
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
                          ),
                        ),
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
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) =>
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      10, // widget size를 강제로 맞춘 부분이라 overflow발생여지 있음
                                  backgroundColor: Colors.transparent,
                                  value: _animationController.value,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: expireTime == 0
                                  ? () async {
                                      await LoginCtl.instance.mailAuth(
                                          context: context,
                                          mail: mail,
                                          retry: true,
                                          modify: modify);
                                      verifycode.clear();
                                      LoginCtl.instance.timer!.cancel();
                                      LoginCtl.instance.timerStart(time: 15);
                                      _animationController.reset();
                                      _animationController.forward();
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
                                          expireTime == 0 ? yellow : black[80],
                                      color:
                                          expireTime == 0 ? yellow : black[80],
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    )),
          ))),
    );
  }
}
