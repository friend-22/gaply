import 'package:flutter/material.dart';

import 'package:gaply/src/gaply/core/core.dart';
import 'package:gaply/src/hub/gaply_hub.dart';

@immutable
class GaplyColorToken extends GaplyIdentity<Object> {
  const GaplyColorToken(super.value);

  static GaplyResolvePolicy policy = GaplyResolvePolicy.flexible;

  static GaplyColorToken resolve(Object? input) {
    if (input is GaplyColorToken) return input;

    final resolved = GaplyResolver.resolve(input, policy);

    if (resolved == null) {
      if (input != null) {
        GaplyHub.warning(
          "GaplyColorToken: Failed to resolve '$input'. Defaulting to 'GaplyColorToken.none'.",
        );
      }
      return GaplyColorToken.none;
    }

    return GaplyColorToken(resolved);
  }

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
}

@immutable
class GaplyColorOpacity extends GaplyNumericIdentity<GaplyColorOpacity> {
  const GaplyColorOpacity(super.value);

  @override
  GaplyColorOpacity create(double val) => GaplyColorOpacity(val);

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

  static GaplyColorOpacity resolve(Object? input) {
    if (input is GaplyColorOpacity) return input;

    final resolved = GaplyResolver.resolve(input, GaplyResolvePolicy.flexible);

    if (resolved is num) return GaplyColorOpacity(resolved.toDouble());
    if (resolved is String) {
      final parsed = double.tryParse(resolved);
      if (parsed != null) return GaplyColorOpacity(parsed.toDouble());
    }

    if (input != null) {
      GaplyHub.warning(
        "GaplyColorOpacity: Invalid input '$input'. Falling back to 'GaplyColorOpacity.full'.",
      );
    }

    return GaplyColorOpacity.full;
  }
}

class GaplyColorShade extends GaplyNumericIdentity<GaplyColorShade> {
  const GaplyColorShade(super.value);

  @override
  GaplyColorShade create(double val) => GaplyColorShade(val);

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

  static GaplyColorShade resolve(Object? input) {
    if (input is GaplyColorShade) return input;

    final resolved = GaplyResolver.resolve(input, GaplyResolvePolicy.flexible);

    if (resolved is num) return GaplyColorShade(resolved.toDouble());
    if (resolved is String) {
      final parsed = double.tryParse(resolved);
      if (parsed != null) return GaplyColorShade(parsed.toDouble());
    }

    if (input != null) {
      GaplyHub.warning(
        "GaplyColorShade: Invalid input '$input'. Falling back to 'GaplyColorShade.defaultShade'.",
      );
    }

    return GaplyColorShade.defaultShade;
  }
}
