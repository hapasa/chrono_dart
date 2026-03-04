import '../../../chrono.dart' show ParsingContext;
import '../../../types.dart' show RegExpChronoMatch;
import '../constants.dart' show parseDuration, TIME_UNITS_PATTERN;
import '../../../results.dart' show ParsingComponents;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../utils/timeunits.dart' show reverseTimeUnits;

final _pattern = RegExp(
  'il y a\\s*($TIME_UNITS_PATTERN)(?=(?:\\W|\$))',
  caseSensitive: false,
);

class FRTimeUnitAgoFormatParser extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(context) {
    return _pattern;
  }

  @override
  innerExtract(ParsingContext context, RegExpChronoMatch match) {
    final timeUnits = parseDuration(match[1]!);
    final outputTimeUnits = reverseTimeUnits(timeUnits);

    return ParsingComponents.createRelativeFromReference(
        context.reference, outputTimeUnits);
  }
}
