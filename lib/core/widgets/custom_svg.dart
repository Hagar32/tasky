import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

//
// class CustomSvgPicture {
//   static Widget withColor(String path, double? width, double? height, BuildContext context) {
//     return SvgPicture.asset(
//       path,
//       width: width,
//       height: height,
//       colorFilter: ColorFilter.mode(
//         Theme.of(context).colorScheme.secondary,
//         BlendMode.srcIn,
//       ),
//     );
//   }
//
//   static Widget withoutColor(String path, double? width, double? height) {
//     return SvgPicture.asset(path, width: width, height: height);
//   }
// }
class CustomSvg {
  static Widget svgPicture({
    required BuildContext context,
    required String path,
    double? width,
    double? height,
    bool useThemeColor = true,
  }) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: useThemeColor
          ? ColorFilter.mode(
              Theme.of(context).colorScheme.secondary,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
