import 'package:rayo/utils/import_index.dart';

class RecruitNamePage extends StatefulWidget {
  final RoomModel roomModel;
  const RecruitNamePage({required this.roomModel, super.key});

  @override
  State<RecruitNamePage> createState() => _RecruitNamePageState();
}

class _RecruitNamePageState extends State<RecruitNamePage> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    widget.roomModel.name = '';
  }

  @override
  Widget build(context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            backgroundColor: black[80],
            appBar: AppBar(
              backgroundColor: black[80],
              shape: Border(bottom: BorderSide(color: black[80]!)),
              automaticallyImplyLeading: false,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: white),
                    child: BackBtn(func: () async {
                      Navigator.pop(context);
                    }),
                  ),
                  Spacer(),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: black[120]),
                      child: Container(
                          width: 36,
                          height: 36,
                          margin: EdgeInsets.all(8),
                          child: CloudWidget())),
                ],
              ),
            ),
            body: SafeArea(
                child: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'EnterRoomTitle'.tr(),
                      style: TextStyle(
                          fontSize: 16,
                          height: 19.2 / 16,
                          fontWeight: FontWeight.w600,
                          color: white),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: white[180],
                        // color: mint,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        maxLength: 15,
                        autofocus: true,
                        controller: _textEditingController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(REG_firstBlank),
                        ],
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 19 / 16,
                            color: black),
                        decoration: InputDecoration.collapsed(
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 19 / 16,
                              color: black[80]),
                          hintText: 'e.gTitle'.tr(),
                        ).copyWith(
                          counterText: '',
                        ),
                        onChanged: (value) => setState(() {
                          widget.roomModel.name = value;
                        }),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('(${_textEditingController.text.length}/15)',
                          style: TextStyle(
                              fontSize: 10,
                              height: 20 / 10,
                              color: white,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  Spacer(),
                  if (_textEditingController.text.isNotEmpty)
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, NAV_RecruitDateLocalePage,
                            arguments: {
                              'roomModel': widget.roomModel,
                            });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: yellow),
                          width: double.infinity,
                          padding: const EdgeInsets.all(15.5),
                          child: Text(
                            'next'.tr(),
                            style: TextStyle(
                                fontSize: 16,
                                height: 19.09 / 16,
                                fontWeight: FontWeight.w700,
                                color: black),
                          )),
                    )
                ],
              ),
            ))),
      );
}
