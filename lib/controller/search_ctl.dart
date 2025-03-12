import 'package:rayo/utils/import_index.dart';

class SearchCtl {
  static final SearchCtl instance = SearchCtl._internal();
  factory SearchCtl() {
    return instance;
  }
  SearchCtl._internal();

  int near = 0;
  int gender = 99;
  bool food = true;
  bool amity = true;
  bool art = true;
  bool exercise = true;

  String setFilterString() {
    String filterString = '';
    if (food) filterString += '${'food'.tr()}  ';
    if (amity) filterString += '${'socializing'.tr()}  ';
    if (art) filterString += '${'artsCulture'.tr()}  ';
    if (exercise) filterString += '${'sports'.tr()}  ';
    if (near == 0) {
      if (food && amity && art && exercise) {
        filterString += '|  ${'nearby'.tr()}  ';
      } else {
        filterString += '${'nearby'.tr()}  ';
      }
    }
    if (gender == 99) {
      filterString += '|  무작위  ';
    } else if (gender == 1 || gender == 2) {
      if (LoginCtl.instance.user.gender == gender) {
        filterString += '|  동성  ';
      } else {
        filterString += '|  이성  ';
      }
    } else {
      filterString += '|  모두  ';
    }
    filterString += '|  비슷한나이대';
    return filterString;
  }

  int calcFilter() {
    int calcFilter = 0;
    if (food && amity && art && exercise) {
      if (near != 0) calcFilter++;
      if (gender != 99) calcFilter++;
    } else {
      if (near != 0) calcFilter++;
      if (gender != 99) calcFilter++;
      if (food) calcFilter++;
      if (amity) calcFilter++;
      if (art) calcFilter++;
      if (exercise) calcFilter++;
    }
    return calcFilter;
  }
}
