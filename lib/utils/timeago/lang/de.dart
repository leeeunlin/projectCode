import 'package:rayo/utils/timeago/lang/language.dart';

class De implements Language {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String now() => 'Jetzt';
  @override
  String minutes(int minutes) => '$minutes Min.';
  @override
  String hours(int hours) => '$hours Std.';
  @override
  String days(int days) => '$days Tage';
  @override
  String months(int months) => '$months Mo.';
  @override
  String years(int years) => '$years Jr.';
  @override
  String wordSeparator() => ' ';
}
