import 'package:gaply/src/gaply/core/gaply_defines.dart';

class GaplyPresetGen {
  final String prefix;
  final String? initializer;
  final GaplyKeyPolicy policy;

  const GaplyPresetGen({this.prefix = 'Gaply', this.initializer, this.policy = GaplyKeyPolicy.flexible});
}

const gaplyPreset = GaplyPresetGen();
