abstract class Language {
  String prefixAgo();
  String prefixFromNow();
  String suffixAgo();
  String suffixFromNow();
  String now();
  String minutes(int minutes);
  String hours(int hours);
  String days(int days);
  String months(int months);
  String years(int years);
  String wordSeparator() => ' ';
}
