import 'package:rayo/utils/import_index.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});
  @override
  Widget build(context) {
    // Container shopItem()
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text('상점'),
        leading: BackBtn(func: () async {
          Navigator.pop(context);
        }),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  PngIcon.ICON_shopCloud,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<int>(
                              valueListenable: LoginCtl.instance.user.point,
                              builder: (context, point, child) {
                                return Text(
                                  '${point}c',
                                  style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 40,
                                      height: 48 / 40),
                                );
                              }),
                          SizedBox(
                            height: 4,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: LoginCtl.instance.user.name,
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  height: 27 / 18),
                            ),
                            TextSpan(
                                text: '님의 구름',
                                style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    height: 27 / 18))
                          ]))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 117,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceAround,
                            runSpacing: 20,
                            children: [
                              for (ProductDetails prod
                                  in InAppPurchaseCtl.instance.prods)
                                ShopItemWidget(prod: prod),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      width: 10,
                                      child: Text('·',
                                          style: TextStyle(
                                              color: black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              height: 15 / 10))),
                                  Text('shopNotes1'.tr(),
                                      style: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          height: 15 / 10))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      alignment: Alignment.topCenter,
                                      width: 10,
                                      child: Text('·',
                                          style: TextStyle(
                                              color: black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              height: 15 / 10))),
                                  Expanded(
                                    child: Text(
                                      'shopNotes2'.tr(),
                                      style: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                          height: 15 / 10),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      alignment: Alignment.topCenter,
                                      width: 10,
                                      child: Text('·',
                                          style: TextStyle(
                                              color: black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              height: 15 / 10))),
                                  Expanded(
                                    child: Text(
                                      'shopNotes3'.tr(),
                                      style: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                          height: 15 / 10),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            p('청약철회 규정, 미셩년자 상품구매 안내페이지로 이동');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            width: double.infinity,
                            child: Text(
                              'RightOfWithdrawal'.tr(),
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: black,
                                  color: black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  height: 15 / 10),
                            ),
                          ),
                        ),
                        SizedBox(height: AppState.systemBarHeight),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
