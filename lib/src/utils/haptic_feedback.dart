import 'package:flutter/services.dart' as services;
import 'package:gaply/src/utils/task_extension.dart';

enum HapticType {
  selection(services.HapticFeedback.selectionClick),
  light(services.HapticFeedback.lightImpact),
  medium(services.HapticFeedback.mediumImpact),
  heavy(services.HapticFeedback.heavyImpact);

  final Future<void> Function() feedback;
  const HapticType(this.feedback);
}

extension HapticHelper on Object {
  void haptic(HapticType type, {bool enabled = true}) {
    if (enabled) type.feedback();
  }

  void hapticDouble(HapticType type, {bool enabled = true}) {
    if (enabled) {
      type.feedback();
      onMilliDelay(60, () => type.feedback());
    }
  }
}
