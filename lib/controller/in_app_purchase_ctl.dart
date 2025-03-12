import 'package:rayo/utils/import_index.dart';

class InAppPurchaseCtl {
  static final InAppPurchaseCtl _instance = InAppPurchaseCtl._internal();
  factory InAppPurchaseCtl() {
    return _instance;
  }
  InAppPurchaseCtl._internal();
  static InAppPurchaseCtl get instance => _instance;
  List<Map<String, dynamic>> purchaseList = [];
  List<ProductDetails> prods = [];
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  bool loadingVal = false;
  BuildContext? purchLoading;
  void init() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (prods) {
        _listenToPurchaseUpdated(prods);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {},
    );
    getPurchaseList();
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> prods) async {
    for (PurchaseDetails prod in prods) {
      switch (prod.status) {
        case PurchaseStatus.pending:
          purchaseLoading(appStateKey.currentState!.currentContext());
          break;
        case PurchaseStatus.error:
          await _completePurchase(prod, prod.status);
          break;
        case PurchaseStatus.canceled:
          await _completePurchase(prod, prod.status);
          break;
        case PurchaseStatus.restored:
          break;
        case PurchaseStatus.purchased:
          await _completePurchase(prod, prod.status);
          break;
        default:
          break;
      }
    }
  }

  Future<void> test() async {
    purchaseLoading(appStateKey.currentState!.currentContext());
    await Future.delayed(Duration(seconds: 2));
    LoginCtl.instance.user.point.value += 650;
    Navigator.pop(InAppPurchaseCtl.instance.purchLoading!);
  }

  Future<void> test2() async {
    purchaseLoading(appStateKey.currentState!.currentContext());
    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(InAppPurchaseCtl.instance.purchLoading!);
    snackBar(content: '구매에 실패했습니다.');
  }

  Future<void> _completePurchase(
      PurchaseDetails prod, PurchaseStatus status) async {
    if (prod.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(prod);
      if (PurchaseStatus.purchased == status) {
        final resbody = await API.post(
            uri: URI_verifyReceipt,
            data: jsonEncode({
              'productId': prod.productID,
              'token': Platform.isAndroid
                  ? jsonDecode(prod.verificationData.localVerificationData)[
                      'purchaseToken']
                  : prod.purchaseID,
              'platform': Platform.isAndroid ? 'aos' : 'ios',
            }));
        if (resbody[statusCode] == 200) {
          LoginCtl.instance.user.point.value = resbody[data]['point'];
          Navigator.pop(InAppPurchaseCtl.instance.purchLoading!);
        } else {
          Navigator.pop(InAppPurchaseCtl.instance.purchLoading!);
          snackBar(content: '구매에 실패했습니다. 결제가되었다면 문의해주세요');
        }
      } else {
        Navigator.pop(InAppPurchaseCtl.instance.purchLoading!);
        snackBar(content: '구매에 실패했습니다.');
      }
    }
  }

  Future<void> getPurchaseList() async {
    List<String> itemId = ['300', '650', '1350', '2700', '5400', '10800'];

    ProductDetailsResponse resItem = await InAppPurchase.instance
        .queryProductDetails({'300', '650', '1350', '2700', '5400', '10800'});
    for (String id in itemId) {
      for (int i = 0; i < resItem.productDetails.length; i++) {
        if (resItem.productDetails[i].id == id) {
          prods.add(resItem.productDetails[i]);
        }
      }
    }
  }

  @required
  void purchaseProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: prod,
        applicationUserName:
            '00000000-0000-5000-8000-${LoginCtl.instance.user.seq.toString().padLeft(12, '0')}');
    InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
  }

  void useCloud(BuildContext context, Widget widget, int price) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: widget,
            ));
  }

  void needCloud(BuildContext context) {
    double height = 200 - AppState.systemBarHeight;
    final DraggableScrollableController draggableCtl =
        DraggableScrollableController();
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        barrierColor: Theme.of(context).bottomSheetTheme.modalBarrierColor,
        builder: (_) => GestureDetector(
              onTap: () {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                color: Colors.transparent,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: StatefulBuilder(builder: (_, setState) {
                  draggableCtl.addListener(() {
                    if (draggableCtl.size < 0.8) {
                      setState(() {
                        height = 200 - AppState.systemBarHeight;
                      });
                    } else {
                      setState(() {
                        height = 332;
                      });
                    }
                  });
                  return DraggableScrollableSheet(
                    controller: draggableCtl,
                    initialChildSize: 0.7,
                    minChildSize: 0.7,
                    maxChildSize: 1,
                    snap: true,
                    builder: (_, scrollController) {
                      return SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        controller: scrollController,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 92,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: mint,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 6,
                                      width: 64,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: white,
                                      ),
                                    ),
                                    Container(
                                      height: 70,
                                      padding: const EdgeInsets.all(25),
                                      child: Text(
                                        // TODO :; 번역 필요
                                        '구름이 부족합니다.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          height: 19 / 16,
                                          color: black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(20),
                                  child: SizedBox(
                                    height: height,
                                    child: SingleChildScrollView(
                                        physics: ClampingScrollPhysics(),
                                        child: Wrap(
                                          alignment: WrapAlignment.spaceAround,
                                          runSpacing: 20,
                                          children: [
                                            for (ProductDetails prod in prods)
                                              ShopItemWidget(prod: prod),
                                          ],
                                        )),
                                  )),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  'enoughClouds'.tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      height: 18 / 12,
                                      color: black),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                          Navigator.pushNamed(
                                              context, NAV_ShopPage);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'GoToStore'.tr(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: purple,
                                                  fontSize: 12,
                                                  height: 18 / 12),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Transform(
                                              alignment: Alignment.center,
                                              transform:
                                                  Matrix4.diagonal3Values(
                                                      -1, 1, 1), // 좌우 반전
                                              child: SvgPicture.asset(
                                                SvgIcon.ICON_arrowBack,
                                                width: 8,
                                                height: 8,
                                                colorFilter: ColorFilter.mode(
                                                    purple, BlendMode.srcIn),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Image.asset(
                                              PngIcon.ICON_store,
                                              width: 26,
                                              height: 26,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 48,
                              ),
                              InkWell(
                                  onTap: () {
                                    p('청약철회규정/미성년자의상품구매');
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: Text(
                                      // TODO :: 번역 필요
                                      '청약철회규정/미성년자의상품구매',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        height: 18 / 12,
                                        color: black,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ));
  }
}

void purchaseLoading(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        InAppPurchaseCtl.instance.purchLoading = context;
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          alignment: Alignment.center,
          insetPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          title: Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      });
}
