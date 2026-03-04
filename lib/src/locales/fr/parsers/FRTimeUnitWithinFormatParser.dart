import '../../../chrono.dart' show ParsingContext;
import '../../../types.dart' show RegExpChronoMatch;
import '../constants.dart' show parseDuration, TIME_UNITS_PATTERN;
import '../../../results.dart' show ParsingComponents;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';

final _pattern = RegExp(
  '(?:dans|en|pour|pendant|de)\\s*($TIME_UNITS_PATTERN)(?=\\W|\$)',
  caseSensitive: false,
);

class FRTimeUnitWithinFormatParser
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
