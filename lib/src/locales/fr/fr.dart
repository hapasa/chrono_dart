/// Chrono components for French support (*parsers*, *refiners*, and *configuration*)
///
/// @module

import '../../../chrono_dart.dart' show ChronoInstance;
import '../../types.dart' show ParsedResult, ParsingOption;

import './configuration.dart';

final frConfig = FRDefaultConfiguration();

/// Chrono object configured for parsing *casual* French
final casual = ChronoInstance(frConfig.createCasualConfiguration(true));

/// ChronoInstance object configured for parsing *strict* French
final strict = ChronoInstance(frConfig.createConfiguration(true, true));

/// A shortcut for fr.casual.parse()
List<ParsedResult> parse(String text, [DateTime? ref, ParsingOption? option]) {
  return casual.parse(text, ref, option);
}

/// A shortcut for fr.casual.parseDate()
DateTime? parseDate(String text, DateTime ref, ParsingOption option) {
  return casual.parseDate(text, ref, option);
}
