// ignore_for_file: constant_identifier_names

import '../../../chrono.dart' show ParsingContext;
import '../../../types.dart' show RegExpChronoMatch;
import '../constants.dart'
    show
        NUMBER_PATTERN,
        parseNumberPattern,
        TIME_UNIT_DICTIONARY;
import '../../../results.dart' show ParsingComponents;
import '../../../utils/pattern.dart' show matchAnyPattern;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../utils/timeunits.dart' show reverseTimeUnits;

final _pattern = RegExp(
  // ignore: prefer_interpolation_to_compose_strings
  "(?:les?|la|l'|du|des?)\\s*" +
      '($NUMBER_PATTERN)?' +
      '(?:\\s*(prochaine?s?|derni[eè]re?s?|pass[ée]e?s?|pr[ée]c[ée]dents?|suivante?s?))?' +
      '\\s*(${matchAnyPattern(TIME_UNIT_DICTIONARY)})' +
      '(?:\\s*(prochaine?s?|derni[eè]re?s?|pass[ée]e?s?|pr[ée]c[ée]dents?|suivante?s?))?',
  caseSensitive: false,
);

const _NUM_GROUP = 1;
const _PREFIX_MODIFIER_GROUP = 2;
const _UNIT_GROUP = 3;
const _POSTFIX_MODIFIER_GROUP = 4;

class FRTimeUnitRelativeFormatParser
    extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(context) {
    return _pattern;
  }

  @override
  innerExtract(ParsingContext context, RegExpChronoMatch match) {
    final number = match[_NUM_GROUP] != null
        ? parseNumberPattern(match[_NUM_GROUP]!)
        : 1.0;
    final unit = TIME_UNIT_DICTIONARY[match[_UNIT_GROUP]!.toLowerCase()]!;
    Map<String, num> timeUnits = {unit: number};

    // Modifier
    var modifier = match[_PREFIX_MODIFIER_GROUP] ??
        match[_POSTFIX_MODIFIER_GROUP] ??
        '';
    modifier = modifier.toLowerCase();
    if (modifier.isEmpty) {
      return null;
    }

    if (RegExp(r'derni[eè]re?s?').hasMatch(modifier) ||
        RegExp(r'pass[ée]e?s?').hasMatch(modifier) ||
        RegExp(r'pr[ée]c[ée]dents?').hasMatch(modifier)) {
      timeUnits = reverseTimeUnits(timeUnits);
    }

    return ParsingComponents.createRelativeFromReference(
        context.reference, timeUnits);
  }
}
