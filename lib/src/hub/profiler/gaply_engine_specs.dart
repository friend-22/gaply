part of 'gaply_profiler.dart';

@immutable
abstract class GaplyEngineSpec extends Equatable {
  final String id;
  final GaplyLoggerEngine? customLogger;
  final Duration threshold;
  final int maxStats;
  final Duration statsLifetime;

  const GaplyEngineSpec({
    required this.id,
    required this.threshold,
    required this.maxStats,
    required this.statsLifetime,
    this.customLogger,
  });

  @override
  List<Object?> get props => [id, threshold, maxStats, statsLifetime];

  GaplyEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
  });
}

@immutable
class GaplyNoOpEngineSpec extends GaplyEngineSpec {
  const GaplyNoOpEngineSpec({
    super.id = '',
    super.customLogger,
    super.threshold = Duration.zero,
    super.maxStats = 0,
    super.statsLifetime = Duration.zero,
  });

  @override
  GaplyNoOpEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
  }) {
    return const GaplyNoOpEngineSpec();
  }
}

@immutable
class GaplyBatchEngineSpec extends GaplyEngineSpec {
  final Duration maxBatchInterval;
  final int maxBatchCount;

  const GaplyBatchEngineSpec({
    String? id,
    super.customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
    this.maxBatchInterval = GaplyBudget.fps60,
    this.maxBatchCount = 100,
  }) : super(
         id: id ?? '',
         threshold: threshold ?? GaplyBudget.all,
         maxStats: maxStats ?? 100,
         statsLifetime: statsLifetime ?? const Duration(minutes: 1),
       );

  @override
  List<Object?> get props => [...super.props, maxBatchInterval, maxBatchCount];

  @override
  GaplyBatchEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
    Duration? maxBatchInterval,
    int? maxBatchCount,
  }) {
    return GaplyBatchEngineSpec(
      id: id ?? this.id,
      customLogger: customLogger ?? this.customLogger,
      threshold: threshold ?? this.threshold,
      maxStats: maxStats ?? this.maxStats,
      statsLifetime: statsLifetime ?? this.statsLifetime,
      maxBatchInterval: maxBatchInterval ?? this.maxBatchInterval,
      maxBatchCount: maxBatchCount ?? this.maxBatchCount,
    );
  }
}

@immutable
class GaplyMemoryEngineSpec extends GaplyEngineSpec {
  final int thresholdBytes;

  const GaplyMemoryEngineSpec({
    String? id,
    super.customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
    this.thresholdBytes = GaplyBudget.zeroBytes,
  }) : super(
         id: id ?? '',
         threshold: threshold ?? GaplyBudget.all,
         maxStats: maxStats ?? 100,
         statsLifetime: statsLifetime ?? const Duration(minutes: 1),
       );

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
  }) {
    return GaplyMemoryEngineSpec(
      id: id ?? this.id,
      customLogger: customLogger ?? this.customLogger,
      threshold: threshold ?? this.threshold,
      maxStats: maxStats ?? this.maxStats,
      statsLifetime: statsLifetime ?? this.statsLifetime,
      thresholdBytes: thresholdBytes ?? this.thresholdBytes,
    );
  }
}

@immutable
class GaplyTraceEngineSpec extends GaplyEngineSpec {
  const GaplyTraceEngineSpec({
    String? id,
    super.customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
  }) : super(
         id: id ?? '',
         threshold: threshold ?? GaplyBudget.all,
         maxStats: maxStats ?? 100,
         statsLifetime: statsLifetime ?? const Duration(minutes: 1),
       );

  @override
  List<Object?> get props => [...super.props];

  @override
  GaplyTraceEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxStats,
    Duration? statsLifetime,
  }) {
    return GaplyTraceEngineSpec(
      id: id ?? this.id,
      customLogger: customLogger ?? this.customLogger,
      threshold: threshold ?? this.threshold,
      maxStats: maxStats ?? this.maxStats,
      statsLifetime: statsLifetime ?? this.statsLifetime,
    );
  }
}
