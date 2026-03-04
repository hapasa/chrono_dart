import '../../../common/refiners/AbstractMergeDateRangeRefiner.dart';

/// Merging before and after results (see. AbstractMergeDateRangeRefiner)
/// French connecting phases: à, a, au, -
class FRMergeDateRangeRefiner extends AbstractMergeDateRangeRefiner {
  @override
  RegExp patternBetween() {
    return RegExp(r'^\s*(à|a|au|-)\s*$', caseSensitive: false);
  }
}
