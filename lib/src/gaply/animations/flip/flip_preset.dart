import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'flip_style.dart';

part 'flip_preset.g.dart';

@gaplyPreset
class FlipPreset extends GaplyPreset<FlipStyle> {
  static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;

  @override
  GaplyPresetPolicy get presetPolicy => policy;

  FlipPreset._internal() {
    _initDefaultPreset();
  }

  void _initDefaultPreset() {}
}
