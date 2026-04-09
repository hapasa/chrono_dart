/// Chrono components for Swedish support (*parsers* and *configuration*)

import '../../../chrono_dart.dart' show ChronoInstance;
import '../../types.dart' show ParsedResult, ParsingOption;
import './configuration.dart';

final svConfig = SVDefaultConfiguration();

/// Chrono object configured for parsing *casual* Swedish
final casual = ChronoInstance(svConfig.createCasualConfiguration(true));

/// ChronoInstance object configured for parsing *strict* Swedish
final strict = ChronoInstance(svConfig.createConfiguration(true, true));

class SVNamespace {
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

/// Namespaced Swedish locale API for top-level export.
final sv = SVNamespace();

/// A shortcut for sv.casual.parse()
List<ParsedResult> parse(String text, [DateTime? ref, ParsingOption? option]) {
  return casual.parse(text, ref, option);
}

/// A shortcut for sv.casual.parseDate()
DateTime? parseDate(String text, DateTime ref, ParsingOption option) {
  return casual.parseDate(text, ref, option);
}

