import 'package:rayo/utils/timeago/lang/ar.dart';
import 'package:rayo/utils/timeago/lang/de.dart';
import 'package:rayo/utils/timeago/lang/en.dart';
import 'package:rayo/utils/timeago/lang/es.dart';
import 'package:rayo/utils/timeago/lang/fr.dart';
import 'package:rayo/utils/timeago/lang/ja.dart';
import 'package:rayo/utils/timeago/lang/ko.dart';
import 'package:rayo/utils/timeago/lang/language.dart';

String _default = 'en';

Map<String, Language> _lookupMessagesMap = {
  'ar': Ar(),
  'de': De(),
  'en': En(),
  'es': Es(),
  'fr': Fr(),
  'ja': Ja(),
  'ko': Ko(),
};

void setDefaultLocale(String locale) {
  assert(_lookupMessagesMap.containsKey(locale),
      '[locale] must be a registered locale');
  _default = locale;
}

void setLocaleMessages(String locale, Language lookupMessages) {
  _lookupMessagesMap[locale] = lookupMessages;
}

String timeSetFormat(DateTime date,
    {String? locale, DateTime? clock, bool allowFromNow = false}) {
  final locale0 = locale ?? _default;

  final allowFromNow0 = allowFromNow;
  final messages = _lookupMessagesMap[locale0] ?? En();
  final clock0 = clock ?? DateTime.now();
  var elapsed = clock0.millisecondsSinceEpoch - date.millisecondsSinceEpoch;

  String prefix, suffix;

  if (allowFromNow0 && elapsed < 0) {
    elapsed = date.isBefore(clock0) ? elapsed : elapsed.abs();
    prefix = messages.prefixFromNow();
    suffix = messages.suffixFromNow();
  } else {
    prefix = messages.prefixAgo();
    suffix = messages.suffixAgo();
  }

  final num seconds = elapsed / 1000;
  final num minutes = seconds / 60;
  final num hours = minutes / 60;
  final num days = hours / 24;
  final num months = days / 30;
  final num years = days / 365;

  String result;
  if (seconds < 60) {
    result = messages.now();
  } else if (minutes < 60) {
    result = messages.minutes(minutes.round());
  } else if (hours < 24) {
    result = messages.hours(hours.round());
  } else if (days < 30) {
    result = messages.days(days.round());
  } else if (days < 365) {
    result = messages.months(months.round());
  } else {
    result = messages.years(years.round());
  }

  return [prefix, result, suffix]
      .where((str) => str.isNotEmpty)
      .join(messages.wordSeparator());
}
