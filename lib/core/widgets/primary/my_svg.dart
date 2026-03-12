// lib/core/widgets/primary/my_svg.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/theme_extensions.dart';

class MySvg extends StatelessWidget {
  final String image;
  final ColorFilter? colorFilter;
  final bool rotate;
  final int rotationValue;
  final double? width;
  final double? height;
  final bool isImage;
  final BoxFit fit;
  final Color? color;
  final bool applyColor;

  const MySvg({
    super.key,
    required this.image,
    this.colorFilter,
    this.rotate = false,
    this.rotationValue = 2,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.isImage = false,
    this.color,
    this.applyColor = true,
  });

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotate
          ? Directionality.of(context) == TextDirection.rtl
          ? rotationValue
          : 0
          : 0,
      child: SvgPicture.asset(
        isImage ? 'assets/images/$image.svg' : 'assets/icons/$image.svg',
        width: width,
        height: height,
        fit: fit,
        colorFilter: _getColorFilter(context),
      ),
    );
  }

  ColorFilter? _getColorFilter(BuildContext context) {
    if (colorFilter != null) return colorFilter;
    if (!applyColor) return null;

    final iconColor = color ?? context.iconColor;
    return ColorFilter.mode(iconColor, BlendMode.srcIn);
  }
}