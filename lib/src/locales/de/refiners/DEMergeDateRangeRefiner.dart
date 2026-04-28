import '../../../common/refiners/AbstractMergeDateRangeRefiner.dart';

class DEMergeDateRangeRefiner extends AbstractMergeDateRangeRefiner {
  @override
  RegExp patternBetween() {
    return RegExp(r'^\s*(bis(?:\s*(?:am|zum))?|-)\s*$', caseSensitive: false);
  }
}
