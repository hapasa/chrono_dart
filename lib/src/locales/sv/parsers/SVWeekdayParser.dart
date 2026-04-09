import '../../../chrono.dart' show ParsingContext;
import '../../../common/calculation/weekdays.dart'
    show createParsingComponentsAtWeekday;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../results.dart' show ParsingComponents;
import '../../../types.dart' show RegExpChronoMatch, Weekday;
import '../../../utils/pattern.dart' show matchAnyPattern;
import '../constants.dart' show WEEKDAY_DICTIONARY;

final _pattern = RegExp(
  '(?:(?:\\,|\\(|\\uFF08)\\s*)?' +
      '(?:på\\s*?)?' +
      '(?:(förra|senaste|nästa|kommande)\\s*)?' +
      '(${matchAnyPattern(WEEKDAY_DICTIONARY)})' +
      '(?:\\s*(?:\\,|\\)|\\uFF09))?' +
      '(?:\\s*(förra|senaste|nästa|kommande)\\s*vecka)?' +
      '(?=\\W|\$)',
  caseSensitive: false,
);

const _PREFIX_GROUP = 1;
const _WEEKDAY_GROUP = 2;
const _POSTFIX_GROUP = 3;

class SVWeekdayParser extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(context) {
    return _pattern;
  }

  @override
  ParsingComponents innerExtract(
      ParsingContext context, RegExpChronoMatch match) {
    final dayOfWeek = match[_WEEKDAY_GROUP]!.toLowerCase();
    final weekday = Weekday.weekById(WEEKDAY_DICTIONARY[dayOfWeek] ?? 0);
    final prefix = match[_PREFIX_GROUP];
    final postfix = match[_POSTFIX_GROUP];

    var modifierWord = prefix ?? postfix ?? '';
    modifierWord = modifierWord.toLowerCase();

    String? modifier;
    if (RegExp(r'förra|senaste').hasMatch(modifierWord)) {
      modifier = 'last';
    } else if (RegExp(r'nästa|kommande').hasMatch(modifierWord)) {
      modifier = 'next';
    }

    return createParsingComponentsAtWeekday(
        context.reference, weekday, modifier);
  }
}

