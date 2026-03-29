import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/gaply_style.dart';
import 'package:gaply/src/utils/gaply_profiler.dart';

@immutable
class GaplyColorToken extends GaplyToken<String> {
  const GaplyColorToken(super.value);

  static const GaplyColorToken none = GaplyColorToken('none');
  static const GaplyColorToken primary = GaplyColorToken('primary');
  static const GaplyColorToken background = GaplyColorToken('background');
  static const GaplyColorToken secondary = GaplyColorToken('secondary');
  static const GaplyColorToken surface = GaplyColorToken('surface');
  static const GaplyColorToken surfaceVariant = GaplyColorToken('surfaceVariant');
  static const GaplyColorToken error = GaplyColorToken('error');
  static const GaplyColorToken success = GaplyColorToken('success');
  static const GaplyColorToken warning = GaplyColorToken('warning');
  static const GaplyColorToken info = GaplyColorToken('info');
  static const GaplyColorToken shadow = GaplyColorToken('shadow');

  static GaplyColorToken resolve(Object? role) {
    if (role is GaplyColorToken) return role;

    if (role is Enum) {
      return GaplyColorToken(role.name);
    }

    if (role is String) {
      if (role.trim().isEmpty) {
        GaplyLogger.i("GaplyColorToken.resolve received an empty string.");
        return GaplyColorToken.none;
      }

      return GaplyColorToken(role);
    }

    if (role != null) {
      GaplyLogger.i("Unsupported role type: ${role.runtimeType}. String or GaplyColorToken expected.");
    }

    return GaplyColorToken.none;
  }
}

class GaplyColorOpacity extends GaplyToken<double> {
  const GaplyColorOpacity(super.value);

  static const GaplyColorOpacity transparent = GaplyColorOpacity(0.0);
  static const GaplyColorOpacity o10 = GaplyColorOpacity(0.1);
  static const GaplyColorOpacity o20 = GaplyColorOpacity(0.2);
  static const GaplyColorOpacity o30 = GaplyColorOpacity(0.3);
  static const GaplyColorOpacity o40 = GaplyColorOpacity(0.4);
  static const GaplyColorOpacity o50 = GaplyColorOpacity(0.5);
  static const GaplyColorOpacity o60 = GaplyColorOpacity(0.6);
  static const GaplyColorOpacity o70 = GaplyColorOpacity(0.7);
  static const GaplyColorOpacity o80 = GaplyColorOpacity(0.8);
  static const GaplyColorOpacity o90 = GaplyColorOpacity(0.9);
  static const GaplyColorOpacity full = GaplyColorOpacity(1.0);
  static const GaplyColorOpacity subtle = GaplyColorOpacity(0.12);
  static const GaplyColorOpacity half = GaplyColorOpacity(0.5);
  static const GaplyColorOpacity solid = GaplyColorOpacity(1.0);

  static GaplyColorOpacity resolve(Object? value) {
    if (value is GaplyColorOpacity) return value;
    if (value is num) return GaplyColorOpacity(value.toDouble());
    if (value != null) {
      GaplyLogger.i(
        "⚠️ [Gaply Warning] Unsupported opacity type: ${value.runtimeType}. "
        "Expected num or GaplyColorOpacity. Falling back to full.",
      );
    }
    return GaplyColorOpacity.full;
  }

  GaplyColorOpacity operator +(double other) => GaplyColorOpacity((value + other).clamp(0.0, 1.0));
  GaplyColorOpacity operator -(double other) => GaplyColorOpacity((value - other).clamp(0.0, 1.0));
  GaplyColorOpacity operator *(double other) => GaplyColorOpacity((value * other).clamp(0.0, 1.0));
  GaplyColorOpacity operator /(double other) => GaplyColorOpacity((value / other).clamp(0.0, 1.0));
}

class GaplyColorShade extends GaplyToken<double> {
  const GaplyColorShade(super.value);

  static const GaplyColorShade s50 = GaplyColorShade(0.05);
  static const GaplyColorShade s100 = GaplyColorShade(0.1);
  static const GaplyColorShade s200 = GaplyColorShade(0.2);
  static const GaplyColorShade s300 = GaplyColorShade(0.3);
  static const GaplyColorShade s400 = GaplyColorShade(0.4);
  static const GaplyColorShade s500 = GaplyColorShade(0.5);
  static const GaplyColorShade s600 = GaplyColorShade(0.6);
  static const GaplyColorShade s700 = GaplyColorShade(0.7);
  static const GaplyColorShade s800 = GaplyColorShade(0.8);
  static const GaplyColorShade s900 = GaplyColorShade(0.9);
  static const GaplyColorShade s950 = GaplyColorShade(0.95);

  static const GaplyColorShade defaultShade = GaplyColorShade(0.5);

  static GaplyColorShade resolve(Object? value) {
    if (value is GaplyColorShade) return value;
    if (value is num) return GaplyColorShade(value.toDouble());
    if (value != null) {
      GaplyLogger.i(
        "⚠️ [Gaply Warning] Unsupported shade type: ${value.runtimeType}. "
        "Expected num or GaplyColorShade. Falling back to defaultShade.",
      );
    }
    return GaplyColorShade.defaultShade;
  }

  GaplyColorShade operator +(double other) => GaplyColorShade((value + other).clamp(0.0, 1.0));
  GaplyColorShade operator -(double other) => GaplyColorShade((value - other).clamp(0.0, 1.0));
  GaplyColorShade operator *(double other) => GaplyColorShade((value * other).clamp(0.0, 1.0));
  GaplyColorShade operator /(double other) => GaplyColorShade((value / other).clamp(0.0, 1.0));
}
