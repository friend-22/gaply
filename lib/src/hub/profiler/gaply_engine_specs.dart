part of 'gaply_profiler.dart';

@immutable
abstract class GaplyEngineSpec extends Equatable {
  final String id;
  final GaplyLoggerEngine? customLogger;
  final Duration threshold;
  final int maxKeys;
  final Duration maxIdleTime;

  const GaplyEngineSpec({
    required this.id,
    required this.threshold,
    required this.maxKeys,
    required this.maxIdleTime,
    this.customLogger,
  });

  @override
  List<Object?> get props => [id, threshold, maxKeys, maxIdleTime];

  GaplyEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxKeys,
    Duration? maxIdleTime,
  });
}

@immutable
class GaplyNoOpEngineSpec extends GaplyEngineSpec {
  const GaplyNoOpEngineSpec({
    super.id = '',
    super.customLogger,
    super.threshold = Duration.zero,
    super.maxKeys = 0,
    super.maxIdleTime = Duration.zero,
  });

  @override
  GaplyNoOpEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxKeys,
    Duration? maxIdleTime,
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
    int? maxKeys,
    Duration? maxIdleTime,
    this.maxBatchInterval = GaplyBudget.fps60,
    this.maxBatchCount = 100,
  }) : super(
         id: id ?? '',
         threshold: threshold ?? GaplyBudget.all,
         maxKeys: maxKeys ?? 500,
         maxIdleTime: maxIdleTime ?? const Duration(minutes: 5),
       );

  @override
  List<Object?> get props => [...super.props, maxBatchInterval, maxBatchCount];

  @override
  GaplyBatchEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxKeys,
    Duration? maxIdleTime,
    Duration? maxBatchInterval,
    int? maxBatchCount,
  }) {
    return GaplyBatchEngineSpec(
      id: id ?? this.id,
      customLogger: customLogger ?? this.customLogger,
      threshold: threshold ?? this.threshold,
      maxKeys: maxKeys ?? this.maxKeys,
      maxIdleTime: maxIdleTime ?? this.maxIdleTime,
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
    int? maxKeys,
    Duration? maxIdleTime,
    this.thresholdBytes = GaplyBudget.mb1,
  }) : super(
         id: id ?? '',
         threshold: threshold ?? GaplyBudget.all,
         maxKeys: maxKeys ?? 500,
         maxIdleTime: maxIdleTime ?? const Duration(minutes: 5),
       );

  @override
  List<Object?> get props => [...super.props, thresholdBytes];

  @override
  GaplyMemoryEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxKeys,
    Duration? maxIdleTime,
    int? thresholdBytes,
  }) {
    return GaplyMemoryEngineSpec(
      id: id ?? this.id,
      customLogger: customLogger ?? this.customLogger,
      threshold: threshold ?? this.threshold,
      maxKeys: maxKeys ?? this.maxKeys,
      maxIdleTime: maxIdleTime ?? this.maxIdleTime,
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
    int? maxKeys,
    Duration? maxIdleTime,
  }) : super(
         id: id ?? '',
         threshold: threshold ?? GaplyBudget.all,
         maxKeys: maxKeys ?? 500,
         maxIdleTime: maxIdleTime ?? const Duration(minutes: 5),
       );

  @override
  List<Object?> get props => [...super.props];

  @override
  GaplyTraceEngineSpec copyWith({
    String? id,
    GaplyLoggerEngine? customLogger,
    Duration? threshold,
    int? maxKeys,
    Duration? maxIdleTime,
  }) {
    return GaplyTraceEngineSpec(
      id: id ?? this.id,
      customLogger: customLogger ?? this.customLogger,
      threshold: threshold ?? this.threshold,
      maxKeys: maxKeys ?? this.maxKeys,
      maxIdleTime: maxIdleTime ?? this.maxIdleTime,
    );
  }
}
