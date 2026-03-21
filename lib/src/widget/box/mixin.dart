// import 'package:flutter/material.dart';
// import 'package:gaply/src/core/params/box_params.dart';
//
// mixin BoxParamsMixin {
//   BoxParams get _params => this as BoxParams;
//
//   Widget buildBox(BuildContext context, Widget content) {
//     Widget effectiveContent = content;
//
//     // if (boxSpec.progressParams.type != ProgressType.none) {
//     //   final isLinear = boxSpec.progressParams.type == ProgressType.linear;
//     //
//     //   effectiveContent = Stack(
//     //     alignment: Alignment.center,
//     //     fit: StackFit.loose,
//     //     clipBehavior: Clip.none,
//     //     children: [
//     //       Opacity(opacity: 0.4, child: content),
//     //       Positioned(
//     //         left: 0,
//     //         right: 0,
//     //         bottom: isLinear ? boxSpec.progressParams.botPosition : null,
//     //         child: Center(child: buildProgress(context, boxSpec.progressParams)),
//     //       ),
//     //     ],
//     //   );
//     // }
//
//     Widget box;
//     if (_params.boxType == BoxType.none) {
//       if (_params.width == null && _params.height == null) {
//         box = effectiveContent;
//       } else {
//         box = SizedBox(width: _params.width, height: _params.height, child: effectiveContent);
//       }
//     } else {
//       Color resolveBorderColor = _params.borderColorParams.resolve(context) ?? context.colorScheme.border;
//       Color resolveBackgroundColor = _params.bgColorParams.resolve(context) ?? context.colorScheme.background;
//
//       if (_params.useFocusOutline && _params.focused) {
//         resolveBorderColor = Colors.transparent;
//       }
//
//       List<BoxShadow>? resolveShadow = _params.acrylicParams.resolve(context);
//
//       box = BaseContainer(
//         width: _params.width,
//         height: _params.height,
//         padding: _params.padding,
//         margin: _params.margin,
//         focused: _params.focused,
//         borderWidth: _params.borderWidth,
//         backgroundColor: resolveBackgroundColor,
//         borderColor: resolveBorderColor,
//         borderRadius: _params.borderRadius,
//         surfaceOpacity: _params.acrylicParams.opacity,
//         surfaceBlur: _params.acrylicParams.blur,
//         boxShadow: resolveShadow,
//         useFocusOutline: _params.useFocusOutline,
//         duration: _params.duration,
//         child: effectiveContent,
//       );
//     }
//
//     if (_params.shimmer) {
//       final colorScheme = Theme.of(context).colorScheme;
//       box = Shimmer.fromColors(
//         baseColor: colorScheme.mutedForeground,
//         highlightColor: Colors.white,
//         child: box,
//       );
//     }
//
//     if (_params.center) {
//       box = Center(child: box);
//     }
//
//     if (_params.onPressed != null) {
//       box = GestureDetector(
//         onTap: _params.onPressed,
//         behavior: HitTestBehavior.opaque,
//         child: MouseRegion(cursor: SystemMouseCursors.click, child: box),
//       );
//     }
//
//     return box;
//   }
// }
