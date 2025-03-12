import 'package:rayo/utils/import_index.dart';

class SkeletonUserList extends StatelessWidget {
  const SkeletonUserList({
    super.key,
  });
  @override
  Widget build(context) => Shimmer.fromColors(
      baseColor: black[40]!,
      highlightColor: white,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: white),
            width: 50,
            height: 50,
          ),
          SizedBox(width: 16),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 16,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), color: white),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 14,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), color: white),
              ),
            ],
          ))
        ],
      ));
}

class SkeletonLocaleList extends StatelessWidget {
  const SkeletonLocaleList({super.key});
  @override
  Widget build(context) => Shimmer.fromColors(
      baseColor: black[40]!,
      highlightColor: white,
      child: Container(
        width: double.infinity,
        height: 42,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: white),
      ));
}

class SkeletonSearchList extends StatelessWidget {
  const SkeletonSearchList({super.key});
  @override
  Widget build(context) => Shimmer.fromColors(
      baseColor: black[40]!,
      highlightColor: white,
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: white,
        ),
      ));
}

class SkeletonGridList extends StatelessWidget {
  const SkeletonGridList({super.key});
  @override
  Widget build(context) => Shimmer.fromColors(
      baseColor: black[40]!,
      highlightColor: white,
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: white,
        ),
      ));
}

class SkeletonReviewList extends StatelessWidget {
  const SkeletonReviewList({super.key});
  @override
  Widget build(context) => Shimmer.fromColors(
      baseColor: black[40]!,
      highlightColor: white,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.infinity,
        height: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: white,
        ),
      ));
}

class SkeletonAlertList extends StatelessWidget {
  const SkeletonAlertList({super.key});
  @override
  Widget build(context) => Shimmer.fromColors(
      baseColor: black[40]!,
      highlightColor: white,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: white),
            width: 50,
            height: 50,
          ),
          SizedBox(width: 16),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 17,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), color: white),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 18,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), color: white),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                width: 30,
                height: 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), color: white),
              ),
            ],
          ))
        ],
      ));
}
