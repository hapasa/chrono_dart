/// Chrono components for Danish support (*parsers* and *configuration*)

import '../../../chrono_dart.dart' show ChronoInstance;
import '../../types.dart' show ParsedResult, ParsingOption;
import './configuration.dart';

final daConfig = DADefaultConfiguration();

/// Chrono object configured for parsing *casual* Danish
final casual = ChronoInstance(daConfig.createCasualConfiguration(true));

/// ChronoInstance object configured for parsing *strict* Danish
final strict = ChronoInstance(daConfig.createConfiguration(true, true));

class DANamespace {
  ChronoInstance get casual => _casual;
  ChronoInstance get strict => _strict;

  List<ParsedResult> parse(String text, [DateTime? ref, ParsingOption? option]) {
    return _casual.parse(text, ref, option);
  }

  DateTime? parseDate(String text, DateTime ref, ParsingOption option) {
    return _casual.parseDate(text, ref, option);
  }
}

final _casual = casual;
final _strict = strict;

/// Namespaced Danish locale API for top-level export.
final da = DANamespace();

/// A shortcut for da.casual.parse()
List<ParsedResult> parse(String text, [DateTime? ref, ParsingOption? option]) {
  return casual.parse(text, ref, option);
}

/// A shortcut for da.casual.parseDate()
DateTime? parseDate(String text, DateTime ref, ParsingOption option) {
  return casual.parseDate(text, ref, option);
}
