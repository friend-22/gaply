import 'package:flutter/material.dart';
import 'package:gaply/src/core/params/blur_params.dart';

// class BlurWidget extends StatelessWidget {
//   final BlurParams params;
//   final Widget child;
//
//   const BlurWidget({super.key, required this.params, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     if (!params.isEnabled) return child;
//
//     final Color overlayColor = params.color.resolve(context).withValues(alpha: params.opacity);
//
//     return ClipRect(
//       child: Stack(
//         children: [
//           BackdropFilter(
//             filter: params.resolve(),
//             child: Container(color: overlayColor),
//           ),
//           child,
//         ],
//       ),
//     );
//   }
// }
