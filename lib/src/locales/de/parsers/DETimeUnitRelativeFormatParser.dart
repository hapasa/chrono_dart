import '../../../chrono.dart' show ParsingContext;
import '../../../types.dart' show RegExpChronoMatch;
import '../constants.dart'
    show NUMBER_PATTERN, parseNumberPattern, TIME_UNIT_DICTIONARY;
import '../../../results.dart' show ParsingComponents;
import '../../../utils/pattern.dart' show matchAnyPattern;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../utils/timeunits.dart' show reverseTimeUnits;

final _pattern = RegExp(
  '(?:\\s*((?:nächste|kommende|folgende|letzte|vergangene|vorige|vor(?:her|an)gegangene)(?:s|n|m|r)?|vor|in)\\s*)?'
  '($NUMBER_PATTERN)?'
  '(?:\\s*(nächste|kommende|folgende|letzte|vergangene|vorige|vor(?:her|an)gegangene)(?:s|n|m|r)?)?'
  '\\s*(${matchAnyPattern(TIME_UNIT_DICTIONARY)})(?=\\W|\$)',
  caseSensitive: false,
);

class DETimeUnitRelativeFormatParser
    extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(context) {
    return _pattern;
  }

  @override
  innerExtract(ParsingContext context, RegExpChronoMatch match) {
    final number = match[2] != null ? parseNumberPattern(match[2]!) : 1.0;
    final unit = TIME_UNIT_DICTIONARY[match[4]!.toLowerCase()]!;
    Map<String, num> timeUnits = {unit: number};

    var modifier = match[1] ?? match[3] ?? '';
    modifier = modifier.toLowerCase();
    if (modifier.isEmpty) {
      return null;
    }

    if (RegExp(r'vor').hasMatch(modifier) ||
        RegExp(r'letzte').hasMatch(modifier) ||
        RegExp(r'vergangen').hasMatch(modifier)) {
      timeUnits = reverseTimeUnits(timeUnits);
    }

    return ParsingComponents.createRelativeFromReference(
        context.reference, timeUnits);
  }
}
