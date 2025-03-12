import 'package:rayo/utils/import_index.dart';

class ReviewCtl {
  static final ReviewCtl _instance = ReviewCtl._internal();
  factory ReviewCtl() {
    return _instance;
  }
  ReviewCtl._internal();
  static ReviewCtl get instance => _instance;
  ValueNotifier<bool> loadingVal = ValueNotifier<bool>(false);
  List<ReviewModel> reviewList = <ReviewModel>[];

  void init() async {
    await getReviewList();
  }

  Future<ReviewModel> writeReview(ReviewModel reviewModel) async {
    loadingVal.value = true;
    // reviewModel.name = LoginCtl.instance.user.name;
    // reviewModel.profileImg = LoginCtl.instance.user.profileImg;
    p('리뷰작성 api');

    await Future.delayed(Duration(seconds: 1));
    p('리뷰 작성 후 랜딩페이지 확인해야함');
    loadingVal.value = false;
    return reviewModel;
  }

  Future<void> getReviewList() async {
    //   reviewList.add(ReviewModel(
    //       seq: 0,
    //       profileImg:
    //           'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
    //       imgDetail: [
    //         'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
    //         'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG'
    //       ],
    //       name: 'test1',
    //       txtdetail: '다같이 뛰니까\nkajsdhfjkahsdkjfhalksdj',
    //       rating: 3.0));
    //   reviewList.add(ReviewModel(
    //       seq: 1,
    //       profileImg: '',
    //       imgDetail: [
    //         'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
    //         'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG'
    //       ],
    //       name: 'test2',
    //       rating: 4.0,
    //       txtdetail:
    //           '다같이 뛰니까 서로 응원하게 되고 중간에 포기도 안하고\n러닝 후 먹는 고기는 또 얼마나 맛있게요\n이 멤버 기억할겁니다 꼭 다시 만나요~!~!~!\n특히 먹잘알 방장님.. 최고!!\n다같이 뛰니까 서로 응원하게 되고 중간에 포기도 안하고\n러닝 후 먹는 고기는 또 얼마나 맛있게요\n이 멤버 기억할겁니다 꼭 다시 만나요~!~!~!\n특히 먹잘알 방장님.. 최고!!'));
    //   reviewList.add(ReviewModel(
    //       seq: 2,
    //       profileImg: '',
    //       imgDetail: [
    //         'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG',
    //         'https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG'
    //       ],
    //       rating: 0.0,
    //       name: 'test3',
    //       txtdetail:
    //           '다같이 뛰니까 서로 응원하게 되고 중간에 포기도 안하고\n러닝 후 먹는 고기는 또 얼마나 맛있게요\n이 멤버 기억할겁니다 꼭 다시 만나요~!~!~!\n특히 먹잘알 방장님.. 최고!!\n다같이 뛰니까 서로 응원하게 되고 중간에 포기도 안하고\n러닝 후 먹는 고기는 또 얼마나 맛있게요\n이 멤버 기억할겁니다 꼭 다시 만나요~!~!~!\n특히 먹잘알 방장님.. 최고!!'));
  }
}
