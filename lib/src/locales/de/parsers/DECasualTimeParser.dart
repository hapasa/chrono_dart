import 'package:day/day.dart' as dayjs;

import '../../../chrono.dart' show ParsingContext;
import '../../../types.dart' show RegExpChronoMatch, Component, Meridiem;
import '../../../results.dart' show ParsingComponents;
import '../../../common/parsers/AbstractParserWithWordBoundary.dart';
import '../../../utils/day.dart' show implySimilarTime;

final _pattern = RegExp(
  r'(diesen)?\s*(morgen|vormittag|mittags?|nachmittag|abend|nacht|mitternacht)(?=\W|$)',
  caseSensitive: false,
);

class DECasualTimeParser extends AbstractParserWithWordBoundaryChecking {
  @override
  RegExp innerPattern(context) {
    return _pattern;
  }

  @override
  innerExtract(ParsingContext context, RegExpChronoMatch match) {
    final targetDate = context.reference.instant;
    final timeKeywordPattern = match[2]!.toLowerCase();
    final component = context.createParsingComponents();
    implySimilarTime(component, dayjs.Day.fromDateTime(targetDate));
    return extractTimeComponents(component, timeKeywordPattern)
        .addTag('parser/DECasualTimeParser');
  }

  static ParsingComponents extractTimeComponents(
      ParsingComponents component, String timeKeywordPattern) {
    switch (timeKeywordPattern) {
      case 'morgen':
        component.imply(Component.hour, 6);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.meridiem, Meridiem.AM.id);
        break;
      case 'vormittag':
        component.imply(Component.hour, 9);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.meridiem, Meridiem.AM.id);
        break;
      case 'mittag':
      case 'mittags':
        component.imply(Component.hour, 12);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.meridiem, Meridiem.AM.id);
        break;
      case 'nachmittag':
        component.imply(Component.hour, 15);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.meridiem, Meridiem.PM.id);
        break;
      case 'abend':
        component.imply(Component.hour, 18);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.meridiem, Meridiem.PM.id);
        break;
      case 'nacht':
        component.imply(Component.hour, 22);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.meridiem, Meridiem.PM.id);
        break;
      case 'mitternacht':
        if ((component.get(Component.hour) ?? 12) > 1) {
          component.imply(Component.day, component.dayjs().add(1, 'd')!.date());
          component.imply(
              Component.month, component.dayjs().add(1, 'd')!.month());
          component.imply(
              Component.year, component.dayjs().add(1, 'd')!.year());
        }
        component.imply(Component.hour, 0);
        component.imply(Component.minute, 0);
        component.imply(Component.second, 0);
        component.imply(Component.meridiem, Meridiem.AM.id);
        break;
    }
    return component;
  }
}
