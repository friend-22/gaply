import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:gaply/src/hub/gaply_hub.dart';

import '../gaply_budget.dart';

mixin _GaplyLoggerSpecMixin on Equatable {
  GaplyLoggerSpec get _self => this as GaplyLoggerSpec;
  void registerDefault() {
    GaplyHub.addDefaultLogger(_self);
  }

  void removeDefault() {
    GaplyHub.removeDefaultLogger(_self);
  }

  void registerCustom() {
    GaplyHub.addCustomLogger(_self);
  }

  void removeCustom() {
    GaplyHub.removeCustomLogger(_self);
  }
}

@immutable
abstract class GaplyLoggerSpec extends Equatable with _GaplyLoggerSpecMixin {
  final String? id;

  const GaplyLoggerSpec({this.id});

  @override
  List<Object?> get props => [id];

  GaplyLoggerSpec copyWith({String? id});
}

@immutable
class GaplyNoOpLoggerSpec extends GaplyLoggerSpec {
  const GaplyNoOpLoggerSpec({super.id});

  @override
  GaplyNoOpLoggerSpec copyWith({String? id}) {
    return GaplyNoOpLoggerSpec();
  }
}

@immutable
class GaplyConsoleLoggerSpec extends GaplyLoggerSpec {
  final Duration flushInterval;
  final int bufferCapacity;
  const GaplyConsoleLoggerSpec({super.id, this.flushInterval = GaplyBudget.fps60, this.bufferCapacity = 20});

  @override
  GaplyLoggerSpec copyWith({String? id, Duration? flushInterval, int? bufferCapacity}) {
    return GaplyConsoleLoggerSpec(
      id: id ?? this.id,
      flushInterval: flushInterval ?? this.flushInterval,
      bufferCapacity: bufferCapacity ?? this.bufferCapacity,
    );
  }

  @override
  List<Object?> get props => [...super.props, flushInterval, bufferCapacity];
}

@immutable
class GaplyFileLoggerSpec extends GaplyLoggerSpec {
  final String path;
  final int maxBytes;
  final FileMode mode;
  final int bufferCapacity;
  final Duration flushInterval;

  const GaplyFileLoggerSpec({
    super.id,
    required this.path,
    this.maxBytes = 5 * 1024 * 1024,
    this.mode = FileMode.append,
    this.bufferCapacity = 20,
    this.flushInterval = const Duration(seconds: 5),
  });

  @override
  GaplyLoggerSpec copyWith({
    String? id,
    String? path,
    int? maxBytes,
    FileMode? mode,
    Duration? flushInterval,
    int? bufferCapacity,
  }) {
    return GaplyFileLoggerSpec(
      id: id ?? this.id,
      path: path ?? this.path,
      maxBytes: maxBytes ?? this.maxBytes,
      mode: mode ?? this.mode,
      flushInterval: flushInterval ?? this.flushInterval,
      bufferCapacity: bufferCapacity ?? this.bufferCapacity,
    );
  }

  @override
  List<Object?> get props => [...super.props, path, maxBytes, mode, bufferCapacity, flushInterval];
}

@immutable
class GaplyMemoryLoggerSpec extends GaplyLoggerSpec {
  final int maxCapacity;

  const GaplyMemoryLoggerSpec({super.id, this.maxCapacity = 1000});

  @override
  GaplyLoggerSpec copyWith({String? id, int? maxCapacity}) {
    return GaplyMemoryLoggerSpec(id: id ?? this.id, maxCapacity: maxCapacity ?? this.maxCapacity);
  }

  @override
  List<Object?> get props => [...super.props, maxCapacity];
}
