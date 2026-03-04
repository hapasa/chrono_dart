import '../../../chrono.dart' show ParsingContext;
import '../../../results.dart' show ParsingComponents;
import '../../../common/parsers/AbstractTimeExpressionParser.dart'
    show AbstractTimeExpressionParser;

class FRTimeExpressionParser extends AbstractTimeExpressionParser {
  FRTimeExpressionParser([super.strictMode]);

  @override
  String primaryPrefix() {
    return r'(?:(?:[àa])\s*)?';
  }

  @override
  String followingPhase() {
    return '\\s*(?:\\-|\u2013|\\~|\u301C|[àa]|\\?)\\s*';
  }

  @override
  ParsingComponents? extractPrimaryTimeComponents(
      ParsingContext context, RegExpMatch match,
      [bool strict = false]) {
    // This looks more like a year e.g. 2020
    if (RegExp(r'^\s*\d{4}\s*$').hasMatch(match[0]!)) {
      return null;
    }

    return super.extractPrimaryTimeComponents(context, match, strict);
  }
}
