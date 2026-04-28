import '../../../chrono.dart' show ParsingContext;
import '../../../common/calculation/weekdays.dart'
    show createParsingComponentsAtWeekday;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../results.dart' show ParsingComponents;
import '../../../types.dart' show RegExpChronoMatch, Weekday;
import '../../../utils/pattern.dart' show matchAnyPattern;
import '../constants.dart' show WEEKDAY_DICTIONARY;

final _pattern = RegExp(
  '(?:(?:\\,|\\(|\\uFF08)\\s*)?'
  '(?:a[mn]\\s*?)?'
  '(?:(diese[mn]|letzte[mn]|n(?:ä|ae)chste[mn])\\s*)?'
  '(${matchAnyPattern(WEEKDAY_DICTIONARY)})'
  '(?:\\s*(?:\\,|\\)|\\uFF09))?'
  '(?:\\s*(diese|letzte|n(?:ä|ae)chste)\\s*woche)?'
  '(?=\\W|\$)',
  caseSensitive: false,
);

class DEWeekdayParser extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(context) {
    return _pattern;
  }

  @override
  ParsingComponents innerExtract(
      ParsingContext context, RegExpChronoMatch match) {
    final dayOfWeek = match[2]!.toLowerCase();
    final weekday = Weekday.weekById(WEEKDAY_DICTIONARY[dayOfWeek] ?? 0);
    final prefix = match[1];
    final postfix = match[3];

    var modifierWord = prefix ?? postfix ?? '';
    modifierWord = modifierWord.toLowerCase();

    String? modifier;
    if (RegExp(r'letzte').hasMatch(modifierWord)) {
      modifier = 'last';
    } else if (RegExp(r'chste').hasMatch(modifierWord)) {
      modifier = 'next';
    } else if (RegExp(r'diese').hasMatch(modifierWord)) {
      modifier = 'this';
    }

    return createParsingComponentsAtWeekday(
        context.reference, weekday, modifier);
  }
}
