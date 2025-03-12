import 'package:rayo/utils/timeago/lang/language.dart';

class Ko implements Language {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String now() => '방금';
  @override
  String minutes(int minutes) => '$minutes분';
  @override
  String hours(int hours) => '$hours시간';
  @override
  String days(int days) => '$days일';
  @override
  String months(int months) => '$months개월';
  @override
  String years(int years) => '$years년';
  @override
  String wordSeparator() => ' ';
}
