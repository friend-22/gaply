import 'package:flutter/widgets.dart';

import 'gaply_shimmer.dart';

extension ShimmerExtension on Widget {
  Widget withShimmer(BuildContext context, GaplyShimmer style, {bool enabled = true}) {
    if (!enabled) return this;
    return style.buildWidget(context: context, child: this);
  }

  Widget shimmerPreset(BuildContext context, String name, {bool enabled = true}) {
    if (!enabled) return this;
    return withShimmer(context, GaplyShimmer.preset(name), enabled: enabled);
  }
}
