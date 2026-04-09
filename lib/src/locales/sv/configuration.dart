import '../../chrono.dart' show Configuration;
import '../../configurations.dart' show includeCommonConfiguration;
import '../../common/parsers/SlashDateFormatParser.dart';
import './parsers/SVCasualDateParser.dart';
import './parsers/SVMonthNameLittleEndianParser.dart';
import './parsers/SVTimeUnitCasualRelativeFormatParser.dart';
import './parsers/SVWeekdayParser.dart';

class SVDefaultConfiguration {
  const SVDefaultConfiguration();

  Configuration createCasualConfiguration([bool littleEndian = true]) {
    final option = createConfiguration(false, littleEndian);
    option.parsers.insert(0, SVCasualDateParser());
    return option;
  }

  Configuration createConfiguration(
      [bool strictMode = true, bool littleEndian = true]) {
    return includeCommonConfiguration(
      Configuration(
        parsers: [
          SlashDateFormatParser(littleEndian),
          SVMonthNameLittleEndianParser(),
          SVWeekdayParser(),
          SVTimeUnitCasualRelativeFormatParser(),
        ],
        refiners: [],
      ),
      strictMode,
    );
  }
}

