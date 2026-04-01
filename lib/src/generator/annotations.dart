import 'package:gaply/src/gaply/core/gaply_defines.dart';

class GaplyPresetGen {
  final String prefix;
  final String? initializer;
  final GaplyResolvePolicy policy;

  const GaplyPresetGen({this.prefix = 'Gaply', this.initializer, this.policy = GaplyResolvePolicy.flexible});
}

const gaplyPreset = GaplyPresetGen();

class GaplyIdentityGen {
  final String? initializer;
  final GaplyResolvePolicy policy;

  const GaplyIdentityGen({this.initializer, this.policy = GaplyResolvePolicy.flexible});
}
