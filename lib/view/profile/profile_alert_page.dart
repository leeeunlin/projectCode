import 'package:rayo/utils/import_index.dart';

class ProfileAlertPage extends StatefulWidget {
  const ProfileAlertPage({super.key});

  @override
  State<ProfileAlertPage> createState() => _ProfileAlertPage();
}

class _ProfileAlertPage extends State<ProfileAlertPage> {
  @override
  Widget build(context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: Text('notificationSettings'.tr()),
          leading: BackBtn(
              color: black,
              func: () async {
                Navigator.pop(context);
              }),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        // width: MediaQuery.of(context).size.width * 0.75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'deviceNoti'.tr(),
                              style: TextStyle(
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  height: 19 / 16),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'rayoNoti'.tr(),
                              style: TextStyle(
                                  color: black[80],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  height: 18 / 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    CupertinoSwitch(
                        activeTrackColor: mint,
                        value: LoginCtl.instance.user.alertSetting.deviceAlert,
                        onChanged: (value) async {
                          LoginCtl.instance.user.alertSetting.deviceAlert =
                              value;
                          await API.put(
                              uri: URI_userme,
                              data: jsonEncode({
                                DB_alertSetting:
                                    LoginCtl.instance.user.alertSetting
                              }));
                          setState(() {});
                        })
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'marketing'.tr(),
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                height: 19 / 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'benefitAlert'.tr(),
                            style: TextStyle(
                                color: black[80],
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 18 / 12),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'personalOffer'.tr(),
                            style: TextStyle(
                                color: black[80],
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 18 / 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    CupertinoSwitch(
                        activeTrackColor: mint,
                        value:
                            LoginCtl.instance.user.alertSetting.marketingAlert,
                        onChanged: (value) async {
                          if (value) {
                            await marketingAgree(context);
                            LoginCtl.instance.user.alertSetting.marketingAlert =
                                value;
                            await API.put(
                                uri: URI_userme,
                                data: jsonEncode({
                                  DB_alertSetting:
                                      LoginCtl.instance.user.alertSetting
                                }));
                          } else {
                            await marketingDisagree(context).then((val) async {
                              if (!val) {
                                if (context.mounted) {
                                  await disagreeVerify(context);
                                }
                                LoginCtl.instance.user.alertSetting
                                    .marketingAlert = val;
                                await API.put(
                                    uri: URI_userme,
                                    data: jsonEncode({
                                      DB_alertSetting:
                                          LoginCtl.instance.user.alertSetting
                                    }));
                              }
                            });
                          }
                          setState(() {});
                        })
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

Future<void> marketingAgree(BuildContext context) async => await showDialog(
    context: context,
    builder: (context) => AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 34, vertical: 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'agreedReceiveMarketing'.tr(),
                        style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 30 / 16),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        'datetimeAgreeNotify'.tr(namedArgs: {
                          'dateTime': DateFormat.yMMMd(
                                  Localizations.localeOf(context).toString())
                              .format(DateTime.now())
                        }),
                        style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            height: 18 / 12),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0.25,
                  color: black[40],
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 67,
                      child: Text(
                        'confirm'.tr(),
                        style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 19 / 16),
                      ),
                    ))
              ],
            ),
          ),
        ));

Future<bool> marketingDisagree(BuildContext context) async {
  bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            title: SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 34, vertical: 22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          'missOutImportantUpdates'.tr(),
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 30 / 16),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          'offNotificationsInfo'.tr(),
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              height: 18 / 12),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0.25,
                    color: black[40],
                  ),
                  SizedBox(
                    height: 67,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context, true);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: AutoSizeText(
                                  maxLines: 2,
                                  minFontSize: 1,
                                  textAlign: TextAlign.center,
                                  'keepReceivingBenefits'.tr(),
                                  style: TextStyle(
                                      color: mint[2],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      height: 19 / 16),
                                ),
                              )),
                        ),
                        VerticalDivider(
                          width: 0.25,
                          color: black[40],
                        ),
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context, false);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: AutoSizeText(
                                  maxLines: 2,
                                  minFontSize: 1,
                                  textAlign: TextAlign.center,
                                  'turnOffNotifications'.tr(),
                                  style: TextStyle(
                                      color: black[60],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      height: 19 / 16),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
  return result ?? true;
}

Future<void> disagreeVerify(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          title: SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 34, vertical: 22),
                      child: Text(
                        textAlign: TextAlign.center,
                        'datetimeDisagreeNotify'.tr(namedArgs: {
                          'dateTime': DateFormat.yMMMd(
                                  Localizations.localeOf(context).toString())
                              .format(DateTime.now())
                        }),
                        style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 24 / 16),
                      )),
                  Divider(
                    height: 0.25,
                    color: black[40],
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 67,
                        child: Text(
                          'confirm'.tr(),
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 19 / 16),
                        ),
                      ))
                ],
              ))));
}
