import 'package:rayo/utils/timeago/lang/language.dart';

class Ja implements Language {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String now() => '今';
  @override
  String minutes(int minutes) => '$minutes分';
  @override
  String hours(int hours) => '$hours時間';
  @override
  String days(int days) => '$days日';
  @override
  String months(int months) => '$monthsか月';
  @override
  String years(int years) => '$years年';
  @override
  String wordSeparator() => '';
}
