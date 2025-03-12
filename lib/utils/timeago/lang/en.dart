import 'package:rayo/utils/timeago/lang/language.dart';

class En implements Language {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String now() => 'now';
  @override
  String minutes(int minutes) => '${minutes}m';
  @override
  String hours(int hours) => '${hours}h';
  @override
  String days(int days) => '${days}d';
  @override
  String months(int months) => '${months}mo';
  @override
  String years(int years) => '${years}y';
  @override
  String wordSeparator() => ' ';
}
