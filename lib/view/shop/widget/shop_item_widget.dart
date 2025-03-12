import 'package:rayo/utils/import_index.dart';

class ShopItemWidget extends StatelessWidget {
  final ProductDetails prod;
  const ShopItemWidget({required this.prod, super.key});

  @override
  Widget build(context) => InkWell(
        onTap: () async {
          if (LoginCtl.instance.user.mail != '') {
            InAppPurchaseCtl.instance.purchaseProduct(prod);
          } else {
            // TODO :: 번역 필요 및 워딩 확인 필요
            snackBar(content: '이메일 등록 후 사용하세요.');
          }
          // if (prod.id == '650') {
          //   InAppPurchaseCtl.instance.test();
          // } else {
          //   InAppPurchaseCtl.instance.test2();
          // }
          // p(prod.price);
          // InAppPurchaseCtl.instance.purchaseProduct(prod);
        },
        child: Container(
            height: 150,
            width: 98,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: blackShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(PngIcon.ICON_purchaseCloud(
                  int.parse(prod.id),
                )),
                Text(
                  '${prod.id}c',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: mint,
                      fontSize: 18,
                      height: 27 / 18),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: white[90],
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    prod.price,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 18 / 12),
                  ),
                ),
              ],
            )),
      );
}
