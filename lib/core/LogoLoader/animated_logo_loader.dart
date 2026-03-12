import 'package:flutter/material.dart';
import 'package:tavo/core/theme/theme_extensions.dart';


class AnimatedLogoLoader extends StatelessWidget {
  final double size;
  const AnimatedLogoLoader({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/logo.gif',
        color: context.iconColor,
        width: size,
        height: size,
      ),
    );
  }
}