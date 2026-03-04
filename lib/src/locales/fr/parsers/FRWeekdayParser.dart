// ignore_for_file: constant_identifier_names

import '../../../types.dart' show RegExpChronoMatch, Weekday;
import '../../../chrono.dart' show ParsingContext;
import '../../../results.dart' show ParsingComponents;
import '../constants.dart' show WEEKDAY_DICTIONARY;
import '../../../utils/pattern.dart' show matchAnyPattern;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart'
    show AbstractParserWithWordBoundaryChecking;
import '../../../common/calculation/weekdays.dart'
    show createParsingComponentsAtWeekday;

final _pattern = RegExp(
  // ignore: prefer_interpolation_to_compose_strings
  '(?:(?:\\,|\\(|\uFF08)\\s*)?' +
      '(?:(?:ce)\\s*)?' +
      '(${matchAnyPattern(WEEKDAY_DICTIONARY)})' +
      '(?:\\s*(?:\\,|\\)|\uFF09))?' +
      '(?:\\s*(dernier|prochain)\\s*)?' +
      '(?=\\W|\\d|\$)',
  caseSensitive: false,
);

const _WEEKDAY_GROUP = 1;
const _POSTFIX_GROUP = 2;

class FRWeekdayParser extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(context) {
    return _pattern;
  }

  @override
  ParsingComponents innerExtract(
      ParsingContext context, RegExpChronoMatch match) {
    final dayOfWeek = match[_WEEKDAY_GROUP]!.toLowerCase();
    final weekday = Weekday.weekById(WEEKDAY_DICTIONARY[dayOfWeek] ?? 0);

    var suffix = match[_POSTFIX_GROUP] ?? '';
    suffix = suffix.toLowerCase();

    String? modifier;
    if (suffix == 'dernier') {
      modifier = 'last';
    } else if (suffix == 'prochain') {
      modifier = 'next';
    }

    return createParsingComponentsAtWeekday(
        context.reference, weekday, modifier);
  }
}
