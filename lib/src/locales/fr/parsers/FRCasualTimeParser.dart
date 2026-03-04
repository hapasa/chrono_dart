import '../../../chrono.dart' show ParsingContext;
import '../../../types.dart' show RegExpChronoMatch, Component, Meridiem;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';

final _pattern = RegExp(
  r'(cet?)?\s*(matin|soir|après-midi|aprem|a midi|à minuit)(?=\W|$)',
  caseSensitive: false,
);

class FRCasualTimeParser extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(context) {
    return _pattern;
  }

  @override
  innerExtract(ParsingContext context, RegExpChronoMatch match) {
    final suffixLower = match[2]!.toLowerCase();
    final component = context.createParsingComponents();

    switch (suffixLower) {
      case 'après-midi':
      case 'aprem':
        component.imply(Component.hour, 14);
        component.imply(Component.minute, 0);
        component.imply(Component.meridiem, Meridiem.PM.id);
        break;
      case 'soir':
        component.imply(Component.hour, 18);
        component.imply(Component.minute, 0);
        component.imply(Component.meridiem, Meridiem.PM.id);
        break;
      case 'matin':
        component.imply(Component.hour, 8);
        component.imply(Component.minute, 0);
        component.imply(Component.meridiem, Meridiem.AM.id);
        break;
      case 'a midi':
        component.imply(Component.hour, 12);
        component.imply(Component.minute, 0);
        component.imply(Component.meridiem, Meridiem.AM.id);
        break;
      case 'à minuit':
        component.imply(Component.hour, 0);
        component.imply(Component.meridiem, Meridiem.AM.id);
        break;
    }

    return component.addTag('parser/FRCasualTimeParser');
  }
}
