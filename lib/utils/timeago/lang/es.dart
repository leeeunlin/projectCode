import 'package:rayo/utils/timeago/lang/language.dart';

class Es implements Language {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String now() => 'ahora';
  @override
  String minutes(int minutes) => '$minutes min';
  @override
  String hours(int hours) => '$hours h';
  @override
  String days(int days) => '$days d';
  @override
  String months(int months) => '$months mes';
  @override
  String years(int years) => '$years año';
  @override
  String wordSeparator() => ' ';
}
