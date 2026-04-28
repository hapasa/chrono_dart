import '../../../chrono.dart' show Parser, ParsingContext;
import '../../../results.dart' show ParsingComponents;
import '../../../types.dart' show RegExpChronoMatch, Component, Meridiem;

final _firstRegPattern = RegExp(
  '(^|\\s|T)'
  '(?:(?:um|von)\\s*)?'
  '(\\d{1,2})(?:h|:)?'
  '(?:(\\d{1,2})(?:m|:)?)?'
  '(?:(\\d{1,2})(?:s)?)?'
  '(?:\\s*Uhr)?'
  '(?:\\s*(morgens|vormittags|nachmittags|abends|nachts|am\\s+(?:Morgen|Vormittag|Nachmittag|Abend)|in\\s+der\\s+Nacht))?'
  '(?=\\W|\$)',
  caseSensitive: false,
);

final _secondRegPattern = RegExp(
  '^\\s*(\\-|\\u2013|\\~|\\u301C|bis(?:\\s+um)?|\\?)\\s*'
  '(\\d{1,2})(?:h|:)?'
  '(?:(\\d{1,2})(?:m|:)?)?'
  '(?:(\\d{1,2})(?:s)?)?'
  '(?:\\s*Uhr)?'
  '(?:\\s*(morgens|vormittags|nachmittags|abends|nachts|am\\s+(?:Morgen|Vormittag|Nachmittag|Abend)|in\\s+der\\s+Nacht))?'
  '(?=\\W|\$)',
  caseSensitive: false,
);

class DESpecificTimeExpressionParser implements Parser {
  @override
  RegExp pattern(ParsingContext context) => _firstRegPattern;

  @override
  extract(ParsingContext context, RegExpChronoMatch match) {
    final result = context.createParsingResult(
      match.index + match[1]!.length,
      match[0]!.substring(match[1]!.length),
    );

    if (RegExp(r'^\d{4}$').hasMatch(result.text)) {
      match.index += match[0]!.length;
      return null;
    }

    final startComponents = _extractTimeComponent(result.start.clone(), match);
    if (startComponents == null) {
      match.index += match[0]!.length;
      return null;
    }
    result.start = startComponents;

    final remainingText =
        context.text.substring(match.index + match[0]!.length);
    final secondMatch = _secondRegPattern.firstMatch(remainingText);
    if (secondMatch != null) {
      final secondChronoMatch = RegExpChronoMatch(secondMatch);
      result.end =
          _extractTimeComponent(result.start.clone(), secondChronoMatch);
      if (result.end != null) {
        result.text += secondMatch[0]!;
      }
    }

    return result;
  }

  static ParsingComponents? _extractTimeComponent(
      ParsingComponents extractingComponents, dynamic match) {
    var hour = int.parse(match[2]!);
    var minute = 0;
    int? meridiem;

    if (match[3] != null) {
      minute = int.parse(match[3]!);
    }
    if (minute >= 60 || hour > 24) {
      return null;
    }

    if (hour >= 12) {
      meridiem = Meridiem.PM.id;
    }

    if (match[5] != null) {
      if (hour > 12) return null;
      final ampm = match[5]!.toLowerCase();
      if (RegExp(r'morgen|vormittag').hasMatch(ampm)) {
        meridiem = Meridiem.AM.id;
        if (hour == 12) {
          hour = 0;
        }
      }
      if (RegExp(r'nachmittag|abend').hasMatch(ampm)) {
        meridiem = Meridiem.PM.id;
        if (hour != 12) {
          hour += 12;
        }
      }
      if (RegExp(r'nacht').hasMatch(ampm)) {
        if (hour == 12) {
          meridiem = Meridiem.AM.id;
          hour = 0;
        } else if (hour < 6) {
          meridiem = Meridiem.AM.id;
        } else {
          meridiem = Meridiem.PM.id;
          hour += 12;
        }
      }
    }

    extractingComponents.assign(Component.hour, hour);
    extractingComponents.assign(Component.minute, minute);
    if (meridiem != null) {
      extractingComponents.assign(Component.meridiem, meridiem);
    } else if (hour < 12) {
      extractingComponents.imply(Component.meridiem, Meridiem.AM.id);
    } else {
      extractingComponents.imply(Component.meridiem, Meridiem.PM.id);
    }

    if (match[4] != null) {
      final second = int.parse(match[4]!);
      if (second >= 60) {
        return null;
      }
      extractingComponents.assign(Component.second, second);
    }

    return extractingComponents;
  }
}
