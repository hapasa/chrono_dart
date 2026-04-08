import '../../../chrono.dart' show ParsingContext;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../results.dart' show ParsingComponents;
import '../../../types.dart' show RegExpChronoMatch;
import '../../../utils/timeunits.dart' show reverseTimeUnits;
import '../constants.dart'
    show TIME_UNITS_NO_ABBR_PATTERN, TIME_UNITS_PATTERN, parseDuration;

final _pattern = RegExp(
  '(denne|den\s+h[æe]r|forrige|sidste|n[æe]ste|kommende|efter|\\+|-)\\s*($TIME_UNITS_PATTERN)(?=\\W|\$)',
  caseSensitive: false,
);

final _patternNoAbbr = RegExp(
  '(denne|den\s+h[æe]r|forrige|sidste|n[æe]ste|kommende|efter|\\+|-)\\s*($TIME_UNITS_NO_ABBR_PATTERN)(?=\\W|\$)',
  caseSensitive: false,
);

class DATimeUnitCasualRelativeFormatParser
    extends AbstractParserWithWordBoundaryChecking {
  final bool allowAbbreviations;

  DATimeUnitCasualRelativeFormatParser([this.allowAbbreviations = true]);

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
      case 'forrige':
      case 'sidste':
      case '-':
        duration = reverseTimeUnits(duration);
        break;
    }

    return ParsingComponents.createRelativeFromReference(
        context.reference, duration);
  }
}

