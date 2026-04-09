import '../../../chrono.dart' show ParsingContext;
import '../../../common/casual_references.dart' as references;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../types.dart' show Component, RegExpChronoMatch;

final _pattern = RegExp(
  r'(nu|idag|imorgon|imorn|övermorgon|igår|förrgår|i\s*förrgår)(?:\s*(?:på\s*|vid\s*)?(morgonen?|förmiddagen?|middagen?|eftermiddagen?|kvällen?|natten?|midnatt))?(?=\W|$)',
  caseSensitive: false,
);

const _DATE_GROUP = 1;
const _TIME_GROUP = 2;

class SVCasualDateParser extends AbstractParserWithWordBoundaryChecking {
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
      case 'idag':
        component = references.today(context.reference);
        break;
      case 'imorgon':
      case 'imorn':
        component = references.tomorrow(context.reference);
        break;
      case 'övermorgon':
        component = references.theDayAfter(context.reference, 2);
        break;
      case 'igår':
        component = references.yesterday(context.reference);
        break;
      case 'förrgår':
      case 'i förrgår':
        component = references.theDayBefore(context.reference, 2);
        break;
    }

    switch (timeKeyword) {
      case 'morgon':
      case 'morgonen':
        component.imply(Component.hour, 6);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.millisecond, 0);
        break;
      case 'förmiddag':
      case 'förmiddagen':
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
      case 'kväll':
      case 'kvällen':
        component.imply(Component.hour, 20);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.millisecond, 0);
        break;
      case 'natt':
      case 'natten':
        component.imply(Component.hour, 2);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.millisecond, 0);
        break;
      case 'midnatt':
        component.imply(Component.hour, 0);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.millisecond, 0);
        break;
    }

    return component;
  }
}

