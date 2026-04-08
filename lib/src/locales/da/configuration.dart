import '../../chrono.dart' show Configuration;
import '../../configurations.dart' show includeCommonConfiguration;
import '../../common/parsers/SlashDateFormatParser.dart';
import './parsers/DACasualDateParser.dart';
import './parsers/DAMonthNameLittleEndianParser.dart';
import './parsers/DATimeUnitCasualRelativeFormatParser.dart';
import './parsers/DAWeekdayParser.dart';

class DADefaultConfiguration {
  const DADefaultConfiguration();

  Configuration createCasualConfiguration([bool littleEndian = true]) {
    final option = createConfiguration(false, littleEndian);
    option.parsers.insert(0, DACasualDateParser());
    return option;
  }

  Configuration createConfiguration(
      [bool strictMode = true, bool littleEndian = true]) {
    return includeCommonConfiguration(
      Configuration(
        parsers: [
          SlashDateFormatParser(littleEndian),
          DAMonthNameLittleEndianParser(),
          DAWeekdayParser(),
          DATimeUnitCasualRelativeFormatParser(),
        ],
        refiners: [],
      ),
      strictMode,
    );
  }
}

