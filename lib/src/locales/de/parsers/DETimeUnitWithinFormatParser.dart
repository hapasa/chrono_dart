import '../constants.dart' show TIME_UNITS_PATTERN, parseDuration;
import '../../../chrono.dart' show ParsingContext;
import '../../../results.dart' show ParsingComponents;
import '../../../types.dart' show RegExpChronoMatch;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';

final _pattern = RegExp(
  '(?:in|für|während)\\s*($TIME_UNITS_PATTERN)(?=\\W|\$)',
  caseSensitive: false,
);

class DETimeUnitWithinFormatParser
    extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(context) {
    return _pattern;
  }

  @override
  ParsingComponents innerExtract(
      ParsingContext context, RegExpChronoMatch match) {
    final timeUnits = parseDuration(match[1]!);
    return ParsingComponents.createRelativeFromReference(
        context.reference, timeUnits);
  }
}
