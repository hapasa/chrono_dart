import '../../../chrono.dart' show ParsingContext;
import '../../../common/casual_references.dart' as references;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../types.dart' show Component, RegExpChronoMatch;

final _pattern = RegExp(
  r'(nu|i\s*dag|idag|i\s*morgen|imorgen|overmorgen|i\s*overmorgen|i\s*går|igår|forgårs|i\s*forgårs)(?:\s*(?:om\s*)?(morgenen?|formiddagen?|middagen?|eftermiddagen?|aftenen?|natten?|midnat))?(?=\W|$)',
  caseSensitive: false,
);

const _DATE_GROUP = 1;
const _TIME_GROUP = 2;

class DACasualDateParser extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(ParsingContext context) {
    return _pattern;
  }

  @override
  innerExtract(ParsingContext context, RegExpChronoMatch match) {
    final dateKeyword = (match[_DATE_GROUP] ?? '').toLowerCase();
    final timeKeyword = (match[_TIME_GROUP] ?? '').toLowerCase();

    var component = context.createParsingComponents();

    switch (dateKeyword) {
      case 'nu':
        component = references.now(context.reference);
        break;
      case 'i dag':
      case 'idag':
        component = references.today(context.reference);
        break;
      case 'i morgen':
      case 'imorgen':
        component = references.tomorrow(context.reference);
        break;
      case 'overmorgen':
      case 'i overmorgen':
        component = references.theDayAfter(context.reference, 2);
        break;
      case 'i går':
      case 'igår':
        component = references.yesterday(context.reference);
        break;
      case 'forgårs':
      case 'i forgårs':
        component = references.theDayBefore(context.reference, 2);
        break;
    }

    switch (timeKeyword) {
      case 'morgen':
      case 'morgenen':
        component.imply(Component.hour, 6);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.millisecond, 0);
        break;
      case 'formiddag':
      case 'formiddagen':
        component.imply(Component.hour, 9);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.millisecond, 0);
        break;
      case 'middag':
      case 'middagen':
        component.imply(Component.hour, 12);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.millisecond, 0);
        break;
      case 'eftermiddag':
      case 'eftermiddagen':
        component.imply(Component.hour, 15);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.millisecond, 0);
        break;
      case 'aften':
      case 'aftenen':
        component.imply(Component.hour, 20);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.millisecond, 0);
        break;
      case 'nat':
      case 'natten':
        component.imply(Component.hour, 2);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.millisecond, 0);
        break;
      case 'midnat':
        component.imply(Component.hour, 0);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.millisecond, 0);
        break;
    }

    return component;
  }
}

