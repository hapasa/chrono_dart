// ignore_for_file: prefer_interpolation_to_compose_strings, constant_identifier_names

import '../../../calculation/years.dart' show findYearClosestToRef;
import '../../../chrono.dart' show ParsingContext;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../results.dart' show ParsingResult;
import '../../../types.dart' show Component, RegExpChronoMatch;
import '../../../utils/pattern.dart' show matchAnyPattern;
import '../constants.dart'
    show
        MONTH_DICTIONARY,
        ORDINAL_NUMBER_PATTERN,
        YEAR_PATTERN,
        parseOrdinalNumberPattern,
        parseYear;

final _pattern = RegExp(
  '(?:den\\s*?)?' +
      '($ORDINAL_NUMBER_PATTERN)' +
      '(?:\\s*(?:til|\\-|\\u2013|\\s)\\s*($ORDINAL_NUMBER_PATTERN))?\\s*' +
      '(${matchAnyPattern(MONTH_DICTIONARY)})' +
      '(?:(?:-|/|,?\\s*)($YEAR_PATTERN(?![^\\s]\\d)))?' +
      '(?=\\W|\$)',
  caseSensitive: false,
);

const _DATE_GROUP = 1;
const _DATE_TO_GROUP = 2;
const _MONTH_NAME_GROUP = 3;
const _YEAR_GROUP = 4;

class DAMonthNameLittleEndianParser
    extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(context) {
    return _pattern;
  }

  @override
  ParsingResult? innerExtract(ParsingContext context, RegExpChronoMatch match) {
    final result = context.createParsingResult(match.index, match[0]);

    final month = MONTH_DICTIONARY[match[_MONTH_NAME_GROUP]!.toLowerCase()]!;
    final day = parseOrdinalNumberPattern(match[_DATE_GROUP]!);
    if (day > 31) {
      match.index = match.index + match[_DATE_GROUP]!.length;
      return null;
    }

    result.start.assign(Component.month, month);
    result.start.assign(Component.day, day);

    if (match[_YEAR_GROUP] != null) {
      final yearNumber = parseYear(match[_YEAR_GROUP]!);
      result.start.assign(Component.year, yearNumber);
    } else {
      final year = findYearClosestToRef(context.reference.instant, day, month);
      result.start.imply(Component.year, year);
    }

    if (match[_DATE_TO_GROUP] != null) {
      final endDate = parseOrdinalNumberPattern(match[_DATE_TO_GROUP]!);
      result.end = result.start.clone();
      result.end!.assign(Component.day, endDate);
    }

    return result;
  }
}

