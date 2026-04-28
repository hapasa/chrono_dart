import '../../chrono.dart' show Configuration;
import '../../configurations.dart' show includeCommonConfiguration;
import '../../common/parsers/SlashDateFormatParser.dart';
import './parsers/DECasualDateParser.dart';
import './parsers/DECasualTimeParser.dart';
import './parsers/DEMonthNameLittleEndianParser.dart';
import './parsers/DESpecificTimeExpressionParser.dart';
import './parsers/DETimeExpressionParser.dart';
import './parsers/DETimeUnitRelativeFormatParser.dart';
import './parsers/DETimeUnitWithinFormatParser.dart';
import './parsers/DEWeekdayParser.dart';
import './refiners/DEMergeDateRangeRefiner.dart';
import './refiners/DEMergeDateTimeRefiner.dart';

class DEDefaultConfiguration {
  const DEDefaultConfiguration();

  Configuration createCasualConfiguration([bool littleEndian = true]) {
    final option = createConfiguration(false, littleEndian);
    option.parsers.insert(0, DECasualTimeParser());
    option.parsers.insert(0, DECasualDateParser());
    option.parsers.insert(0, DETimeUnitRelativeFormatParser());
    return option;
  }

  Configuration createConfiguration(
      [bool strictMode = true, bool littleEndian = true]) {
    return includeCommonConfiguration(
      Configuration(
        parsers: [
          SlashDateFormatParser(littleEndian),
          DETimeExpressionParser(strictMode),
          DESpecificTimeExpressionParser(),
          DEMonthNameLittleEndianParser(),
          DEWeekdayParser(),
          DETimeUnitWithinFormatParser(),
        ],
        refiners: [DEMergeDateRangeRefiner(), DEMergeDateTimeRefiner()],
      ),
      strictMode,
    );
  }
}
