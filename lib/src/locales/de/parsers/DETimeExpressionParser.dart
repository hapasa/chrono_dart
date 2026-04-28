import '../../../chrono.dart' show ParsingContext;
import '../../../results.dart' show ParsingComponents;
import '../../../common/parsers/AbstractTimeExpressionParser.dart'
    show AbstractTimeExpressionParser;

class DETimeExpressionParser extends AbstractTimeExpressionParser {
  DETimeExpressionParser([super.strictMode]);

  @override
  String primaryPrefix() {
    return r'(?:(?:um|von)\s*)?';
  }

  @override
  String followingPhase() {
    return '\\s*(?:\\-|\\u2013|\\~|\\u301C|bis)\\s*';
  }

  @override
  ParsingComponents? extractPrimaryTimeComponents(
      ParsingContext context, RegExpMatch match,
      [bool strict = false]) {
    if (RegExp(r'^\s*\d{4}\s*$').hasMatch(match[0]!)) {
      return null;
    }

    return super.extractPrimaryTimeComponents(context, match, strict);
  }
}
