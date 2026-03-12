// lib/core/widgets/primary/my_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/LogoLoader/animated_logo_loader.dart';

import '../../helpers/utils/spacing.dart';
import '../../theme/colors.dart';
import '../../theme/theme_extensions.dart';
import 'empty.dart';
import 'my_svg.dart';

class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final Function()? onLongPress;
  final ButtonTextTheme? textTheme;
  final String? image;
  final bool isImage;
  final String? imageIcon;
  final double? iconHeight;
  final double? iconWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? label;
  final Color? textColor;
  final Color? disabledTextColor;
  final Color? backgroundColor;
  final Color? disabledColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final double elevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final double? disabledElevation;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;
  final double? radius;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final MaterialTapTargetSize? materialTapTargetSize;
  final Duration? animationDuration;
  final double? minWidth;
  final double? height;
  final double stroke;
  final Color? borderColor;
  final double gap;
  final TextStyle? labelStyle;
  final double? margin;
  final bool useThemeColors;
  final bool isLoading;
  final Color? loadingColor;
  final double? loadingSize;
  final double? loadingStrokeWidth;
  final Widget? child;

  const MyButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.textTheme,
    this.image,
    this.label,
    this.textColor,
    this.disabledTextColor,
    this.backgroundColor,
    this.disabledColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.elevation = 0,
    this.focusElevation = 0,
    this.hoverElevation = 0,
    this.highlightElevation = 0,
    this.disabledElevation = 0,
    this.padding = EdgeInsets.zero,
    this.visualDensity,
    this.radius,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.animationDuration,
    this.minWidth,
    this.height,
    this.stroke = 0,
    this.borderColor,
    this.gap = 8,
    this.labelStyle,
    this.isImage = false,
    this.imageIcon,
    this.iconHeight,
    this.iconWidth,
    this.margin = 0,
    this.prefixIcon,
    this.suffixIcon,
    this.useThemeColors = true,
    this.isLoading = false,
    this.loadingColor,
    this.loadingSize,
    this.loadingStrokeWidth,
    this.child,
  });

  List<Widget> _buildRowChildren(BuildContext context) {
    final List<Widget> children = [];

    final bool hasPrefixContent = prefixIcon != null || imageIcon != null || image != null;
    final bool hasSuffixContent = suffixIcon != null;

    if (prefixIcon != null) {
      children.add(prefixIcon!);
    } else if (imageIcon != null) {
      children.add(
        Image.asset(
          'assets/images/$imageIcon.png',
          width: iconWidth,
          height: iconHeight,
        ),
      );
    } else if (image != null) {
      children.add(
        MySvg(
          image: image!,
          isImage: isImage,
          height: iconHeight,
          width: iconWidth,
        ),
      );
    }

    if (hasPrefixContent && label != null) {
      children.add(horizontalSpace(gap));
    }

    if (label != null) {
      children.add(
        Text(
          label!,
          style: labelStyle ?? _getDefaultLabelStyle(context),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
        ),
      );
    }

    if (hasSuffixContent && label != null) {
      children.add(horizontalSpace(gap));
    }

    if (suffixIcon != null) {
      children.add(suffixIcon!);
    }

    if (children.isEmpty) {
      children.add(const Empty());
    }

    return children;
  }

  TextStyle _getDefaultLabelStyle(BuildContext context) {
    return TextStyle(
      color: textColor ?? context.buttonTextColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (isLoading) {
      final baseColor = backgroundColor ?? (useThemeColors ? context.buttonPrimaryColor : ColorsManager.black);
      return baseColor.withValues(alpha: 0.7);
    }
    if (backgroundColor != null) return backgroundColor!;
    if (useThemeColors) return context.buttonPrimaryColor;
    return ColorsManager.black;
  }

  Color _getBorderColor(BuildContext context) {
    if (borderColor != null) return borderColor!;
    return ColorsManager.transparent;
  }

  Color _getDisabledColor(BuildContext context) {
    if (disabledColor != null) return disabledColor!;
    return context.isDark
        ? ColorsManager.darkDivider
        : ColorsManager.grey200;
  }

  Color _getSplashColor(BuildContext context) {
    if (splashColor != null) return splashColor!;
    return context.isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final size = loadingSize ?? 20.w;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedLogoLoader(size: size),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingIndicator(context);
    }

    if (child != null) {
      return child!;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildRowChildren(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: margin ?? 0),
      child: SizedBox(
        height: height,
        width: minWidth ?? double.infinity,
        child: MaterialButton(
          onPressed: isLoading ? null : onPressed,
          onLongPress: isLoading ? null : onLongPress,
          textTheme: textTheme,
          textColor: textColor ?? context.buttonTextColor,
          disabledTextColor: disabledTextColor ?? context.textSecondaryColor,
          color: _getBackgroundColor(context),
          disabledColor: isLoading ? _getBackgroundColor(context) : _getDisabledColor(context),
          focusColor: focusColor,
          hoverColor: hoverColor,
          highlightColor: highlightColor,
          splashColor: _getSplashColor(context),
          elevation: elevation,
          focusElevation: focusElevation,
          hoverElevation: hoverElevation,
          highlightElevation: highlightElevation,
          disabledElevation: disabledElevation,
          padding: padding,
          visualDensity: visualDensity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 0),
            side: BorderSide(
              color: _getBorderColor(context),
              strokeAlign: BorderSide.strokeAlignInside,
              width: stroke,
            ),
          ),
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          materialTapTargetSize: materialTapTargetSize,
          animationDuration: animationDuration,
          height: height,
          child: _buildButtonContent(context),
        ),
      ),
    );
  }
}