import 'package:rayo/utils/import_index.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  @override
  Widget build(context) {
    InkWell settingMenu(
        {bool title = false, required String text, VoidCallback? func}) {
      return InkWell(
        onTap: func,
        child: Container(
          width: double.infinity,
          color: title ? white[80] : white,
          padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: title
                  ? 9
                  : text == '휴대폰 번호' || text == '이메일'
                      ? 18
                      : 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        color: black,
                        fontWeight: title ? FontWeight.w700 : FontWeight.w500,
                        fontSize: title ? 14 : 16,
                        height: title ? 16.71 / 14 : 19.09 / 16),
                  ),
                  if (text == 'phoneNumber'.tr() || text == 'email'.tr())
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                            text == 'phoneNumber'.tr()
                                ? LoginCtl.instance.user.number
                                : LoginCtl.instance.user.mail == ''
                                    ? 'linkEmail'.tr()
                                    : LoginCtl.instance.user.mail,
                            style: TextStyle(
                                color: text == 'phoneNumber'.tr()
                                    ? black[40]
                                    : LoginCtl.instance.user.mail == ''
                                        ? red
                                        : black[40],
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 18 / 12)))
                ],
              ),
              Spacer(),
              if (text == 'myCloud'.tr())
                SizedBox(
                    width: 36,
                    height: 36,
                    child: CloudWidget(
                      color: black[60]!,
                    )),
              if (text == 'currentVersion'.tr())
                Text(
                  LoginCtl.instance.appInfo.version,
                  style: TextStyle(
                      color: black[80],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 16.71 / 14),
                ),
              if (text == 'phoneNumber'.tr() || text == 'email'.tr())
                Text(
                  text == 'phoneNumber'.tr()
                      ? 'change'.tr()
                      : LoginCtl.instance.user.mail == ''
                          ? 'register'.tr()
                          : 'change'.tr(),
                  style: TextStyle(
                      color: mint[2],
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 18 / 16),
                )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text('settings'.tr()),
        backgroundColor: white,
        leading: BackBtn(
            color: black,
            func: () async {
              Navigator.pop(context);
            }),
      ),
      body: ListView(
        children: [
          settingMenu(title: true, text: 'activities'.tr()),
          settingMenu(
              text: 'myCloud'.tr(),
              func: () => Navigator.pushNamed(context, NAV_ShopPage)),
          settingMenu(
              text: 'blockedFriends'.tr(),
              func: () => Navigator.pushNamed(
                  context, NAV_ProfileBlockedHiddenPage,
                  arguments: {'type': 'blocked'})),
          settingMenu(
              // TODO :: 번역 필요
              text: '숨김 친구 관리',
              func: () => Navigator.pushNamed(
                  context, NAV_ProfileBlockedHiddenPage,
                  arguments: {'type': 'hidden'})),
          settingMenu(title: true, text: 'account'.tr()),
          settingMenu(
              text: 'phoneNumber'.tr(),
              func: () => Navigator.pushNamed(context, NAV_LoginNumberPage,
                      arguments: {'modify': true}).then((_) {
                    setState(() {});
                  })),
          settingMenu(
              text: 'email'.tr(),
              func: () => Navigator.pushNamed(context, NAV_LoginMailPage,
                      arguments: {'modify': true}).then((_) {
                    setState(() {});
                  })),
          settingMenu(
              text: 'notificationSettings'.tr(),
              func: () => Navigator.pushNamed(context, NAV_ProfileAlertPage)),
          settingMenu(
              text: 'accountManagement'.tr(),
              func: () => Navigator.pushNamed(
                  context, NAV_ProfileAccountManagementPage)),
          settingMenu(
            title: true,
            text: 'currentVersion'.tr(),
          ),
          settingMenu(
              text: 'customerSupport'.tr(),
              func: () =>
                  Navigator.pushNamed(context, NAV_ProfileCsCenterPage)),
          settingMenu(
              text: 'Rayo',
              func: () =>
                  Navigator.pushNamed(context, NAV_ProfileRayotermPage)),
          settingMenu(
              text: 'logOut'.tr(), func: () => LoginCtl.instance.logOut()),
        ],
      ),
    );
  }
}
