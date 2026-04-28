/// Chrono components for German support (*parsers*, *refiners*, and *configuration*)

import '../../../chrono_dart.dart' show ChronoInstance;
import '../../types.dart' show ParsedResult, ParsingOption;
import './configuration.dart';

final deConfig = DEDefaultConfiguration();

final casual = ChronoInstance(deConfig.createCasualConfiguration(true));

final strict = ChronoInstance(deConfig.createConfiguration(true, true));

class DENamespace {
  ChronoInstance get casual => _casual;
  ChronoInstance get strict => _strict;

  List<ParsedResult> parse(String text,
      [DateTime? ref, ParsingOption? option]) {
    return _casual.parse(text, ref, option);
  }

  DateTime? parseDate(String text, DateTime ref, ParsingOption option) {
    return _casual.parseDate(text, ref, option);
  }
}

final _casual = casual;
final _strict = strict;

final de = DENamespace();

List<ParsedResult> parse(String text, [DateTime? ref, ParsingOption? option]) {
  return casual.parse(text, ref, option);
}

DateTime? parseDate(String text, DateTime ref, ParsingOption option) {
  return casual.parseDate(text, ref, option);
}
