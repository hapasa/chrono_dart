import '../../utils/pattern.dart' show matchAnyPattern, repeatedTimeunitPattern;
import '../../utils/timeunits.dart' show TimeUnits;

const Map<String, int> WEEKDAY_DICTIONARY = {
  'dimanche': 0,
  'dim': 0,
  'lundi': 1,
  'lun': 1,
  'mardi': 2,
  'mar': 2,
  'mercredi': 3,
  'mer': 3,
  'jeudi': 4,
  'jeu': 4,
  'vendredi': 5,
  'ven': 5,
  'samedi': 6,
  'sam': 6,
};

const Map<String, int> MONTH_DICTIONARY = {
  'janvier': 1,
  'jan': 1,
  'jan.': 1,
  'février': 2,
  'fév': 2,
  'fév.': 2,
  'fevrier': 2,
  'fev': 2,
  'fev.': 2,
  'mars': 3,
  'mar': 3,
  'mar.': 3,
  'avril': 4,
  'avr': 4,
  'avr.': 4,
  'mai': 5,
  'juin': 6,
  'jun': 6,
  'juillet': 7,
  'juil': 7,
  'jul': 7,
  'jul.': 7,
  'août': 8,
  'aout': 8,
  'septembre': 9,
  'sep': 9,
  'sep.': 9,
  'sept': 9,
  'sept.': 9,
  'octobre': 10,
  'oct': 10,
  'oct.': 10,
  'novembre': 11,
  'nov': 11,
  'nov.': 11,
  'décembre': 12,
  'decembre': 12,
  'dec': 12,
  'dec.': 12,
};

const Map<String, int> INTEGER_WORD_DICTIONARY = {
  'un': 1,
  'deux': 2,
  'trois': 3,
  'quatre': 4,
  'cinq': 5,
  'six': 6,
  'sept': 7,
  'huit': 8,
  'neuf': 9,
  'dix': 10,
  'onze': 11,
  'douze': 12,
  'treize': 13,
};

const Map<String, String> TIME_UNIT_DICTIONARY = {
  'sec': 'second',
  'seconde': 'second',
  'secondes': 'second',
  'min': 'minute',
  'mins': 'minute',
  'minute': 'minute',
  'minutes': 'minute',
  'h': 'hour',
  'hr': 'hour',
  'hrs': 'hour',
  'heure': 'hour',
  'heures': 'hour',
  'jour': 'd',
  'jours': 'd',
  'semaine': 'week',
  'semaines': 'week',
  'mois': 'month',
  'trimestre': 'quarter',
  'trimestres': 'quarter',
  'ans': 'year',
  'année': 'year',
  'années': 'year',
};

final NUMBER_PATTERN =
    "(?:${matchAnyPattern(INTEGER_WORD_DICTIONARY)}|[0-9]+|[0-9]+\\.[0-9]+|une?\\b|quelques?|demi-?)";

double parseNumberPattern(String match) {
  final num = match.toLowerCase();
  if (INTEGER_WORD_DICTIONARY[num] != null) {
    return INTEGER_WORD_DICTIONARY[num]!.toDouble();
  } else if (num == 'une' || num == 'un') {
    return 1;
  } else if (RegExp(r'quelques?').hasMatch(num)) {
    return 3;
  } else if (RegExp(r'demi-?').hasMatch(num)) {
    return 0.5;
  }

  return double.parse(num);
}

final ORDINAL_NUMBER_PATTERN = '(?:[0-9]{1,2}(?:er)?)';

int parseOrdinalNumberPattern(String match) {
  final num = match.toLowerCase().replaceFirst(RegExp(r'(?:er)$', caseSensitive: false), '');
  return int.parse(num);
}

final YEAR_PATTERN =
    '(?:[1-9][0-9]{0,3}\\s*(?:AC|AD|p\\.\\s*C(?:hr?)?\\.\\s*n\\.)|[1-2][0-9]{3}|[5-9][0-9])';

int parseYear(String match) {
  if (RegExp(r'AC', caseSensitive: false).hasMatch(match)) {
    match = match.replaceFirst(RegExp(r'AC', caseSensitive: false), '');
    return -int.parse(match.trim());
  }

  if (RegExp(r'AD', caseSensitive: false).hasMatch(match) ||
      RegExp(r'C', caseSensitive: false).hasMatch(match)) {
    match = match.replaceAll(RegExp(r'[^\d]+', caseSensitive: false), '');
    return int.parse(match);
  }

  var yearNumber = int.parse(match);
  if (yearNumber < 100) {
    if (yearNumber > 50) {
      yearNumber += 1900;
    } else {
      yearNumber += 2000;
    }
  }

  return yearNumber;
}

final _SINGLE_TIME_UNIT_PATTERN =
    '($NUMBER_PATTERN)\\s{0,5}(${matchAnyPattern(TIME_UNIT_DICTIONARY)})\\s{0,5}';
final _SINGLE_TIME_UNIT_REGEX =
    RegExp(_SINGLE_TIME_UNIT_PATTERN, caseSensitive: false);

final TIME_UNITS_PATTERN = repeatedTimeunitPattern('', _SINGLE_TIME_UNIT_PATTERN);

TimeUnits parseDuration(String timeunitText) {
  final fragments = <String, num>{};
  var remainingText = timeunitText;
  var match = _SINGLE_TIME_UNIT_REGEX.firstMatch(remainingText);
  while (match != null) {
    collectDateTimeFragment(fragments, match);
    remainingText = remainingText.substring(match[0]!.length);
    match = _SINGLE_TIME_UNIT_REGEX.firstMatch(remainingText);
  }
  return fragments;
}

void collectDateTimeFragment(Map<String, num> fragments, RegExpMatch match) {
  final num = parseNumberPattern(match[1]!);
  final unit = TIME_UNIT_DICTIONARY[match[2]!.toLowerCase()]!;
  fragments[unit] = num;
}
