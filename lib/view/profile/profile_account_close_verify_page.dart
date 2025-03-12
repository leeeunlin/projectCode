import 'package:rayo/utils/import_index.dart';

class ProfileAccountCloseVerifyPage extends StatefulWidget {
  const ProfileAccountCloseVerifyPage({super.key});

  @override
  State<ProfileAccountCloseVerifyPage> createState() =>
      _ProfileAccountCloseVerifyPage();
}

class _ProfileAccountCloseVerifyPage
    extends State<ProfileAccountCloseVerifyPage> with WidgetsBindingObserver {
  int check = 99;
  TextEditingController etcText = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool etcFocus = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = View.of(context).viewInsets.bottom;
    etcFocus = bottomInset > 0.0;
    setState(() {});
  }

  @override
  Widget build(context) {
    InkWell accountDetail({required int idx}) {
      return InkWell(
        onTap: () {
          if (idx == 0) {
            _focusNode.requestFocus();
          }
          if (idx != check) {
            etcText.clear();
          }
          check = idx;
          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: check == idx ? mint : black[40]),
                  ),
                  if (check == idx)
                    Container(
                      width: 8,
                      height: 8,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: white),
                    ),
                ],
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  idx == 1
                      ? 'noMeetups'.tr()
                      : idx == 2
                          ? 'noMeetupsNear'.tr()
                          : idx == 3
                              ? 'lacksFeatures'.tr()
                              : idx == 4
                                  ? 'rudeUsers'.tr()
                                  : idx == 5
                                      ? 'disappointedPolicies'.tr()
                                      : 'other'.tr(),
                  style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 16.71 / 14),
                ),
              )
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () async =>
          await SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: white,
        appBar: AppBar(
          title: Text('deleteAccount'.tr()),
          backgroundColor: white,
          leading: BackBtn(
              color: black,
              func: () async {
                Navigator.pop(context);
              }),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'leavingReason'.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 19 / 16,
                      color: black),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 1; i <= 5; i++) accountDetail(idx: i),
                    accountDetail(idx: 0),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: white[90]),
                      padding: const EdgeInsets.all(16),
                      constraints: BoxConstraints(
                          minHeight: 50,
                          // maxHeight: 40,
                          minWidth: double.infinity),
                      child: TextFormField(
                        readOnly: check != 0,
                        focusNode: _focusNode,
                        controller: etcText,
                        maxLines: null,
                        decoration: InputDecoration.collapsed(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 12,
                              height: 18 / 12,
                              fontWeight: FontWeight.w500,
                              color: black),
                          hintText: '',
                        ),
                        style: const TextStyle(
                            fontSize: 12,
                            height: 18 / 12,
                            fontWeight: FontWeight.w500,
                            color: black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () => Navigator.popUntil(
                      context, ModalRoute.withName(NAV_ProfileSettingPage)),
                  child: Text('doItLater'.tr(),
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: mint[2],
                          color: mint[2],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 16 / 14))),
              SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  if (check != 99) {
                    LoginCtl.instance
                        .accountClose(idx: check, detail: etcText.text);
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: check != 99 ? yellow : white[80]),
                    width: double.infinity,
                    padding: const EdgeInsets.all(15.5),
                    child: Text(
                      'deleteAccount'.tr(),
                      style: TextStyle(
                          fontSize: 16,
                          height: 19.09 / 16,
                          fontWeight: FontWeight.w700,
                          color: black),
                    )),
              ),
              SizedBox(height: etcFocus ? 16 : 16 + AppState.systemBarHeight)
            ],
          ),
        ),
      ),
    );
  }
}
