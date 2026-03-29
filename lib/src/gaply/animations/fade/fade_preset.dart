import 'package:gaply/src/gaply/core/gaply_preset.dart';
import 'package:gaply/src/annotations.dart';
import 'package:gaply/src/utils/gaply_logger.dart';

import 'fade_style.dart';

part 'fade_preset.g.dart';

@gaplyPreset
class FadePreset extends GaplyPreset<FadeStyle> {
  static GaplyPresetPolicy policy = GaplyPresetPolicy.flexible;

  @override
  GaplyPresetPolicy get presetPolicy => policy;

  FadePreset._internal() {
    _initDefaultPreset();
  }

  void _initDefaultPreset() {}
}
