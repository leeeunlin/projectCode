import 'package:rayo/utils/timeago/lang/language.dart';

class Fr implements Language {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String now() => "maintenant";
  @override
  String minutes(int minutes) => '$minutes min';
  @override
  String hours(int hours) => '$hours h';
  @override
  String days(int days) => '$days j';
  @override
  String months(int months) => '$months mois';
  @override
  String years(int years) => '$years ans';
  @override
  String wordSeparator() => ' ';
}
