import 'package:rayo/utils/import_index.dart';

class ProfileModifyPage extends StatefulWidget {
  const ProfileModifyPage({super.key});

  @override
  State<ProfileModifyPage> createState() => _ProfileModifyPage();
}

class _ProfileModifyPage extends State<ProfileModifyPage> {
  TextEditingController nameInput =
      TextEditingController(text: LoginCtl.instance.user.name);
  bool nameFocus = false;
  TextEditingController introduceInput =
      TextEditingController(text: LoginCtl.instance.user.introduce);
  bool introFocus = false;
  List<int> tmpProfileImg = <int>[];
  bool loadingVal = false;
  String profileImg = '';
  bool error = false;
  @override
  void initState() {
    super.initState();
    profileImg = LoginCtl.instance.user.profileImg;
  }

  @override
  Widget build(context) {
    void profileUpload(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              titlePadding: EdgeInsets.zero,
              title: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      tmpProfileImg = await profileImgSelectPage(context);
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      child: Text(
                        'uploadProfilePicture'.tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 19.2 / 16),
                      ),
                    ),
                  ),
                  Divider(
                    height: 0.25,
                    color: black[40],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      profileImg = '';
                      tmpProfileImg.clear();
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'deleteCurrentPicture'.tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 19.2 / 16),
                      ),
                    ),
                  ),
                ],
              )));
    }

    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            backgroundColor: yellow,
            title: Text('editProfile'.tr()),
            shape: const Border(
              bottom: BorderSide(color: yellow, width: 0.25),
            ),
            leading: loadingVal
                ? SizedBox()
                : BackBtn(
                    func: () async {
                      Navigator.pop(context);
                    },
                  ),
            actions: [
              InkWell(
                onTap: () async {
                  if (nameInput.value.text == '' ||
                      nameInput.value.text.length < 2) {
                    setState(() {
                      error = true;
                      loadingVal = false;
                    });
                  } else {
                    Map<String, dynamic> setData = {};
                    List<MultipartFile> imageDataList = [];
                    setState(() {
                      loadingVal = true;
                    });
                    if (LoginCtl.instance.user.name != nameInput.text) {
                      setData[DB_name] = nameInput.text;
                    }
                    // 소개 변경
                    if (LoginCtl.instance.user.introduce !=
                        introduceInput.text) {
                      setData[DB_introduce] = introduceInput.text;
                    }
                    // 프로필 이미지 변경
                    if (tmpProfileImg.isNotEmpty) {
                      imageDataList =
                          await convertMultipartFiles([tmpProfileImg]);
                    }
                    if (profileImg == '' && tmpProfileImg.isEmpty) {
                      setData[DB_profileImg] = '';
                    }
                    if (setData.isNotEmpty || tmpProfileImg.isNotEmpty) {
                      final Map<String, dynamic> resbody = await API.put(
                          uri: URI_userme,
                          data: jsonEncode(setData),
                          imageDataList: imageDataList);
                      if (resbody[statusCode] == 200) {
                        LoginCtl.instance.user =
                            UserModel.fromJson(resbody[data]);

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } else if (resbody[statusCode] == 422) {
                        setState(() {
                          error = true;
                          loadingVal = false;
                        });
                      }
                    } else {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: loadingVal
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: yellow,
                            color: black,
                            strokeWidth: 4,
                          ),
                        )
                      : Text(
                          'save'.tr(),
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              height: 16.71 / 14),
                        ),
                ),
              ),
            ],
          ),
          body: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
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
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          top: 10, right: 16, bottom: 24, left: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 32),
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
                            onTap: () {
                              profileUpload(context);
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: profileImg != ''
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  '$cdnUri$profileImg'),
                                              fit: BoxFit.cover)
                                          : tmpProfileImg.isNotEmpty
                                              ? DecorationImage(
                                                  image: MemoryImage(
                                                      tmpProfileImg
                                                          as Uint8List),
                                                )
                                              : null),
                                  child: profileImg != ''
                                      ? null
                                      : tmpProfileImg.isEmpty
                                          ? SvgPicture.asset(
                                              SvgIcon.ICON_bottomProfile,
                                              theme: SvgTheme(
                                                  currentColor: black[20]!),
                                            )
                                          : null,
                                ),
                                SvgPicture.asset(
                                  SvgIcon.ICON_selectImage,
                                  width: 28,
                                  height: 28,
                                )
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
                                      color: error
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
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              height: 18 / 18,
                                              color: black),
                                          decoration: InputDecoration.collapsed(
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontSize: 18,
                                                height: 18 / 18,
                                                fontWeight: FontWeight.w600,
                                                color: black[40]),
                                            hintText: 'enterName'.tr(),
                                          ).copyWith(
                                            counterText: '',
                                          ),
                                          onChanged: (value) => setState(() {
                                            error = false;
                                          }),
                                        ),
                                      ),
                                    ),
                                    if (nameFocus)
                                      InkWell(
                                        onTap: () {
                                          nameInput.clear();
                                          error = false;
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
                      ))
                ],
              )
            ],
          )),
    );
  }
}
