import '../../utils/pattern.dart' show matchAnyPattern, repeatedTimeunitPattern;
import '../../calculation/years.dart' show findMostLikelyADYear;
import '../../utils/timeunits.dart' show TimeUnits;

const Map<String, int> WEEKDAY_DICTIONARY = {
  'søndag': 0,
  'søn': 0,
  'mandag': 1,
  'man': 1,
  'tirsdag': 2,
  'tir': 2,
  'onsdag': 3,
  'ons': 3,
  'torsdag': 4,
  'tors': 4,
  'fredag': 5,
  'fre': 5,
  'lørdag': 6,
  'lør': 6,
};

const Map<String, int> MONTH_DICTIONARY = {
  'januar': 1,
  'jan': 1,
  'jan.': 1,
  'februar': 2,
  'feb': 2,
  'feb.': 2,
  'marts': 3,
  'mar': 3,
  'mar.': 3,
  'april': 4,
  'apr': 4,
  'apr.': 4,
  'maj': 5,
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
  'december': 12,
  'dec': 12,
  'dec.': 12,
};

const Map<String, int> ORDINAL_NUMBER_DICTIONARY = {
  'første': 1,
  'anden': 2,
  'tredje': 3,
  'fjerde': 4,
  'femte': 5,
  'sjette': 6,
  'syvende': 7,
  'ottende': 8,
  'niende': 9,
  'tiende': 10,
  'ellevte': 11,
  'tolvte': 12,
};

const Map<String, int> INTEGER_WORD_DICTIONARY = {
  'en': 1,
  'et': 1,
  'to': 2,
  'tre': 3,
  'fire': 4,
  'fem': 5,
  'seks': 6,
  'syv': 7,
  'otte': 8,
  'ni': 9,
  'ti': 10,
  'elleve': 11,
  'tolv': 12,
  'tretten': 13,
  'fjorten': 14,
  'femten': 15,
  'seksten': 16,
  'sytten': 17,
  'atten': 18,
  'nitten': 19,
  'tyve': 20,
  'tredive': 30,
  'fyrre': 40,
  'halvtreds': 50,
  'tres': 60,
  'halvfjerds': 70,
  'firs': 80,
  'halvfems': 90,
  'hundrede': 100,
  'tusind': 1000,
};

const Map<String, String> TIME_UNIT_DICTIONARY = {
  'sek': 'second',
  'sekund': 'second',
  'sekunder': 'second',
  'min': 'minute',
  'minut': 'minute',
  'minutter': 'minute',
  't': 'hour',
  'time': 'hour',
  'timer': 'hour',
  'dag': 'd',
  'dage': 'd',
  'uge': 'week',
  'uger': 'week',
  'måned': 'month',
  'måneder': 'month',
  'år': 'year',
  'kvartal': 'quarter',
  'kvartaler': 'quarter',
};

const Map<String, String> TIME_UNIT_NO_ABBR_DICTIONARY = {
  'sekund': 'second',
  'sekunder': 'second',
  'minut': 'minute',
  'minutter': 'minute',
  'time': 'hour',
  'timer': 'hour',
  'dag': 'd',
  'dage': 'd',
  'uge': 'week',
  'uger': 'week',
  'måned': 'month',
  'måneder': 'month',
  'år': 'year',
  'kvartal': 'quarter',
  'kvartaler': 'quarter',
};

final NUMBER_PATTERN = '(?:${matchAnyPattern(INTEGER_WORD_DICTIONARY)}|\\d+)';
final ORDINAL_NUMBER_PATTERN =
    '(?:${matchAnyPattern(ORDINAL_NUMBER_DICTIONARY)}|\\d{1,2}(?:\\.)?)';
const YEAR_PATTERN = '(?:[1-2][0-9]{3}|[5-9][0-9])';

final _SINGLE_TIME_UNIT_PATTERN =
    '($NUMBER_PATTERN)\\s{0,5}(${matchAnyPattern(TIME_UNIT_DICTIONARY)})\\s{0,5}';
final _SINGLE_TIME_UNIT_REGEX =
    RegExp(_SINGLE_TIME_UNIT_PATTERN, caseSensitive: false);

final _SINGLE_TIME_UNIT_NO_ABBR_PATTERN =
    '($NUMBER_PATTERN)\\s{0,5}(${matchAnyPattern(TIME_UNIT_NO_ABBR_DICTIONARY)})\\s{0,5}';

final TIME_UNITS_PATTERN = repeatedTimeunitPattern('', _SINGLE_TIME_UNIT_PATTERN);
final TIME_UNITS_NO_ABBR_PATTERN =
    repeatedTimeunitPattern('', _SINGLE_TIME_UNIT_NO_ABBR_PATTERN);

int parseYear(String match) {
  return findMostLikelyADYear(int.parse(match));
}

double parseNumberPattern(String match) {
  final num = match.toLowerCase();
  if (INTEGER_WORD_DICTIONARY[num] != null) {
    return INTEGER_WORD_DICTIONARY[num]!.toDouble();
  }
  return double.parse(num);
}

int parseOrdinalNumberPattern(String match) {
  final num = match.toLowerCase();
  if (ORDINAL_NUMBER_DICTIONARY[num] != null) {
    return ORDINAL_NUMBER_DICTIONARY[num]!;
  }
  return int.parse(num.replaceFirst(RegExp(r'\.$'), ''));
}

TimeUnits parseDuration(String timeunitText, [bool allowAbbreviations = true]) {
  final fragments = <String, num>{};
  var remainingText = timeunitText;
  final unitRegex = allowAbbreviations
      ? _SINGLE_TIME_UNIT_REGEX
      : RegExp(_SINGLE_TIME_UNIT_NO_ABBR_PATTERN, caseSensitive: false);

  var match = unitRegex.firstMatch(remainingText);
  while (match != null) {
    collectDateTimeFragment(
      fragments,
      match,
      allowAbbreviations ? TIME_UNIT_DICTIONARY : TIME_UNIT_NO_ABBR_DICTIONARY,
    );
    remainingText = remainingText.substring(match[0]!.length);
    match = unitRegex.firstMatch(remainingText);
  }

  return fragments;
}

void collectDateTimeFragment(
  Map<String, num> fragments,
  RegExpMatch match,
  Map<String, String> unitDictionary,
) {
  final num = parseNumberPattern(match[1]!);
  final unit = unitDictionary[match[2]!.toLowerCase()]!;
  fragments[unit] = num;
}

