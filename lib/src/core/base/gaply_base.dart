import 'package:gaply/src/core/base/params_base.dart';
import 'package:gaply/src/core/params/blur_params.dart';
import 'package:gaply/src/core/params/box_params.dart';
import 'package:gaply/src/core/params/fade_params.dart';
import 'package:gaply/src/core/params/flip_params.dart';
import 'package:gaply/src/core/params/gradient_params.dart';
import 'package:gaply/src/core/params/scale_params.dart';
import 'package:gaply/src/core/params/shadow_params.dart';
import 'package:gaply/src/core/params/shake_params.dart';
import 'package:gaply/src/core/params/shimmer_params.dart';
import 'package:gaply/src/core/params/slide_params.dart';
import 'package:gaply/src/core/params/train_params.dart';

mixin GaplyPreset<T extends ParamsBase> {
  final Map<String, T> _presets = {};

  void add(String name, T params) => _presets[name] = params;

  T? get(String name) => _presets[name];

  bool get hasPreset => _presets.isNotEmpty;

  List<String> get allKeys => _presets.keys.toList();
}

// class Gaply {
//   static final Map<String, GaplyPreset> _presets = {};
//
//   static void init() {
//     //effects
//     _presets['blur'] = GaplyBlurPreset.instance;
//     //_presets['color'] = GaplyColorPreset.instance;
//     _presets['gradient'] = GaplyGradientPreset.instance;
//     _presets['shadow'] = GaplyShadowPreset.instance;
//     _presets['shimmer'] = GaplyShimmerPreset.instance;
//
//     //animations
//     _presets['fade'] = GaplyFadePreset.instance;
//     _presets['flip'] = GaplyFlipPreset.instance;
//     _presets['scale'] = GaplyScalePreset.instance;
//     _presets['shake'] = GaplyShakePreset.instance;
//     _presets['slide'] = GaplySlidePreset.instance;
//     _presets['train'] = GaplyTrainPreset.instance;
//     // _presets['animation_sequence'] = GaplyAnimationSequencePreset.instance;
//
//     _presets['box'] = GaplyBoxPreset.instance;
//   }
//
//   static T? service<T extends GaplyPreset>(String category) {
//     final found = _presets[category];
//     return found is T ? found : null;
//   }
// }
