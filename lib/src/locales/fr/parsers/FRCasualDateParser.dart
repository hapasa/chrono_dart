import 'package:day/day.dart' as dayjs;
import '../../../chrono.dart' show ParsingContext;
import '../../../types.dart' show RegExpChronoMatch, Component, Meridiem;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../utils/day.dart' show assignSimilarDate;
import '../../../common/casual_references.dart' as references;

final _pattern = RegExp(
  r"(maintenant|aujourd'hui|demain|hier|cette\s*nuit|la\s*veille)(?=\W|$)",
  caseSensitive: false,
);

class FRCasualDateParser extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(ParsingContext context) {
    return _pattern;
  }

  @override
  innerExtract(ParsingContext context, RegExpChronoMatch match) {
    final targetDate = dayjs.Day.fromDateTime(context.reference.instant);
    final lowerText = match[0]!.toLowerCase();
    var component = context.createParsingComponents();

    switch (lowerText) {
      case 'maintenant':
        component = references.now(context.reference);
        break;
      case "aujourd'hui":
        component = references.today(context.reference);
        break;
      case 'hier':
        component = references.yesterday(context.reference);
        break;
      case 'demain':
        component = references.tomorrow(context.reference);
        break;
      default:
        if (RegExp(r'cette\s*nuit').hasMatch(lowerText)) {
          assignSimilarDate(component, targetDate);
          component.imply(Component.hour, 22);
          component.imply(Component.meridiem, Meridiem.PM.id);
        } else if (RegExp(r'la\s*veille').hasMatch(lowerText)) {
          final previousDay = targetDate.add(-1, 'd')!;
          assignSimilarDate(component, previousDay);
          component.imply(Component.hour, 0);
        }
    }

    return component.addTag('parser/FRCasualDateParser');
  }
}
