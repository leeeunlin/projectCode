import 'package:rayo/utils/import_index.dart';

class ReportPage extends StatefulWidget {
  final UserModel userModel;
  const ReportPage({required this.userModel, super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int check = 1;
  bool loading = false;
  int options = 0;
  final FocusNode _focusNode = FocusNode();
  TextEditingController etcText = TextEditingController();
  @override
  Widget build(context) {
    InkWell reportReason({required int idx}) {
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
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: white),
                        ),
                    ],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      idx == 1
                          ? 'copyrightinfringement'.tr()
                          : idx == 2
                              ? 'illegalposts'.tr()
                              : idx == 3
                                  ? 'violent,dangerous,orhatefulposts'.tr()
                                  : idx == 4
                                      ? 'explicitposts'.tr()
                                      : idx == 5
                                          ? 'overlypromotionalposts'.tr()
                                          : idx == 6
                                              ? 'potentialfraudorspam'.tr()
                                              : idx == 7
                                                  ? 'impersonatingsomeone'.tr()
                                                  : idx == 8
                                                      ? '14yearsold'.tr()
                                                      : 'other'.tr(),
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 16.71 / 14),
                    ),
                  )
                ],
              )));
    }

    InkWell reportOptions({required int idx}) {
      return InkWell(
          onTap: () {
            options = idx;
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
                            color: options == idx ? mint : black[40]),
                      ),
                      if (options == idx)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: white),
                        ),
                    ],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      idx == 0
                          ? 'hidethispostorchatroom'.tr()
                          : 'hidethispostAllchatroomName'
                              .tr(namedArgs: {'name': widget.userModel.name}),
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 16.71 / 14),
                    ),
                  )
                ],
              )));
    }

    return GestureDetector(
      onTap: () async =>
          await SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            title: Text('report'.tr()),
            backgroundColor: white,
            leading: BackBtn(
                color: black,
                func: () async {
                  Navigator.pop(context);
                }),
            actions: [
              Container(
                margin: EdgeInsets.all(16),
                child: loading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                    : InkWell(
                        onTap: () async {
                          if (check == 0 && etcText.text.isEmpty) {
                            return;
                          }
                          loading = true;
                          setState(() {});
                          await Future.delayed(Duration(seconds: 1));
                          loading = false;
                          setState(() {});
                          if (context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: Text(
                          'complete'.tr(),
                          style: TextStyle(
                              color: check == 0 && etcText.text.isEmpty
                                  ? black[60]
                                  : mint,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              height: 17 / 14),
                        ),
                      ),
              ),
            ],
          ),
          body: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              // TODO :: 번역 필요
                              '신고 사유 선택',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: black,
                                fontSize: 16,
                                height: 19 / 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          for (int i = 1; i < 9; i++) reportReason(idx: i),
                          reportReason(idx: 0),
                          if (check == 0)
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white[90]),
                              padding: const EdgeInsets.all(16),
                              margin: EdgeInsets.only(bottom: 19),
                              constraints: BoxConstraints(
                                  minHeight: 50,
                                  // maxHeight: 40,
                                  minWidth: double.infinity),
                              child: TextFormField(
                                focusNode: _focusNode,
                                controller: etcText,
                                maxLines: 3,
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
                                onChanged: (value) => setState(() {}),
                              ),
                            ),
                        ],
                      )),
                  Divider(
                    color: black[40],
                    thickness: 0.25,
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                'selectanoption'.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: black,
                                  fontSize: 16,
                                  height: 19 / 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            for (int i = 0; i < 2; i++) reportOptions(idx: i),
                          ]))
                ],
              )))),
    );
  }
}
