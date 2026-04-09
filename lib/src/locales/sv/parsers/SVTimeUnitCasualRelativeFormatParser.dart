import '../../../chrono.dart' show ParsingContext;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../results.dart' show ParsingComponents;
import '../../../types.dart' show RegExpChronoMatch;
import '../../../utils/timeunits.dart' show reverseTimeUnits;
import '../constants.dart'
    show TIME_UNITS_NO_ABBR_PATTERN, TIME_UNITS_PATTERN, parseDuration;

final _pattern = RegExp(
  '(denna|den\\s+här|förra|passerade|nästa|kommande|efter|\\+|-)\\s*($TIME_UNITS_PATTERN)(?=\\W|\$)',
  caseSensitive: false,
);

final _patternNoAbbr = RegExp(
  '(denna|den\\s+här|förra|passerade|nästa|kommande|efter|\\+|-)\\s*($TIME_UNITS_NO_ABBR_PATTERN)(?=\\W|\$)',
  caseSensitive: false,
);

class SVTimeUnitCasualRelativeFormatParser
    extends AbstractParserWithWordBoundaryChecking {
  final bool allowAbbreviations;

  SVTimeUnitCasualRelativeFormatParser([this.allowAbbreviations = true]);

  @override
  RegExp innerPattern(context) {
    return allowAbbreviations ? _pattern : _patternNoAbbr;
  }

  @override
  ParsingComponents? innerExtract(
      ParsingContext context, RegExpChronoMatch match) {
    final prefix = match[1]!.toLowerCase();
    var duration = parseDuration(match[2]!, allowAbbreviations);
    if (duration.isEmpty) {
      return null;
    }

    switch (prefix) {
      case 'förra':
      case 'passerade':
      case '-':
        duration = reverseTimeUnits(duration);
        break;
    }

    return ParsingComponents.createRelativeFromReference(
        context.reference, duration);
  }
}

