import 'package:flutter/foundation.dart' show debugPrint;
import 'package:gaply/src/hub/gaply_hub.dart';

import 'package:gaply/src/hub/gaply_throttler.dart';
import 'package:gaply/src/hub/gaply_budget.dart';

import 'gaply_logger_base.dart';

class GaplyConsoleLogger extends GaplyLoggerEngine {
  late final GaplyThrottler<LogPacket> _throttler;

  GaplyConsoleLogger({super.id, Duration interval = GaplyBudget.fps60}) {
    _throttler = GaplyThrottler(
      interval: interval,
      onUpdate: (value) => _log(value),
      shouldUpdate: (oldVal, newVal) => oldVal != newVal,
    );
  }

  @override
  void write(LogPacket packet) {
    if (packet.isForce) {
      _throttler.reset();
      debugPrint(packet.text);
    } else {
      _throttler.update(packet);
    }
  }

  void _log(LogPacket packet) {
    final a = GaplyHub.theme.ansi;
    String prefix = '';

    switch (packet.level) {
      case GaplyLogLevel.error:
        prefix = '${a.error}[ERROR]${a.reset} ';
        break;
      case GaplyLogLevel.warning:
        prefix = '${a.warning}[WARN]${a.reset} ';
        break;
      case GaplyLogLevel.info:
        prefix = '${a.info}[INFO]${a.reset} ';
        break;
      case GaplyLogLevel.debug:
        prefix = '${a.gray}[DEBUG]${a.reset} ';
        break;
      default:
        break;
    }

    debugPrint('$prefix${packet.text}');
  }
}
