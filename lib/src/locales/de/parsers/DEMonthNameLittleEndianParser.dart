import '../../../results.dart' show ParsingResult;
import '../../../chrono.dart' show ParsingContext;
import '../../../types.dart' show RegExpChronoMatch, Component;
import '../../../calculation/years.dart' show findYearClosestToRef;
import '../constants.dart' show MONTH_DICTIONARY, YEAR_PATTERN, parseYear;
import '../../../utils/pattern.dart' show matchAnyPattern;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';

final _pattern = RegExp(
  '(?:am\\s*?)?'
  '(?:den\\s*?)?'
  '([0-9]{1,2})\\.'
  '(?:\\s*(?:bis(?:\\s*(?:am|zum))?|\\-|\\u2013|\\s)\\s*([0-9]{1,2})\\.?)?\\s*'
  '(${matchAnyPattern(MONTH_DICTIONARY)})'
  '(?:(?:-|/|,?\\s*)($YEAR_PATTERN(?![^\\s]\\d)))?'
  '(?=\\W|\$)',
  caseSensitive: false,
);

class DEMonthNameLittleEndianParser
    extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(context) {
    return _pattern;
  }

  @override
  ParsingResult? innerExtract(ParsingContext context, RegExpChronoMatch match) {
    final result = context.createParsingResult(match.index, match[0]);

    final month = MONTH_DICTIONARY[match[3]!.toLowerCase()]!;
    final day = int.parse(match[1]!);
    if (day > 31) {
      match.index = match.index + match[1]!.length;
      return null;
    }

    result.start.assign(Component.month, month);
    result.start.assign(Component.day, day);

    if (match[4] != null) {
      result.start.assign(Component.year, parseYear(match[4]!));
    } else {
      result.start.imply(Component.year,
          findYearClosestToRef(context.reference.instant, day, month));
    }

    if (match[2] != null) {
      result.end = result.start.clone();
      result.end!.assign(Component.day, int.parse(match[2]!));
    }

    return result;
  }
}
