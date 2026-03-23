import 'package:flutter/widgets.dart';
import 'package:gaply/gaply.dart';

mixin GaplyTriggerMixin<W extends StatefulWidget, P extends ParamsBase, S extends State> on State<W> {
  final GlobalKey<S> triggerKey = GlobalKey<S>();

  P get params;
  Object? get trigger;

  void execute(P params);

  @override
  void initState() {
    super.initState();
    if (params.isEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        execute(params);
      });
    }
  }

  void checkAndExecute(P oldParams, Object? oldTrigger) {
    final isParamsChanged = params != oldParams;
    final isTriggered = trigger != oldTrigger;

    if ((isParamsChanged || isTriggered) && params.isEnabled) {
      execute(params);
    }
  }
}
