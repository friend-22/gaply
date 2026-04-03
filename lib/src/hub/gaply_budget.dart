class GaplyBudget {
  // Precision Budgets
  static const Duration instant = Duration.zero;
  static const Duration perfect = instant;

  // Frame Budgets (1000000 / rate)
  static const Duration fpsNano = Duration(microseconds: 2083); // 480fps
  static const Duration fps240 = Duration(microseconds: 4166); // 240fps
  static const Duration fps120 = Duration(microseconds: 8333); // 120fps
  static const Duration fps60 = Duration(microseconds: 16666); // 60fps
  static const Duration fps30 = Duration(microseconds: 33333); // 30fps

  // Smoothing Budgets (Update Intervals)
  static const Duration micro = Duration(milliseconds: 100); // 10Hz
  static const Duration smooth240 = Duration(milliseconds: 250); // 4Hz
  static const Duration smooth120 = Duration(milliseconds: 500); // 2Hz
  static const Duration smooth60 = Duration(milliseconds: 1000); // 1Hz
  static const Duration smooth30 = Duration(milliseconds: 2000); // 0.5Hz

  // Profiling Thresholds
  static const Duration critical = fps60; // Frame drop risk at 60fps
  static const Duration warning = fps120; // Precision risk at 120fps
  static const Duration slow = Duration(milliseconds: 1); // 1ms threshold
  static const Duration all = Duration.zero; // No filtering

  // --- [Batch & Flush Policies] ---
  // Guidelines for when to flush or aggregate data
  static const Duration batchFlushFast = fps60; // Aggressive flushing (Real-time)
  static const Duration batchFlushNormal = micro; // Balanced flushing
  static const Duration batchFlushLazy = smooth60; // Resource-saving flushing

  static const int memoryTrack240 = 4;
  static const int memoryTrack120 = 8;
  static const int memoryTrack60 = 16;
  static const int memoryTrack30 = 32;
  static const int memoryTrack15 = 64;

  // --- [Helper Methods] ---
  /// Creates a Duration from microseconds
  static Duration us(num amount) => Duration(microseconds: amount.toInt());

  /// Creates a Duration from milliseconds
  static Duration ms(num amount) => Duration(milliseconds: amount.toInt());

  /// Returns duration based on FPS (1 sec / rate)
  static Duration fps(num rate) => Duration(microseconds: 1000000 ~/ rate);

  /// Returns duration based on Hz (1 sec / count)
  static Duration hz(num count) => Duration(milliseconds: 1000 ~/ count);

  // --- [Memory Thresholds] ---
  static const int zeroBytes = 0;
  static const int kb1 = 1024;
  static const int mb1 = 1024 * 1024;
  static const int mb10 = 10 * mb1; // 10MB
  static const int mb50 = 50 * mb1; // 50MB
  static const int mb100 = 100 * mb1; // 100MB

  // --- [Helper Methods] ---
  /// Converts bytes to Megabytes (MB)
  static double toMB(int bytes) => bytes / (1024 * 1024);

  /// Formats bytes to a human-readable string
  static String formatBytes(int bytes) {
    if (bytes == 0) return '0 B';

    final String sign = bytes < 0 ? '-' : '+';
    final double absBytes = bytes.abs().toDouble();

    if (absBytes < 1024) {
      return '$sign${absBytes.toInt()} B';
    } else if (absBytes < 1024 * 1024) {
      return '$sign${(absBytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '$sign${(absBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  static String get syncThresholdGuide =>
      'Budget: ✨Perf<1ms | ✅Norm<${GaplyBudget.fps120.inMilliseconds}ms | ⚠️Warn<${GaplyBudget.fps60.inMilliseconds}ms | 🚨JANK>=16.6ms';
}
