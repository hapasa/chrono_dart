// ignore_for_file: constant_identifier_names

import '../../../chrono.dart' show Parser, ParsingContext;
import '../../../results.dart' show ParsingComponents;
import '../../../types.dart' show RegExpChronoMatch, Component, Meridiem;

/// Parses French specific time formats like:
/// 8h10m00s, 8h10m00, 8h10, 14h
final _FIRST_REG_PATTERN = RegExp(
  // ignore: prefer_interpolation_to_compose_strings
  '(^|\\s|T)' +
      '(?:(?:[àa])\\s*)?' +
      '(\\d{1,2})(?:h|:)?' +
      '(?:(\\d{1,2})(?:m|:)?)?' +
      '(?:(\\d{1,2})(?:s|:)?)?' +
      '(?:\\s*(A\\.M\\.|P\\.M\\.|AM?|PM?))?' +
      '(?=\\W|\$)',
  caseSensitive: false,
);

final _SECOND_REG_PATTERN = RegExp(
  // ignore: prefer_interpolation_to_compose_strings
  '^\\s*(\\-|\u2013|\\~|\u301C|[àa]|\\?)\\s*' +
      '(\\d{1,2})(?:h|:)?' +
      '(?:(\\d{1,2})(?:m|:)?)?' +
      '(?:(\\d{1,2})(?:s|:)?)?' +
      '(?:\\s*(A\\.M\\.|P\\.M\\.|AM?|PM?))?' +
      '(?=\\W|\$)',
  caseSensitive: false,
);

const _HOUR_GROUP = 2;
const _MINUTE_GROUP = 3;
const _SECOND_GROUP = 4;
const _AM_PM_HOUR_GROUP = 5;

class FRSpecificTimeExpressionParser implements Parser {
  @override
  RegExp pattern(ParsingContext context) {
    return _FIRST_REG_PATTERN;
  }

  @override
  extract(ParsingContext context, RegExpChronoMatch match) {
    final result = context.createParsingResult(
      match.index + match[1]!.length,
      match[0]!.substring(match[1]!.length),
    );

    // This looks more like a year e.g. 2020
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
    final secondMatch = _SECOND_REG_PATTERN.firstMatch(remainingText);
    if (secondMatch != null) {
      final secondChronoMatch = RegExpChronoMatch(secondMatch);
      result.end = _extractTimeComponent(result.start.clone(), secondChronoMatch);
      if (result.end != null) {
        result.text += secondMatch[0]!;
      }
    }

    return result;
  }

  static ParsingComponents? _extractTimeComponent(
      ParsingComponents extractingComponents, dynamic match) {
    int hour = 0;
    int minute = 0;
    int? meridiem;

    // ----- Hours
    hour = int.parse(match[_HOUR_GROUP]!);

    // ----- Minutes
    if (match[_MINUTE_GROUP] != null) {
      minute = int.parse(match[_MINUTE_GROUP]!);
    }

    if (minute >= 60 || hour > 24) {
      return null;
    }

    if (hour >= 12) {
      meridiem = Meridiem.PM.id;
    }

    // ----- AM & PM
    if (match[_AM_PM_HOUR_GROUP] != null) {
      if (hour > 12) return null;
      final ampm = match[_AM_PM_HOUR_GROUP]![0].toLowerCase();
      if (ampm == 'a') {
        meridiem = Meridiem.AM.id;
        if (hour == 12) {
          hour = 0;
        }
      }

      if (ampm == 'p') {
        meridiem = Meridiem.PM.id;
        if (hour != 12) {
          hour += 12;
        }
      }
    }

    extractingComponents.assign(Component.hour, hour);
    extractingComponents.assign(Component.minute, minute);
    if (meridiem != null) {
      extractingComponents.assign(Component.meridiem, meridiem);
    } else {
      if (hour < 12) {
        extractingComponents.imply(Component.meridiem, Meridiem.AM.id);
      } else {
        extractingComponents.imply(Component.meridiem, Meridiem.PM.id);
      }
    }

    // ----- Second
    if (match[_SECOND_GROUP] != null) {
      final second = int.parse(match[_SECOND_GROUP]!);
      if (second >= 60) return null;

      extractingComponents.assign(Component.second, second);
    }

    return extractingComponents;
  }
}
