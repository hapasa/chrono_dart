import '../../utils/pattern.dart' show matchAnyPattern, repeatedTimeunitPattern;
import '../../calculation/years.dart' show findMostLikelyADYear;
import '../../utils/timeunits.dart' show TimeUnits;

const Map<String, int> WEEKDAY_DICTIONARY = {
  'söndag': 0,
  'sön': 0,
  'so': 0,
  'måndag': 1,
  'mån': 1,
  'må': 1,
  'tisdag': 2,
  'tis': 2,
  'ti': 2,
  'onsdag': 3,
  'ons': 3,
  'on': 3,
  'torsdag': 4,
  'tors': 4,
  'to': 4,
  'fredag': 5,
  'fre': 5,
  'fr': 5,
  'lördag': 6,
  'lör': 6,
  'lö': 6,
};

const Map<String, int> MONTH_DICTIONARY = {
  'januari': 1,
  'jan': 1,
  'jan.': 1,
  'februari': 2,
  'feb': 2,
  'feb.': 2,
  'mars': 3,
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
  'augusti': 8,
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
  'första': 1,
  'andra': 2,
  'tredje': 3,
  'fjärde': 4,
  'femte': 5,
  'sjätte': 6,
  'sjunde': 7,
  'åttonde': 8,
  'nionde': 9,
  'tionde': 10,
  'elfte': 11,
  'tolfte': 12,
  'trettonde': 13,
  'fjortonde': 14,
  'femtonde': 15,
  'sextonde': 16,
  'sjuttonde': 17,
  'artonde': 18,
  'nittonde': 19,
  'tjugonde': 20,
  'tjugoförsta': 21,
  'tjugoandra': 22,
  'tjugotredje': 23,
  'tjugofjärde': 24,
  'tjugofemte': 25,
  'tjugosjätte': 26,
  'tjugosjunde': 27,
  'tjugoåttonde': 28,
  'tjugonionde': 29,
  'trettionde': 30,
  'trettioförsta': 31,
};

const Map<String, int> INTEGER_WORD_DICTIONARY = {
  'en': 1,
  'ett': 1,
  'två': 2,
  'tre': 3,
  'fyra': 4,
  'fem': 5,
  'sex': 6,
  'sju': 7,
  'åtta': 8,
  'nio': 9,
  'tio': 10,
  'elva': 11,
  'tolv': 12,
  'tretton': 13,
  'fjorton': 14,
  'femton': 15,
  'sexton': 16,
  'sjutton': 17,
  'arton': 18,
  'nitton': 19,
  'tjugo': 20,
  'trettio': 30,
  'fyrtio': 40,
  'femtio': 50,
  'sextio': 60,
  'sjuttio': 70,
  'åttio': 80,
  'nittio': 90,
  'hundra': 100,
  'tusen': 1000,
};

const Map<String, String> TIME_UNIT_DICTIONARY = {
  'sek': 'second',
  'sekund': 'second',
  'sekunder': 'second',
  'min': 'minute',
  'minut': 'minute',
  'minuter': 'minute',
  'tim': 'hour',
  'timme': 'hour',
  'timmar': 'hour',
  'dag': 'd',
  'dagar': 'd',
  'vecka': 'week',
  'veckor': 'week',
  'mån': 'month',
  'månad': 'month',
  'månader': 'month',
  'år': 'year',
  'kvartal': 'quarter',
};

const Map<String, String> TIME_UNIT_NO_ABBR_DICTIONARY = {
  'sekund': 'second',
  'sekunder': 'second',
  'minut': 'minute',
  'minuter': 'minute',
  'timme': 'hour',
  'timmar': 'hour',
  'dag': 'd',
  'dagar': 'd',
  'vecka': 'week',
  'veckor': 'week',
  'månad': 'month',
  'månader': 'month',
  'år': 'year',
  'kvartal': 'quarter',
};

final NUMBER_PATTERN = '(?:${matchAnyPattern(INTEGER_WORD_DICTIONARY)}|\\d+)';
final ORDINAL_NUMBER_PATTERN =
    '(?:${matchAnyPattern(ORDINAL_NUMBER_DICTIONARY)}|\\d{1,2}(?:e|:e))';
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
  return int.parse(num.replaceFirst(RegExp(r'(?:e|:e)$'), ''));
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
