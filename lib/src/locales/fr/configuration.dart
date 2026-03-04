import '../../chrono.dart' show Configuration;

import './parsers/FRMonthNameLittleEndianParser.dart';
import './parsers/FRTimeExpressionParser.dart';
import './parsers/FRSpecificTimeExpressionParser.dart';
import './parsers/FRTimeUnitAgoFormatParser.dart';
import './parsers/FRTimeUnitWithinFormatParser.dart';
import './parsers/FRWeekdayParser.dart';
import './refiners/FRMergeDateTimeRefiner.dart';
import './refiners/FRMergeDateRangeRefiner.dart';

import '../../configurations.dart' show includeCommonConfiguration;
import './parsers/FRCasualDateParser.dart';
import './parsers/FRCasualTimeParser.dart';
import './parsers/FRTimeUnitRelativeFormatParser.dart';

import '../../common/parsers/SlashDateFormatParser.dart';

class FRDefaultConfiguration {
  const FRDefaultConfiguration();

  /// Create a default *casual* [Configuration] for French chrono.
  /// It calls [createConfiguration] and includes additional parsers.
  Configuration createCasualConfiguration([bool littleEndian = true]) {
    final option = createConfiguration(false, littleEndian);
    option.parsers.insert(0, FRCasualDateParser());
    option.parsers.insert(0, FRCasualTimeParser());
    option.parsers.insert(0, FRTimeUnitRelativeFormatParser());
    return option;
  }

  /// Create a default [Configuration] for French chrono
  ///
  /// @param strictMode If the timeunit mentioning should be strict, not casual
  /// @param littleEndian If format should be date-first/littleEndian (default true for French)
  Configuration createConfiguration(
      [bool strictMode = true, bool littleEndian = true]) {
    final options = includeCommonConfiguration(
      Configuration(
        parsers: [
          SlashDateFormatParser(littleEndian),
          FRMonthNameLittleEndianParser(),
          FRTimeExpressionParser(strictMode),
          FRSpecificTimeExpressionParser(),
          FRTimeUnitAgoFormatParser(),
          FRTimeUnitWithinFormatParser(),
          FRWeekdayParser(),
        ],
        refiners: [FRMergeDateTimeRefiner(), FRMergeDateRangeRefiner()],
      ),
      strictMode,
    );
    return options;
  }
}
