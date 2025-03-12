import 'package:rayo/utils/timeago/lang/language.dart';

class Ar implements Language {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String now() => 'الآن';
  @override
  String minutes(int minutes) => '$minutes د';
  @override
  String hours(int hours) => '$hours س';
  @override
  String days(int days) => '$days ي';
  @override
  String months(int months) => '$months ش';
  @override
  String years(int years) => '$years س';
  @override
  String wordSeparator() => ' ';
}
