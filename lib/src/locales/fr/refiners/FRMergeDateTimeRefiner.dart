import '../../../common/refiners/AbstractMergeDateTimeRefiner.dart';

/// Merging date-only result and time-only result (see. AbstractMergeDateTimeRefiner).
/// French connecting phases: à, a, au, vers, de
class FRMergeDateTimeRefiner extends AbstractMergeDateTimeRefiner {
  @override
  RegExp patternBetween() {
    return RegExp(r'^\s*(T|à|a|au|vers|de|,|-)?\s*$');
  }
}
