import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class ParamsBase<T> extends Equatable {
  const ParamsBase();

  bool get isEnabled;

  T lerp(T? other, double t);

  T copyWith();

  @override
  List<Object?> get props;
}
