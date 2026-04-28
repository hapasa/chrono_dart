import '../../../common/refiners/AbstractMergeDateTimeRefiner.dart';

class DEMergeDateTimeRefiner extends AbstractMergeDateTimeRefiner {
  @override
  RegExp patternBetween() {
    return RegExp(r'^\s*(T|um|am|,|-)?\s*$');
  }
}
