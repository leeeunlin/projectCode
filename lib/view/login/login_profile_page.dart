import 'package:rayo/utils/import_index.dart';

class LoginProfilePage extends StatefulWidget {
  const LoginProfilePage({super.key});

  @override
  State<LoginProfilePage> createState() => _LoginProfilePageState();
}

class _LoginProfilePageState extends State<LoginProfilePage> {
  TextEditingController nameInput = TextEditingController();
  bool nameFocus = false;
  TextEditingController introduceInput = TextEditingController();
  bool introFocus = false;
  List<int> tmpProfileImg = <int>[];
  bool loadingVal = false;
  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            backgroundColor: yellow,
            shape: const Border(
              bottom: BorderSide(color: yellow, width: 0.25),
            ),
            leading: BackBtn(
              color: white,
              func: () async {
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                color: yellow,
                child: Text(
                  'completeProfile'.tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      height: 40 / 30,
                      color: white),
                ),
              ),
              Container(
                height: 44,
                width: double.infinity,
                color: yellow,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 666,
                      width: 654,
                      color: yellow,
                    ),
                  ),
                  Positioned(
                    top: 75,
                    child: Container(
                      height: 666,
                      width: 654,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: white),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                          top: 0, right: 16, bottom: 21, left: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 32),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: black[40]!,
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ]),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              tmpProfileImg =
                                  await profileImgSelectPage(context);
                              setState(() {});
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: tmpProfileImg.isNotEmpty
                                          ? DecorationImage(
                                              image: MemoryImage(
                                                  tmpProfileImg as Uint8List),
                                            )
                                          : null),
                                  child: tmpProfileImg.isEmpty
                                      ? SvgPicture.asset(
                                          SvgIcon.ICON_bottomProfile,
                                          theme: SvgTheme(
                                              currentColor: black[20]!),
                                        )
                                      : null,
                                ),
                                SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: SvgPicture.asset(
                                        SvgIcon.ICON_selectImage))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: LoginCtl.instance.errorVal != ''
                                          ? red
                                          : nameFocus
                                              ? yellow
                                              : black[40]!,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IntrinsicWidth(
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5),
                                        child: Focus(
                                          onFocusChange: (value) {
                                            nameFocus = value;
                                            setState(() {});
                                          },
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            autofocus: false,
                                            controller: nameInput,
                                            maxLength: 10,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                height: 18 / 18,
                                                color: LoginCtl.instance
                                                            .errorVal !=
                                                        ''
                                                    ? red
                                                    : black),
                                            decoration:
                                                InputDecoration.collapsed(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  fontSize: 18,
                                                  height: 18 / 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: black[40],
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              hintText: 'enterName'.tr(),
                                            ).copyWith(
                                              counterText: '',
                                            ),
                                            onChanged: (_) {
                                              LoginCtl.instance.errorVal = '';
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (nameFocus)
                                      InkWell(
                                        onTap: () {
                                          nameInput.clear();
                                          LoginCtl.instance.errorVal = '';
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 16),
                                          width: 17,
                                          height: 17,
                                          child: SvgPicture.asset(
                                              SvgIcon.ICON_closeCircle),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              Text(
                                '2-10'.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  height: 20 / 10,
                                  color: black,
                                ),
                              )
                            ],
                          ),
                          // if (LoginCtl.instance.errorVal != '')
                          //   SizedBox(
                          //       height: 30,
                          //       child: Text(
                          //         LoginCtl.instance.errorVal,
                          //         style: const TextStyle(
                          //             fontWeight: FontWeight.w500,
                          //             fontSize: 12,
                          //             height: 18 / 12,
                          //             color: red),
                          //       )),
                          const SizedBox(
                            height: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  width: 297,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: introFocus ? yellow : black[40]!,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        width: 25,
                                        height: 17,
                                      ),
                                      Expanded(
                                        child: Focus(
                                          onFocusChange: (value) {
                                            introFocus = value;
                                            setState(() {});
                                          },
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            maxLines: null,
                                            autofocus: false,
                                            controller: introduceInput,
                                            maxLength: 60,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                height: 21 / 14,
                                                color: black),
                                            decoration:
                                                InputDecoration.collapsed(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  fontSize: 18,
                                                  height: 18 / 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: black[40]),
                                              hintText:
                                                  'enterIntroduction'.tr(),
                                            ).copyWith(
                                              counterText: '',
                                            ),
                                            onChanged: (value) =>
                                                setState(() {}),
                                            inputFormatters: [
                                              TextInputFormatter.withFunction(
                                                  (oldValue, newValue) {
                                                int newLines = newValue.text
                                                    .split('\n')
                                                    .length;
                                                if (newLines > 3) {
                                                  return oldValue;
                                                } else {
                                                  return newValue;
                                                }
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          introduceInput.clear();
                                          setState(() {});
                                        },
                                        child: SizedBox(
                                            width: 17,
                                            height: 17,
                                            child: introFocus
                                                ? SvgPicture.asset(
                                                    SvgIcon.ICON_closeCircle)
                                                : null),
                                      ),
                                    ],
                                  )),
                              RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      height: 20 / 10,
                                      color: black[60],
                                    ),
                                    children: [
                                      TextSpan(
                                          text:
                                              '(${introduceInput.value.text.characters.length}',
                                          style: const TextStyle(color: black)),
                                      const TextSpan(text: '/60)')
                                    ]),
                              ),
                            ],
                          )
                        ],
                      )),
                ],
              ),
              Container(
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  color: white,
                  child: InkWell(
                    onTap: LoginCtl.instance.errorVal == '' &&
                            nameInput.value.text.characters.length >= 2
                        ? () async {
                            LoginCtl.instance.user.name = nameInput.value.text;
                            LoginCtl.instance.user.introduce =
                                introduceInput.value.text;
                            loadingVal = true;
                            await LoginCtl.instance
                                .createAuth(context, profileImg: tmpProfileImg);
                            loadingVal = false;
                            setState(() {});
                          }
                        : null,
                    child: Container(
                      margin: const EdgeInsets.all(23),
                      child: loadingVal
                          ? const CircularProgressIndicator()
                          : SvgPicture.asset(
                              SvgIcon.ICON_arrowNext,
                              colorFilter: ColorFilter.mode(
                                LoginCtl.instance.errorVal == '' &&
                                        nameInput
                                                .value.text.characters.length >=
                                            2
                                    ? yellow
                                    : black[60]!,
                                BlendMode.srcIn,
                              ),
                            ),
                    ),
                  )),
            ],
          )),
    );
  }
}
