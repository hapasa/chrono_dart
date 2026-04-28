import 'package:day/day.dart' as dayjs;
import '../../../chrono.dart' show ParsingContext;
import '../../../types.dart' show RegExpChronoMatch, Component;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../utils/day.dart' show assignSimilarDate, implySimilarTime;
import '../../../common/casual_references.dart' as references;
import './DECasualTimeParser.dart';

final _pattern = RegExp(
  r'(jetzt|heute|morgen|übermorgen|uebermorgen|gestern|vorgestern|letzte\s*nacht)(?:\s*(morgen|vormittag|mittags?|nachmittag|abend|nacht|mitternacht))?(?=\W|$)',
  caseSensitive: false,
);

class DECasualDateParser extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(ParsingContext context) {
    return _pattern;
  }

  @override
  innerExtract(ParsingContext context, RegExpChronoMatch match) {
    var targetDate = dayjs.Day.fromDateTime(context.reference.instant);
    final dateKeyword = match[1]!.toLowerCase();
    final timeKeyword = match[2]?.toLowerCase();
    var component = context.createParsingComponents();

    switch (dateKeyword) {
      case 'jetzt':
        component = references.now(context.reference);
        break;
      case 'heute':
        component = references.today(context.reference);
        break;
      case 'morgen':
        component = references.tomorrow(context.reference);
        break;
      case 'übermorgen':
      case 'uebermorgen':
        component = references.theDayAfter(context.reference, 2);
        break;
      case 'gestern':
        component = references.yesterday(context.reference);
        break;
      case 'vorgestern':
        component = references.theDayBefore(context.reference, 2);
        break;
      default:
        if (RegExp(r'letzte\s*nacht').hasMatch(dateKeyword)) {
          if (targetDate.hour() > 6) {
            targetDate = targetDate.add(-1, 'd')!;
          }
          assignSimilarDate(component, targetDate);
          component.imply(Component.hour, 0);
        }
    }

    if (timeKeyword != null) {
      component =
          DECasualTimeParser.extractTimeComponents(component, timeKeyword);
    }

    return component.addTag('parser/DECasualDateParser');
  }
}
