import '../../utils/pattern.dart' show matchAnyPattern, repeatedTimeunitPattern;
import '../../calculation/years.dart' show findMostLikelyADYear;
import '../../utils/timeunits.dart' show TimeUnits;

const Map<String, int> WEEKDAY_DICTIONARY = {
  'sonntag': 0,
  'so': 0,
  'montag': 1,
  'mo': 1,
  'dienstag': 2,
  'di': 2,
  'mittwoch': 3,
  'mi': 3,
  'donnerstag': 4,
  'do': 4,
  'freitag': 5,
  'fr': 5,
  'samstag': 6,
  'sa': 6,
};

const Map<String, int> MONTH_DICTIONARY = {
  'januar': 1,
  'janner': 1,
  'jänner': 1,
  'jan': 1,
  'jan.': 1,
  'februar': 2,
  'feber': 2,
  'feb': 2,
  'feb.': 2,
  'märz': 3,
  'maerz': 3,
  'mär': 3,
  'mär.': 3,
  'mrz': 3,
  'mrz.': 3,
  'april': 4,
  'apr': 4,
  'apr.': 4,
  'mai': 5,
  'juni': 6,
  'jun': 6,
  'jun.': 6,
  'juli': 7,
  'jul': 7,
  'jul.': 7,
  'august': 8,
  'aug': 8,
  'aug.': 8,
  'september': 9,
  'sep': 9,
  'sep.': 9,
  'sept': 9,
  'sept.': 9,
  'oktober': 10,
  'okt': 10,
  'okt.': 10,
  'november': 11,
  'nov': 11,
  'nov.': 11,
  'dezember': 12,
  'dez': 12,
  'dez.': 12,
};

const Map<String, int> INTEGER_WORD_DICTIONARY = {
  'eins': 1,
  'eine': 1,
  'einem': 1,
  'einen': 1,
  'einer': 1,
  'zwei': 2,
  'drei': 3,
  'vier': 4,
  'fünf': 5,
  'fuenf': 5,
  'sechs': 6,
  'sieben': 7,
  'acht': 8,
  'neun': 9,
  'zehn': 10,
  'elf': 11,
  'zwölf': 12,
  'zwoelf': 12,
};

const Map<String, String> TIME_UNIT_DICTIONARY = {
  'sek': 'second',
  'sekunde': 'second',
  'sekunden': 'second',
  'min': 'minute',
  'minute': 'minute',
  'minuten': 'minute',
  'h': 'hour',
  'std': 'hour',
  'stunde': 'hour',
  'stunden': 'hour',
  'tag': 'd',
  'tage': 'd',
  'tagen': 'd',
  'woche': 'week',
  'wochen': 'week',
  'monat': 'month',
  'monate': 'month',
  'monaten': 'month',
  'monats': 'month',
  'quartal': 'quarter',
  'quartale': 'quarter',
  'quartalen': 'quarter',
  'quartals': 'quarter',
  'a': 'year',
  'j': 'year',
  'jr': 'year',
  'jahr': 'year',
  'jahre': 'year',
  'jahren': 'year',
  'jahres': 'year',
};

final NUMBER_PATTERN = '(?:${matchAnyPattern(INTEGER_WORD_DICTIONARY)}|'
    r'[0-9]+|[0-9]+\.[0-9]+|halb?|halbe?|einigen?|wenigen?|mehreren?)';

double parseNumberPattern(String match) {
  final num = match.toLowerCase();
  if (INTEGER_WORD_DICTIONARY[num] != null) {
    return INTEGER_WORD_DICTIONARY[num]!.toDouble();
  }
  if (num == 'ein' ||
      num == 'eine' ||
      num == 'einem' ||
      num == 'einen' ||
      num == 'einer') {
    return 1;
  }
  if (RegExp(r'wenigen').hasMatch(num)) {
    return 2;
  }
  if (RegExp(r'halb').hasMatch(num)) {
    return 0.5;
  }
  if (RegExp(r'einigen').hasMatch(num)) {
    return 3;
  }
  if (RegExp(r'mehreren').hasMatch(num)) {
    return 7;
  }

  return double.parse(num);
}

final YEAR_PATTERN =
    r'(?:[0-9]{1,4}(?:\s*[vn]\.?\s*(?:C(?:hr)?|(?:u\.?|d\.?(?:\s*g\.?)?)?\s*Z)\.?|\s*(?:u\.?|d\.?(?:\s*g\.)?)\s*Z\.?)?)';

int parseYear(String match) {
  if (RegExp(r'v', caseSensitive: false).hasMatch(match)) {
    return -int.parse(
        match.replaceAll(RegExp(r'[^0-9]+', caseSensitive: false), ''));
  }

  if (RegExp(r'[nz]', caseSensitive: false).hasMatch(match)) {
    return int.parse(
        match.replaceAll(RegExp(r'[^0-9]+', caseSensitive: false), ''));
  }

  return findMostLikelyADYear(int.parse(match));
}

final _SINGLE_TIME_UNIT_PATTERN =
    '($NUMBER_PATTERN)\\s{0,5}(${matchAnyPattern(TIME_UNIT_DICTIONARY)})\\s{0,5}';
final _SINGLE_TIME_UNIT_REGEX =
    RegExp(_SINGLE_TIME_UNIT_PATTERN, caseSensitive: false);

final TIME_UNITS_PATTERN =
    repeatedTimeunitPattern('', _SINGLE_TIME_UNIT_PATTERN);

TimeUnits parseDuration(String timeunitText) {
  final fragments = <String, num>{};
  var remainingText = timeunitText;
  var match = _SINGLE_TIME_UNIT_REGEX.firstMatch(remainingText);
  while (match != null) {
    _collectDateTimeFragment(fragments, match);
    remainingText = remainingText.substring(match[0]!.length);
    match = _SINGLE_TIME_UNIT_REGEX.firstMatch(remainingText);
  }
  return fragments;
}

void _collectDateTimeFragment(Map<String, num> fragments, RegExpMatch match) {
  final num = parseNumberPattern(match[1]!);
  final unit = TIME_UNIT_DICTIONARY[match[2]!.toLowerCase()]!;
  fragments[unit] = num;
}
