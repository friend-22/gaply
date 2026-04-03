part of 'gaply_profiler.dart';

@immutable
abstract class GaplyEngineSpec extends Equatable {
  final String? id;
  final GaplyLoggerEngine? customLogger;
  final Duration threshold;
  final int maxStats;
  final Duration statsLifetime;
  final Duration maxFlushInterval;
  final int maxFlushCount;
  final Duration autoFlushInterval;

  bool get enableMemoryTracking => false;

  const GaplyEngineSpec({
    this.id,
    this.customLogger,
    required this.threshold,
    required this.maxStats,
    required this.statsLifetime,
    required this.maxFlushInterval,
    required this.maxFlushCount,
    required this.autoFlushInterval,
  });

  @override
  List<Object?> get props => [
    id,
    customLogger,
    threshold,
    maxStats,
    statsLifetime,
    maxFlushInterval,
    maxFlushCount,
    autoFlushInterval,
  ];

  GaplyEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
    Duration? maxFlushInterval,
    int? maxFlushCount,
    Duration? autoFlushInterval,
  });
}

@immutable
class GaplyNoOpEngineSpec extends GaplyEngineSpec {
  const GaplyNoOpEngineSpec({
    super.id,
    super.customLogger,
    super.threshold = Duration.zero,
    super.maxStats = 0,
    super.statsLifetime = Duration.zero,
    super.maxFlushInterval = Duration.zero,
    super.maxFlushCount = 0,
    super.autoFlushInterval = Duration.zero,
  });

  @override
  GaplyNoOpEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
    Duration? maxFlushInterval,
    int? maxFlushCount,
    Duration? autoFlushInterval,
  }) {
    return const GaplyNoOpEngineSpec();
  }
}

@immutable
class GaplyBatchEngineSpec extends GaplyEngineSpec {
  const GaplyBatchEngineSpec({
    super.id,
    super.customLogger,
    super.threshold = GaplyBudget.fps120,
    super.maxStats = 100,
    super.statsLifetime = const Duration(minutes: 1),
    super.maxFlushInterval = GaplyBudget.fps60,
    super.maxFlushCount = 100,
    super.autoFlushInterval = const Duration(seconds: 1),
  });

  @override
  GaplyBatchEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
    Duration? maxFlushInterval,
    int? maxFlushCount,
    Duration? autoFlushInterval,
  }) {
    return GaplyBatchEngineSpec(
      id: id ?? this.id,
      customLogger: customLogger ?? this.customLogger,
      threshold: threshold ?? this.threshold,
      maxStats: maxStats ?? this.maxStats,
      statsLifetime: statsLifetime ?? this.statsLifetime,
      maxFlushInterval: maxFlushInterval ?? this.maxFlushInterval,
      maxFlushCount: maxFlushCount ?? this.maxFlushCount,
      autoFlushInterval: autoFlushInterval ?? this.autoFlushInterval,
    );
  }
}

@immutable
class GaplyMemoryEngineSpec extends GaplyEngineSpec {
  final int thresholdBytes;

  @override
  bool get enableMemoryTracking => true;

  const GaplyMemoryEngineSpec({
    super.id,
    super.customLogger,
    super.maxStats = 100,
    super.statsLifetime = const Duration(minutes: 1),
    super.maxFlushInterval = GaplyBudget.fps60,
    super.maxFlushCount = 100,
    super.autoFlushInterval = const Duration(seconds: 1),
    this.thresholdBytes = GaplyBudget.kb1,
  }) : super(threshold: GaplyBudget.all);

  @override
  List<Object?> get props => [...super.props, thresholdBytes];

  @override
  GaplyMemoryEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
    int? thresholdBytes,
    Duration? maxFlushInterval,
    int? maxFlushCount,
    Duration? autoFlushInterval,
  }) {
    return GaplyMemoryEngineSpec(
      id: id ?? this.id,
      customLogger: customLogger ?? this.customLogger,
      //threshold: threshold ?? this.threshold,
      maxStats: maxStats ?? this.maxStats,
      statsLifetime: statsLifetime ?? this.statsLifetime,
      thresholdBytes: thresholdBytes ?? this.thresholdBytes,
      maxFlushInterval: maxFlushInterval ?? this.maxFlushInterval,
      maxFlushCount: maxFlushCount ?? this.maxFlushCount,
      autoFlushInterval: autoFlushInterval ?? this.autoFlushInterval,
    );
  }
}

@immutable
class GaplyTraceEngineSpec extends GaplyEngineSpec {
  const GaplyTraceEngineSpec({
    super.id,
    super.customLogger,
    super.threshold = GaplyBudget.fps120,
    super.maxStats = 100,
    super.statsLifetime = const Duration(minutes: 1),
    super.maxFlushInterval = GaplyBudget.fps60,
    super.maxFlushCount = 100,
    super.autoFlushInterval = const Duration(seconds: 1),
  });

  @override
  GaplyTraceEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
    Duration? maxFlushInterval,
    int? maxFlushCount,
    Duration? autoFlushInterval,
  }) {
    return GaplyTraceEngineSpec(
      id: id ?? this.id,
      customLogger: customLogger ?? this.customLogger,
      threshold: threshold ?? this.threshold,
      maxStats: maxStats ?? this.maxStats,
      statsLifetime: statsLifetime ?? this.statsLifetime,
      maxFlushInterval: maxFlushInterval ?? this.maxFlushInterval,
      maxFlushCount: maxFlushCount ?? this.maxFlushCount,
      autoFlushInterval: autoFlushInterval ?? this.autoFlushInterval,
    );
  }
}
